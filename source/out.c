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

HB_FUNC( AP_HEADERSOUTCOUNT )
{
   hb_retnl( apr_table_elts( GetRequestRec()->headers_out )->nelts );
}

//----------------------------------------------------------------//

const char * ap_headers_out_key( int iKey, request_rec * r )
{
   const apr_array_header_t * fields = apr_table_elts( r->headers_out );
   apr_table_entry_t * e = ( apr_table_entry_t * ) fields->elts;

   if( iKey >= 0 && iKey < fields->nelts )
      return e[ iKey ].key;
   else
      return "";
}

//----------------------------------------------------------------//

const char * ap_headers_out_val( int iKey, request_rec * r )
{
   const apr_array_header_t * fields = apr_table_elts( r->headers_out );
   apr_table_entry_t * e = ( apr_table_entry_t * ) fields->elts;

   if( iKey >= 0 && iKey < fields->nelts )
      return e[ iKey ].val;
   else
      return "";
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTKEY )
{
   hb_retc( ap_headers_out_key( hb_parnl( 1 ), GetRequestRec() ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTVAL )
{
   hb_retc( ap_headers_out_val( hb_parnl( 1 ), GetRequestRec() ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUTSET )
{
   apr_table_add( GetRequestRec()->headers_out, hb_parc( 1 ), hb_parc( 2 ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUT )
{
   request_rec * r = GetRequestRec();
   PHB_ITEM hHeadersOut = hb_hashNew( NULL ); 
   int iKeys = apr_table_elts( r->headers_out )->nelts;

   if( iKeys > 0 )
   {
      int iKey;
      PHB_ITEM pKey = hb_itemNew( NULL );
      PHB_ITEM pValue = hb_itemNew( NULL );   

      hb_hashPreallocate( hHeadersOut, iKeys );
   
      for( iKey = 0; iKey < iKeys; iKey++ )
      {
         hb_itemPutCConst( pKey,   ap_headers_out_key( iKey, r ) );
         hb_itemPutCConst( pValue, ap_headers_out_val( iKey, r ) );
         hb_hashAdd( hHeadersOut, pKey, pValue );
      }
      
      hb_itemRelease( pKey );
      hb_itemRelease( pValue );
   }  
   
   hb_itemReturnRelease( hHeadersOut );
}

//----------------------------------------------------------------//

HB_FUNC( AP_RPUTS )
{
   request_rec * r = GetRequestRec();
   int iParams = hb_pcount(), iParam;

   for( iParam = 1; iParam <= iParams; iParam++ )
   {
      PHB_ITEM pItem = hb_param( iParam, HB_IT_ANY );

      if( HB_ISOBJECT( iParam ) )
      {
         hb_vmPushSymbol( hb_dynsymGetSymbol( "OBJTOCHAR" ) );
         hb_vmPushNil();
         hb_vmPush( pItem );
         hb_vmFunction( 1 );
         ap_rputs( hb_parc( -1 ), r );
      }
      else if( HB_ISHASH( iParam ) || HB_ISARRAY( iParam ) )
      {
         hb_vmPushSymbol( hb_dynsymGetSymbol( "VALTOCHAR" ) );
         hb_vmPushNil();
         hb_vmPush( pItem );
         hb_vmFunction( 1 );
         ap_rputs( hb_parc( -1 ), r );
      }
      else
      {
         HB_SIZE nLen;
         HB_BOOL bFreeReq;
         char * buffer = hb_itemString( pItem, &nLen, &bFreeReq );

         ap_rputs( buffer, r );
         ap_rputs( " ", r ); 

         if( bFreeReq )
            hb_xfree( buffer );
      }      
   }

   hb_ret();     
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
