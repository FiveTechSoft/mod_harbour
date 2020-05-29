#include "precomp.h"

extern "C" {

typedef int ( * PHB_APACHE )( void * pRequestRec );

   static IHttpContext * _pHttpContext;

   static IHttpContext * GetHttpContext( void )
   {
      return _pHttpContext;
   }

   static const char * ap_getenv( const char * szVarName )
   {
      PCSTR rawBuffer = NULL;
      DWORD rawLength = 0;

      GetHttpContext()->GetServerVariable( szVarName, &rawBuffer, &rawLength );

      return rawBuffer;
   }

   static int ap_rputs( const char * szText, IHttpContext * pHttpContext )
   {
      HTTP_DATA_CHUNK dataChunk;
      PCSTR pszText = ( PCSTR ) pHttpContext->AllocateRequestMemory( strlen( szText ) + 1 );
      IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

      if( pszText )
      {
         strcpy( ( char * ) pszText, szText );

         dataChunk.DataChunkType = HttpDataChunkFromMemory;
         dataChunk.FromMemory.pBuffer = ( PVOID ) pszText;
         dataChunk.FromMemory.BufferLength = ( ULONG ) strlen( pszText );

         return pHttpResponse->WriteEntityChunkByReference( &dataChunk, -1 );
      }
      else
         return 0;
   }

   char * GetErrorMessage( DWORD dwLastError )
   {
      LPVOID lpMsgBuf;

      FormatMessage( FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
         NULL,
         dwLastError,
         MAKELANGID( LANG_NEUTRAL, SUBLANG_DEFAULT ), // Default language
         ( LPTSTR ) &lpMsgBuf,
         0,
         NULL );

      return ( char * ) lpMsgBuf;
      LocalFree( lpMsgBuf );
   }

static char * strrstr( const char * str, const char * strSearch )
{
   char * ptr = ( char * ) str, * last = NULL;

   while( ( ptr = strstr( ptr, strSearch ) ) )
      last = ptr++;

   return last;
}

static void ap_set_contenttype( const char * szContentType, IHttpContext * pHttpContext )
{
   IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

   pHttpResponse->SetHeader( "Content-Type", szContentType, strlen( szContentType ), true );
}

REQUEST_NOTIFICATION_STATUS CMyHttpModule::OnAcquireRequestState( IN IHttpContext * pHttpContext,
   IN OUT IHttpEventProvider * pProvider )
{
   const char * szPathInfo;

   _pHttpContext = pHttpContext;

   szPathInfo = ap_getenv( "PATH_INFO" );

   if( strstr( szPathInfo, ".prg" ) || strstr( szPathInfo, ".hrb" ) )
   {
      HMODULE lib_harbour;
      char * szModHarbourPath = ( char * ) pHttpContext->AllocateRequestMemory( MAX_PATH + 1 );
      WCHAR * szModHarbourPathW = ( WCHAR * ) pHttpContext->AllocateRequestMemory( ( MAX_PATH + 1 ) * 2 );
      char * szTempPath = ( char * ) pHttpContext->AllocateRequestMemory( MAX_PATH + 1 );
      char * szTempFileName = ( char * ) pHttpContext->AllocateRequestMemory( MAX_PATH + 1 );
      char * szDllName = ( char * ) pHttpContext->AllocateRequestMemory( MAX_PATH + 1 );
      SYSTEMTIME time;

      GetModuleFileName( GetModuleHandle( "mod_harbour.dll" ), szDllName, MAX_PATH + 1 );
      strcpy( szModHarbourPath, szDllName );
      * ( strrstr( szModHarbourPath, "\\" ) + 1 ) = 0;
      strcpy( strrstr( szDllName, "\\" ) + 1, "libharbour.dll" );

      GetTempPath( MAX_PATH + 1, szTempPath );
      GetSystemTime( &time );
      wsprintf( szTempFileName, "%s%s.%d.%d", szTempPath, "libharbour", GetCurrentThreadId(), ( int ) time.wMilliseconds );
      CopyFile( szDllName, szTempFileName, 0 );

      SetDefaultDllDirectories( LOAD_LIBRARY_SEARCH_DEFAULT_DIRS );
      MultiByteToWideChar( CP_ACP, MB_COMPOSITE, szModHarbourPath, -1, szModHarbourPathW, MAX_PATH + 1 );
      AddDllDirectory( szModHarbourPathW );
      lib_harbour = LoadLibrary( szTempFileName );

      ap_set_contenttype( "text/html", pHttpContext );

      if( lib_harbour == NULL )
      {
         char * szErrorMessage = GetErrorMessage( GetLastError() );
         ap_rputs( "mod_harbour error:<br>", pHttpContext );
         ap_rputs( szTempFileName, pHttpContext );
         ap_rputs( "<br>", pHttpContext );
         ap_rputs( szErrorMessage, pHttpContext );
         LocalFree( ( void * ) szErrorMessage );
      }
      else
      {
         PHB_APACHE _hb_apache = ( PHB_APACHE ) GetProcAddress( lib_harbour, "hb_apache" );

         if( _hb_apache != NULL )
            _hb_apache( pHttpContext );
         else   
            ap_rputs( "can't find hb_apache()", pHttpContext );
      }

      if( lib_harbour )
      {
         FreeLibrary( lib_harbour );
         DeleteFile( szTempFileName );
      }

      return RQ_NOTIFICATION_FINISH_REQUEST;
   }
   else
      return RQ_NOTIFICATION_CONTINUE;
}

}
