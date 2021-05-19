#include <ngx_mod_harbour.h>
#include <hbapi.h>

//----------------------------------------------------------------//
   
const char * ap_headers_out_key( int iKey )
{

   return "";
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTKEY )
{
   hb_retc( ap_headers_out_key( hb_parnl( 1 ) ) );
}

//----------------------------------------------------------------//

const char * ap_headers_out_val( int iKey )
{

   return "";
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTVAL )
{
   hb_retc( ap_headers_out_val( hb_parnl( 1 ) ) );
}

//----------------------------------------------------------------//

void ap_headers_out_set( const char * szKey, const char * szValue )
{
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTSET )
{
   ap_headers_out_set( hb_parc( 1 ), hb_parc( 2 ) );
}

//----------------------------------------------------------------//

int mh_rputs( const char * szText )
{
   NGX_API * pNgxApi = ( NGX_API * ) GetNgxApi();
   
   return pNgxApi->mh_rputs( GetRequestRec(), ( const char * ) szText );
}

//----------------------------------------------------------------//

HB_FUNC( AP_RWRITE )
{
   const char * szText = hb_parc( 1 );
   
   /*
   if( pszText )
   {
      strcpy_s( ( char * ) pszText, hb_parclen( 1 ) + 1, szText );

      dataChunk.DataChunkType = HttpDataChunkFromMemory;
      dataChunk.FromMemory.pBuffer = ( PVOID ) pszText;
      dataChunk.FromMemory.BufferLength = ( ULONG ) hb_parclen( 1 );

      hb_retnl( pHttpResponse->WriteEntityChunkByReference( &dataChunk, -1 ) );
   }
   else
   */
      hb_retnl( 0 );
}

//----------------------------------------------------------------//

HB_FUNC( AP_SETCONTENTTYPE )
{
}

//----------------------------------------------------------------//

int ap_headers_out_count( void )
{
   return 0;
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTCOUNT )
{
   hb_retnl( ap_headers_out_count() );
}

//----------------------------------------------------------------//
