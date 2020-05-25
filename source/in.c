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

//----------------------------------------------------------------//

HB_FUNC( AP_ARGS )
{
   hb_retc( GetRequestRec()->args ); 
}

//----------------------------------------------------------------//

HB_FUNC( AP_BODY )
{
   request_rec * r = GetRequestRec();
 
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
      }
      else
         hb_retc( "" );
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

HB_FUNC( AP_HEADERSINCOUNT )
{
   hb_retnl( apr_table_elts( GetRequestRec()->headers_in )->nelts );
}

//----------------------------------------------------------------//

const char * ap_headers_in_key( int iKey, request_rec * r )
{
   const apr_array_header_t * fields = apr_table_elts( r->headers_in );
   apr_table_entry_t * e = ( apr_table_entry_t * ) fields->elts;

   if( iKey >= 0 && iKey < fields->nelts )
      return e[ iKey ].key;
   else
      return "";
}

//----------------------------------------------------------------//

const char * ap_headers_in_val( int iKey, request_rec * r )
{
   const apr_array_header_t * fields = apr_table_elts( r->headers_in );
   apr_table_entry_t * e = ( apr_table_entry_t * ) fields->elts;

   if( iKey >= 0 && iKey < fields->nelts )
      return e[ iKey ].val;
   else
      return "";
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSINKEY )
{
   hb_retc( ap_headers_in_key( hb_parnl( 1 ), GetRequestRec() ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSINVAL )
{
   hb_retc( ap_headers_in_val( hb_parnl( 1 ), GetRequestRec() ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSIN )
{
   request_rec * r = GetRequestRec();
   PHB_ITEM hHeadersIn = hb_hashNew( NULL ); 
   int iKeys = apr_table_elts( GetRequestRec()->headers_in )->nelts;

   if( iKeys > 0 )
   {
      int iKey;
      PHB_ITEM pKey = hb_itemNew( NULL );
      PHB_ITEM pValue = hb_itemNew( NULL );   

      hb_hashPreallocate( hHeadersIn, iKeys );
   
      for( iKey = 0; iKey < iKeys; iKey++ )
      {
         hb_itemPutCConst( pKey,   ap_headers_in_key( iKey, r ) );
         hb_itemPutCConst( pValue, ap_headers_in_val( iKey, r ) );
         hb_hashAdd( hHeadersIn, pKey, pValue );
      }
      
      hb_itemRelease( pKey );
      hb_itemRelease( pValue );
   }  
   
   hb_itemReturnRelease( hHeadersIn );
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
