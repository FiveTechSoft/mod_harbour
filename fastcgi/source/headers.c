#include <hbapi.h>
#include <hbapiitm.h>

int mh_headers_in_count( void );
char * mh_headers_in_key( int iKey );
char * mh_headers_in_val( int iKey );

//----------------------------------------------------------------//

HB_FUNC( MH_HEADERSIN )
{
   PHB_ITEM hHeadersIn = hb_hashNew( NULL ); 
   int iKeys = mh_headers_in_count();

   if( iKeys > 0 )
   {
      int iKey;
      PHB_ITEM pKey = hb_itemNew( NULL );
      PHB_ITEM pValue = hb_itemNew( NULL );   

      hb_hashPreallocate( hHeadersIn, iKeys );
   
      for( iKey = 0; iKey < iKeys; iKey++ )
      {
         hb_itemPutNil( pKey );
         hb_itemPutNil( pValue );
         hb_itemPutC( pKey,   mh_headers_in_key( iKey ) );
         hb_itemPutC( pValue, mh_headers_in_val( iKey ) );
         hb_hashAdd( hHeadersIn, pKey, pValue );
      }
      
      hb_itemRelease( pKey );
      hb_itemRelease( pValue );
   }  
   
   hb_itemReturnRelease( hHeadersIn );
}

//----------------------------------------------------------------//
