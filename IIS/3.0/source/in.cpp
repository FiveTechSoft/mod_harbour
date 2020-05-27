#define WIN32_LEAN_AND_MEAN
#include "httpserv.h"
#include <hbapi.h>

extern "C" {

IHttpContext * GetHttpContext( void );

const char * ap_getenv( const char * szVarName )
{
   PCSTR rawBuffer = NULL;
   DWORD rawLength = 0;

   GetHttpContext()->GetServerVariable( szVarName, &rawBuffer, &rawLength );

   return rawBuffer;
}
   
const char * ap_headers_in_key( int iKey, IHttpContext * pHttpContext )
{
   const char * szHeaders = ap_getenv( "ALL_RAW" );
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
   const char * szHeaders = ap_getenv( "ALL_RAW" );
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
   const char * szHeaders = ap_getenv( "ALL_RAW" );
   int iCount = 0; char * pPos = ( char * ) szHeaders;

   while( pPos = strstr( pPos, "\r\n" ) )
   {
      pPos += strlen( "\r\n" ) + 1;
      iCount++;
   }

   return iCount;
}

HB_FUNC( AP_ARGS )
{
   hb_retc( ap_getenv( "QUERY_STRING" ) );
}

HB_FUNC( AP_METHOD )
{
   hb_retc( ap_getenv( "REQUEST_METHOD" ) );
}

HB_FUNC( AP_USERIP )
{
   hb_retc( ap_getenv( "REMOTE_ADDR" ) );
}

HB_FUNC( AP_BODY )
{
   IHttpContext * pHttpContext = GetHttpContext();
   DWORD bytesRead = 0;
   int totalBytesRead = 0;
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

}
