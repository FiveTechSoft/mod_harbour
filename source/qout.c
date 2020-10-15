#include <hbapi.h>
#include <hbapiitm.h>
#include <hbvm.h>

int mh_rputs( const char * szText );

//----------------------------------------------------------------//

HB_FUNC( AP_RPUTS )
{
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
         mh_rputs( hb_parc( -1 ) );
      }
      else if( HB_ISHASH( iParam ) || HB_ISARRAY( iParam ) )
      {
         hb_vmPushSymbol( hb_dynsymGetSymbol( "VALTOCHAR" ) );
         hb_vmPushNil();
         hb_vmPush( pItem );
         hb_vmFunction( 1 );
         mh_rputs( hb_parc( -1 ) );
      }
      else
      {
         HB_SIZE nLen;
         HB_BOOL bFreeReq;
         char * buffer = hb_itemString( pItem, &nLen, &bFreeReq );

         mh_rputs( buffer );
         mh_rputs( " " ); 

         if( bFreeReq )
            hb_xfree( buffer );
      }      
   }

   hb_ret();     
}

//----------------------------------------------------------------//

HB_FUNC( MODBUILDDATE )
{
   char * pszDate;
   
   pszDate = ( char * ) hb_xgrab( 64 );
   hb_snprintf( pszDate, 64, "%s %s", __DATE__, __TIME__ );
   
   hb_retc_buffer( pszDate );
}

//----------------------------------------------------------------//
