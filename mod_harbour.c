#include "httpd.h"
#include "http_core.h"
#include "http_protocol.h"
#include "http_request.h"

#include <hbvm.h>

static void register_hooks( apr_pool_t * pool );
static int harbour_handler( request_rec * r );

module AP_MODULE_DECLARE_DATA harbour_module =
{
    STANDARD20_MODULE_STUFF,
    NULL,            // Per-directory configuration handler
    NULL,            // Merge handler for per-directory configurations
    NULL,            // Per-server configuration handler
    NULL,            // Merge handler for per-server configurations
    NULL,            // Any directives we may have for httpd
    register_hooks   // Our hook registering function
};

static void register_hooks( apr_pool_t * pool ) 
{
   ap_hook_handler( harbour_handler, NULL, NULL, APR_HOOK_LAST );
}

static request_rec * _r;

static int harbour_handler( request_rec * r )
{
   _r = r;

   if( ! r->handler || strcmp( r->handler, "harbour-handler" ) ) 
      return DECLINED;
   
   hb_vmInit( HB_TRUE );

   return hb_vmQuit();
}

HB_FUNC( AP_RPUTS )
{
   if( HB_ISCHAR( 1 ) )
      ap_rputs( hb_parc( 1 ), _r );
}   

HB_FUNC( AP_RPRINTF )
{
   ap_rprintf( _r, hb_parc( 1 ), hb_parc( 2 ) );
}   

HB_FUNC( AP_FILENAME )
{
   hb_retc( _r->filename );
}

HB_FUNC( AP_ARGS )
{
   hb_retc( _r->args );
}   

HB_FUNC( AP_SETCONTENTTYPE )
{
   ap_set_content_type( _r, hb_parc( 1 ) );
}   

HB_FUNC( AP_METHOD )
{
   hb_retc( _r->method );
}    

HB_FUNC( AP_USERIP )
{
   hb_retc( _r->useragent_ip );
}   
