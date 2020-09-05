/*
**  in.c -- Apache API in wrappers
**
** (c) FiveTech Software SL, 2019-2020
** Developed by Antonio Linares alinares@fivetechsoft.com
** MIT license https://github.com/FiveTechSoft/mod_harbour/blob/master/LICENSE
*/

#include <http_protocol.h>
#include <apr_pools.h>
#include <hbapi.h>
#include <hbapiitm.h>

request_rec * GetRequestRec( void );

char * szBody = NULL;

//----------------------------------------------------------------//

HB_FUNC( AP_ARGS )
{
   hb_retc( GetRequestRec()->args ); 
}

//----------------------------------------------------------------//

HB_FUNC( AP_BODY )
{
   request_rec * r = GetRequestRec();
 
   if( szBody )
      hb_retc( szBody );
   else
   {   
      if( ap_setup_client_block( r, REQUEST_CHUNKED_ERROR ) != OK )
         hb_retc( "" );
      else
      {   
         if( ap_should_client_block( r ) )
         {
            long length = ( long ) r->remaining;
            char * rbuf = ( char * ) apr_pcalloc( r->pool, length + 1 );
            int iRead = 0, iTotal = 0;
      
            while( ( iRead = ap_get_client_block( r, rbuf + iTotal, length + 1 - iTotal ) ) < ( length + 1 - iTotal ) && iRead != 0 )
            {
               iTotal += iRead;
               iRead = 0;
            }
            hb_retc( rbuf );
            szBody = ( char * ) hb_xgrab( strlen( rbuf ) + 1 );
            strcpy( szBody, rbuf );
         }
         else
            hb_retc( "" );
      }
   }   
}

//----------------------------------------------------------------//

HB_FUNC( AP_FILENAME )
{
   hb_retc( GetRequestRec()->filename );
}

//----------------------------------------------------------------//

HB_FUNC( AP_GETENV )
{
   hb_retc( apr_table_get( GetRequestRec()->subprocess_env, hb_parc( 1 ) ) );
}   

//----------------------------------------------------------------//

int ap_headers_in_count( void )
{
   return apr_table_elts( GetRequestRec()->headers_in )->nelts;
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSINCOUNT )
{
   hb_retnl( ap_headers_in_count() );
}

//----------------------------------------------------------------//

const char * ap_headers_in_key( int iKey )
{
   const apr_array_header_t * fields = apr_table_elts( GetRequestRec()->headers_in );
   apr_table_entry_t * e = ( apr_table_entry_t * ) fields->elts;

   if( iKey >= 0 && iKey < fields->nelts )
      return e[ iKey ].key;
   else
      return "";
}

//----------------------------------------------------------------//

const char * ap_headers_in_val( int iKey )
{
   const apr_array_header_t * fields = apr_table_elts( GetRequestRec()->headers_in );
   apr_table_entry_t * e = ( apr_table_entry_t * ) fields->elts;

   if( iKey >= 0 && iKey < fields->nelts )
      return e[ iKey ].val;
   else
      return "";
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSINKEY )
{
   hb_retc( ap_headers_in_key( hb_parnl( 1 ) ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSINVAL )
{
   hb_retc( ap_headers_in_val( hb_parnl( 1 ) ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_METHOD )
{
   hb_retc( GetRequestRec()->method );
}

//----------------------------------------------------------------//

HB_FUNC( AP_USERIP )
{
   hb_retc( GetRequestRec()->useragent_ip );
}

//----------------------------------------------------------------//
