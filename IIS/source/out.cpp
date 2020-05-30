#define WIN32_LEAN_AND_MEAN
#include "httpserv.h"
#include <hbapi.h>

extern "C" {

IHttpContext * GetHttpContext( void );

//----------------------------------------------------------------//
   
const char * ap_headers_out_key( int iKey )
{
   IHttpContext * pHttpContext = GetHttpContext();
   IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

   return pHttpResponse->GetRawHttpResponse()->Headers.pUnknownHeaders[ iKey ].pName;
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTKEY )
{
   hb_retc( ap_headers_out_key( hb_parnl( 1 ) ) );
}

//----------------------------------------------------------------//

const char * ap_headers_out_val( int iKey )
{
   IHttpContext * pHttpContext = GetHttpContext();
   IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

   return pHttpResponse->GetRawHttpResponse()->Headers.pUnknownHeaders[ iKey ].pRawValue;
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTVAL )
{
   hb_retc( ap_headers_out_val( hb_parnl( 1 ) ) );
}

//----------------------------------------------------------------//

void ap_headers_out_set( const char * szKey, const char * szValue )
{
   IHttpContext * pHttpContext = GetHttpContext();
   IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

   pHttpResponse->SetHeader( szKey, szValue, ( USHORT ) strlen( szValue ), true );
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTSET )
{
   ap_headers_out_set( hb_parc( 1 ), hb_parc( 2 ) );
}

//----------------------------------------------------------------//

int mh_rputs( const char * szText )
{
   IHttpContext * pHttpContext = GetHttpContext();
   HTTP_DATA_CHUNK dataChunk;
   PCSTR pszText = ( PCSTR ) pHttpContext->AllocateRequestMemory( ( DWORD ) ( strlen( szText ) + 1 ) );
   IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

   if( pszText )
   {
      strcpy_s( ( char * ) pszText, strlen( szText ) + 1, szText );

      dataChunk.DataChunkType = HttpDataChunkFromMemory;
      dataChunk.FromMemory.pBuffer = ( PVOID ) pszText;
      dataChunk.FromMemory.BufferLength = ( ULONG ) strlen( pszText );

      return pHttpResponse->WriteEntityChunkByReference( &dataChunk, -1 );
   }
   else
      return 0;
}

//----------------------------------------------------------------//

HB_FUNC( AP_RWRITE )
{
   const char * szText = hb_parc( 1 );
   HTTP_DATA_CHUNK dataChunk;
   IHttpContext * pHttpContext = GetHttpContext();
   PCSTR pszText = ( PCSTR ) pHttpContext->AllocateRequestMemory( ( DWORD ) ( hb_parclen( 1 ) + 1 ) );
   IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

   if( pszText )
   {
      strcpy_s( ( char * ) pszText, hb_parclen( 1 ) + 1, szText );

      dataChunk.DataChunkType = HttpDataChunkFromMemory;
      dataChunk.FromMemory.pBuffer = ( PVOID ) pszText;
      dataChunk.FromMemory.BufferLength = ( ULONG ) hb_parclen( 1 );

      hb_retnl( pHttpResponse->WriteEntityChunkByReference( &dataChunk, -1 ) );
   }
   else
      hb_retnl( 0 );
}

//----------------------------------------------------------------//

HB_FUNC( AP_SETCONTENTTYPE )
{
   IHttpContext * pHttpContext = GetHttpContext();
   IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

   pHttpResponse->SetHeader( "Content-Type", hb_parc( 1 ), ( USHORT ) hb_parclen( 1 ), true );
}

//----------------------------------------------------------------//

int ap_headers_out_count( void )
{
   IHttpContext * pHttpContext = GetHttpContext();
   IHttpResponse * pHttpResponse = pHttpContext->GetResponse();

   return pHttpResponse->GetRawHttpResponse()->Headers.UnknownHeaderCount;
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTCOUNT )
{
   hb_retnl( ap_headers_out_count() );
}

//----------------------------------------------------------------//

}