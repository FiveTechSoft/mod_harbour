#define WIN32_LEAN_AND_MEAN
#include "httpserv.h"
#include <hbapi.h>
#include <hbapiitm.h>

extern "C" {

IHttpContext * GetRequestRec( void );

//----------------------------------------------------------------//

IHttpContext * GetHttpContext( void )
{
   return GetRequestRec();
}

//----------------------------------------------------------------//

const char * ap_getenv( const char * szVarName )
{
   PCSTR rawBuffer = NULL;
   DWORD rawLength = 0;

   GetHttpContext()->GetServerVariable( szVarName, &rawBuffer, &rawLength );

   return rawBuffer;
}

//----------------------------------------------------------------//

HB_FUNC( AP_GETENV )
{
   hb_retc( ap_getenv( hb_parc( 1 ) ) );
}

//----------------------------------------------------------------//

const char * ap_headers_in_key( int iKey )
{
   IHttpContext * pHttpContext = GetHttpContext();
   const char * szHeaders = ap_getenv( "ALL_RAW" );
   int iCount = 1; char * pPos = ( char * ) szHeaders;

   while( ( iCount < iKey ) && ( ( pPos = strstr( pPos, "\r\n" ), pPos ) ) )
   {
      pPos += strlen( "\r\n" );
      iCount++;
   }

   if( pPos )
   {
      char * pStart = pPos;

      if( ( pPos = strstr( pPos, ": " ), pPos ) )
      {
         char * buffer = ( char * ) pHttpContext->AllocateRequestMemory( ( DWORD ) ( pPos - pStart + 1 ) );

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

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSINKEY )
{
   hb_retc( ap_headers_in_key( hb_parnl( 1 ) ) );
}

//----------------------------------------------------------------//

const char * ap_headers_in_val( int iKey )
{
   IHttpContext * pHttpContext = GetHttpContext();
   const char * szHeaders = ap_getenv( "ALL_RAW" );
   int iCount = 1; char * pPos = ( char * ) szHeaders;

   while( ( iCount < iKey ) && ( ( pPos = strstr( pPos, "\r\n" ), pPos ) ) )
   {
      pPos += strlen( "\r\n" );
      iCount++;
   }

   if( pPos )
   {
      char * pStart = strstr( pPos, ": " ) + 2;

      if( ( pPos = strstr( pPos, "\r\n" ), pPos ) )
      {
         char * buffer = ( char * ) pHttpContext->AllocateRequestMemory( ( DWORD ) ( pPos - pStart + 1 ) );

         memcpy( buffer, pStart, pPos - pStart );
         buffer[ pPos - pStart ] = 0;
         return buffer;
      }
      else
         return "";

   }
   else
      return "";
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSINVAL )
{
   hb_retc( ap_headers_in_val( hb_parnl( 1 ) ) );
}

//----------------------------------------------------------------//

int ap_headers_in_count( void )
{
   const char * szHeaders = ap_getenv( "ALL_RAW" );
   int iCount = 0; char * pPos = ( char * ) szHeaders;

   while( ( pPos = strstr( pPos, "\r\n" ), pPos ) )
   {
      pPos += strlen( "\r\n" ) + 1;
      iCount++;
   }

   return iCount;
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSINCOUNT )
{
   hb_retnl( ap_headers_in_count() );
}

//----------------------------------------------------------------//

HB_FUNC( AP_ARGS )
{
   hb_retc( ap_getenv( "QUERY_STRING" ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_FILENAME )
{
   char szPath[ MAX_PATH + 1 ];

   strcpy_s( szPath, MAX_PATH + 1, ap_getenv( "APPL_PHYSICAL_PATH" ) );
   strcat_s( szPath, MAX_PATH + 1, ap_getenv( "PATH_INFO" ) );
   while( strchr( szPath, '\\' ) )
      * strchr( szPath, '\\' ) = '/';
       
   hb_retc( szPath );    
}

//----------------------------------------------------------------//

HB_FUNC( AP_METHOD )
{
   hb_retc( ap_getenv( "REQUEST_METHOD" ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_USERIP )
{
   hb_retc( ap_getenv( "REMOTE_ADDR" ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_BODY )
{
   IHttpContext * pHttpContext = GetHttpContext();
   DWORD bytesRead = 0;
   int bytesToRead = atoi( ap_getenv( "CONTENT_LENGTH" ) ), iSize;
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

      * ( buffer + iSize ) = 0;
   }

   hb_retc( buffer );
}

//----------------------------------------------------------------//

}