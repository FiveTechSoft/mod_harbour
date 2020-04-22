#include "precomp.h"

extern "C" {
typedef int ( * PHB_APACHE )( void * pRequestRec, void * pAPRPuts, 
                              const char * szFileName, const char * szArgs, const char * szMethod, const char * szUserIP,
                              void * pHeadersIn, void * pHeadersOut, 
                              void * pHeadersInCount, void * pHeadersInKey, void * pHeadersInVal, 
                              void * pHeadersOutCount, void * pHeadersOutKey, void * pHeadersOutVal, void * pHeadersOutSet, 
                              void * pSetContentType, void * pApacheGetenv, void * pAPBody );

   const char * ap_getenv( const char * szVarName, IHttpContext * pHttpContext );

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

   int ap_rputs( const char * szText, IHttpContext * pHttpContext )
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

   int ap_headers_out_count( IHttpContext * pHttpContext )
   {
      IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

      return pHttpResponse->GetRawHttpResponse()->Headers.UnknownHeaderCount;
   }

   const char * ap_headers_out_key( int iKey, IHttpContext * pHttpContext )
   {
      IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

      return pHttpResponse->GetRawHttpResponse()->Headers.pUnknownHeaders[ iKey ].pName;
   }

   const char * ap_headers_out_val( int iKey, IHttpContext * pHttpContext )
   {
      IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

      return pHttpResponse->GetRawHttpResponse()->Headers.pUnknownHeaders[ iKey ].pRawValue;
   }

   void ap_headers_out_set( const char * szKey, const char * szValue, IHttpContext * pHttpContext )
   {
      IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

      pHttpResponse->SetHeader( szKey, szValue, strlen( szValue ), true );
   }

   const char * ap_headers_in_key( int iKey, IHttpContext * pHttpContext )
   {
      const char * szHeaders = ap_getenv( "ALL_RAW", pHttpContext );
      int iCount = 1; char * pPos = ( char * ) szHeaders;

      while( ( iCount < iKey ) && ( pPos = strstr( pPos, "\r\n" ) ) )
      {
         pPos += strlen( "\r\n" );
         iCount++;
      }

      if( pPos )
      {
         char * pStart = pPos;

         if( pPos = strstr( pPos, ": " ) )
         {
            char * buffer = ( char * ) pHttpContext->AllocateRequestMemory( pPos - pStart + 1 );

            memcpy( buffer, pStart, pPos - pStart );
            buffer[pPos - pStart] = 0;
            return buffer;
         }
         else
            return "";

      }
      else
         return "";
   }

   const char * ap_headers_in_val( int iKey, IHttpContext * pHttpContext )
   {
      const char * szHeaders = ap_getenv( "ALL_RAW", pHttpContext );
      int iCount = 1; char * pPos = ( char * ) szHeaders;

      while( ( iCount < iKey ) && ( pPos = strstr( pPos, "\r\n" ) ) )
      {
         pPos += strlen( "\r\n" );
         iCount++;
      }

      if( pPos )
      {
         char * pStart = strstr( pPos, ": " ) + 2;

         if( pPos = strstr( pPos, "\r\n" ) )
         {
            char * buffer = ( char * ) pHttpContext->AllocateRequestMemory( pPos - pStart + 1 );

            memcpy( buffer, pStart, pPos - pStart );
            buffer[pPos - pStart] = 0;
            return buffer;
         }
         else
            return "";

      }
      else
         return "";
   }

   int ap_headers_in_count( IHttpContext * pHttpContext )
   {
      const char * szHeaders = ap_getenv( "ALL_RAW", pHttpContext );
      int iCount = 0; char * pPos = ( char * ) szHeaders;

      while( pPos = strstr( pPos, "\r\n" ) )
      {
         pPos += strlen( "\r\n" ) + 1;
         iCount++;
      }

      return iCount;
   }

   void ap_set_contenttype( const char * szContentType, IHttpContext * pHttpContext )
   {
      IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

      pHttpResponse->SetHeader( "Content-Type", szContentType, strlen( szContentType ), true );
   }

   const char * ap_getenv( const char * szVarName, IHttpContext * pHttpContext )
   {
      PCSTR rawBuffer = NULL;
      DWORD rawLength = 0;

      pHttpContext->GetServerVariable( szVarName, &rawBuffer, &rawLength );

      return rawBuffer;
   }

   const char * ap_args( IHttpContext * pHttpContext )
   {
      return ap_getenv( "QUERY_STRING", pHttpContext );
   }

   const char * ap_body( IHttpContext * pHttpContext )
   {
      DWORD bytesRead = 0;
      int totalBytesRead = 0;
      int bytesToRead = atoi( ap_getenv( "CONTENT_LENGTH", pHttpContext ) ), iSize;
      IHttpRequest * request = pHttpContext->GetRequest();
      char * buffer = ( char * ) pHttpContext->AllocateRequestMemory( bytesToRead );
      BOOL bCompletionPending = false;

      iSize = bytesToRead;

      if( buffer )
      {
         while( bytesToRead > 0 )
         {
            request->ReadEntityBody( ( char * ) ( buffer + bytesRead ), bytesToRead, false, &bytesRead, &bCompletionPending );

            if( !bytesRead )
               break;

            bytesToRead -= bytesRead;
         }

         *( buffer + iSize ) = 0;
      }

      return buffer;
   }
}

static long lAPRemaining = 0;

static char * strrstr( const char * str, const char * strSearch )
{
   char * ptr = ( char * ) str, * last = NULL;

   while( ( ptr = strstr( ptr, strSearch ) ) )
      last = ptr++;

   return last;
}

REQUEST_NOTIFICATION_STATUS CMyHttpModule::OnAcquireRequestState( IN IHttpContext * pHttpContext,
   IN OUT IHttpEventProvider * pProvider )
{
   const char * szPathInfo;

   szPathInfo = ap_getenv( "PATH_INFO", pHttpContext );

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
         char szPath[ MAX_PATH + 1 ];

         strcpy( szPath, ap_getenv( "APPL_PHYSICAL_PATH", pHttpContext ) );
         strcat( szPath, szPathInfo + 1 );
         while( strchr( szPath, '\\' ) )
            * strchr( szPath, '\\' ) = '/';

         if( _hb_apache != NULL )
         {
            _hb_apache( pHttpContext, ( void * ) ap_rputs, szPath, ap_args( pHttpContext ),
                        ap_getenv( "REQUEST_METHOD", pHttpContext ), ap_getenv( "REMOTE_ADDR", pHttpContext ),
                        NULL, NULL,
                        ( void * ) ap_headers_in_count, ( void * ) ap_headers_in_key, ( void * ) ap_headers_in_val,
                        ( void * ) ap_headers_out_count, ( void * ) ap_headers_out_key, ( void * ) ap_headers_out_val,
                        ( void * ) ap_headers_out_set, ( void * ) ap_set_contenttype,
                        ( void * ) ap_getenv, ( void * ) ap_body );
         }

         if( _hb_apache == NULL )
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
