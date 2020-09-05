/*
**  out.c -- Apache API out module
**
** (c) FiveTech Software SL, 2019-2020
** Developed by Antonio Linares alinares@fivetechsoft.com
** MIT license https://github.com/FiveTechSoft/mod_harbour/blob/master/LICENSE
*/

#include <http_protocol.h>
#include <apr_pools.h>
#include <hbapi.h>
#include <hbapiitm.h>
#include <hbvm.h>

request_rec * GetRequestRec( void );

//----------------------------------------------------------------//

int mh_rputs( const char * szText )
{
   return ap_rputs( szText, GetRequestRec() );
}

//----------------------------------------------------------------//

int ap_headers_out_count( void )
{
   return apr_table_elts( GetRequestRec()->headers_out )->nelts;
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTCOUNT )
{
   hb_retnl( ap_headers_out_count() );
}

//----------------------------------------------------------------//

const char * ap_headers_out_key( int iKey )
{
   const apr_array_header_t * fields = apr_table_elts( GetRequestRec()->headers_out );
   apr_table_entry_t * e = ( apr_table_entry_t * ) fields->elts;

   if( iKey >= 0 && iKey < fields->nelts )
      return e[ iKey ].key;
   else
      return "";
}

//----------------------------------------------------------------//

const char * ap_headers_out_val( int iKey )
{
   const apr_array_header_t * fields = apr_table_elts( GetRequestRec()->headers_out );
   apr_table_entry_t * e = ( apr_table_entry_t * ) fields->elts;

   if( iKey >= 0 && iKey < fields->nelts )
      return e[ iKey ].val;
   else
      return "";
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTKEY )
{
   hb_retc( ap_headers_out_key( hb_parnl( 1 ) ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTVAL )
{
   hb_retc( ap_headers_out_val( hb_parnl( 1 ) ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTSET )
{
   apr_table_add( GetRequestRec()->headers_out, hb_parc( 1 ), hb_parc( 2 ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_RWRITE )
{
   hb_retni( ap_rwrite( ( void * ) hb_parc( 1 ), ( int ) hb_parclen( 1 ), GetRequestRec() ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_SETCONTENTTYPE ) // szContentType
{
   request_rec * r = GetRequestRec();
   char * szType = ( char * ) apr_pcalloc( r->pool, hb_parclen( 1 ) + 1 );
   
   strcpy( szType, hb_parc( 1 ) );   
   r->content_type = szType;
}

//----------------------------------------------------------------//
