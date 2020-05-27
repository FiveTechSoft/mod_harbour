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
