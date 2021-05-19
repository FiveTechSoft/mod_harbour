#include <ngx_mod_harbour.h>
#include <hbapi.h>

//----------------------------------------------------------------//

HB_FUNC( MH_ARGS )
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
