#include <hbapi.h>
#include <hbapiitm.h>

int ap_headers_in_count( void );
char * ap_headers_in_key( int iKey );
char * ap_headers_in_val( int iKey );

int ap_headers_out_count( void );
char * ap_headers_out_key( int iKey );
char * ap_headers_out_val( int iKey );

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSIN )
{
   PHB_ITEM hHeadersIn = hb_hashNew( NULL ); 
   int iKeys = ap_headers_in_count();

   if( iKeys > 0 )
   {
      int iKey;
      PHB_ITEM pKey = hb_itemNew( NULL );
      PHB_ITEM pValue = hb_itemNew( NULL );   

      hb_hashPreallocate( hHeadersIn, iKeys );
   
      for( iKey = 0; iKey < iKeys; iKey++ )
      {
         hb_itemPutCConst( pKey,   ap_headers_in_key( iKey ) );
         hb_itemPutCConst( pValue, ap_headers_in_val( iKey ) );
         hb_hashAdd( hHeadersIn, pKey, pValue );
      }
      
      hb_itemRelease( pKey );
      hb_itemRelease( pValue );
   }

   hb_itemReturnRelease( hHeadersIn );
}

//----------------------------------------------------------------//

HB_FUNC( AP_HEADERSOUT )
{
   PHB_ITEM hHeadersOut = hb_hashNew( NULL ); 
   int iKeys = ap_headers_out_count();

   if( iKeys > 0 )
   {
      int iKey;
      PHB_ITEM pKey = hb_itemNew( NULL );
      PHB_ITEM pValue = hb_itemNew( NULL );   

      hb_hashPreallocate( hHeadersOut, iKeys );
   
      for( iKey = 0; iKey < iKeys; iKey++ )
      {
         hb_itemPutCConst( pKey,   ap_headers_out_key( iKey ) );
         hb_itemPutCConst( pValue, ap_headers_out_val( iKey ) );
         hb_hashAdd( hHeadersOut, pKey, pValue );
      }
      
      hb_itemRelease( pKey );
      hb_itemRelease( pValue );
   }  
   
   hb_itemReturnRelease( hHeadersOut );
}

//----------------------------------------------------------------//
