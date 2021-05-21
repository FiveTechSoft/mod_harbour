#include <ngx_mod_harbour.h>
#include <hbapi.h>

//----------------------------------------------------------------//

HB_FUNC( AP_ARGS )
{
   NGX_API * pNgxApi = GetNgxApi();
  
   hb_retc( pNgxApi->mh_args( GetRequestRec() ) );
}  

//----------------------------------------------------------------//

HB_FUNC( AP_FILENAME )
{
   NGX_API * pNgxApi = GetNgxApi();
  
   hb_retc( pNgxApi->mh_args( GetRequestRec() ) );
}

//----------------------------------------------------------------//

HB_FUNC( AP_BODY )
{
   NGX_API * pNgxApi = GetNgxApi();
  
   hb_retc( "AP_BODY() not implemented yet" );
}

//----------------------------------------------------------------//

HB_FUNC( AP_GETENV )
{
   NGX_API * pNgxApi = GetNgxApi();
   
   hb_retc( "AP_GETENV() not implemented yet" );
} 
   
//----------------------------------------------------------------//
   
HB_FUNC( AP_HEADERSINCOUNT )
{
   NGX_API * pNgxApi = GetNgxApi();

   hb_retnl( 0 ); // ap_headers_in_count() );
}   
   
//----------------------------------------------------------------//
   
HB_FUNC( AP_HEADERSINKEY )
{
   NGX_API * pNgxApi = GetNgxApi();

   hb_retc( "AP_HEADERSINKEY() not implemented yet" );
}   
   
//----------------------------------------------------------------//
   
HB_FUNC( AP_HEADERSINVAL )
{
   NGX_API * pNgxApi = GetNgxApi();

   hb_retc( "AP_HEADERSINVAL() not implemented yet" );
}   
   
//----------------------------------------------------------------//

HB_FUNC( AP_METHOD )
{
   NGX_API * pNgxApi = GetNgxApi();

   hb_retc( "AP_METHOD() not implemented yet" );
}   
   
//----------------------------------------------------------------//

HB_FUNC( AP_USERIP )
{
   NGX_API * pNgxApi = GetNgxApi();

   hb_retc( "AP_USERIP() not implemented yet" );
}   
   
//----------------------------------------------------------------//
