#include <ngx_config.h>
#include <ngx_core.h>
#include <ngx_http.h>

static char * ngx_mod_harbour_main( ngx_conf_t * cf, ngx_command_t * cmd, void * conf );
static ngx_int_t ngx_mod_harbour_handler( ngx_http_request_t * r );

static ngx_command_t ngx_mod_harbour_commands[] = 
{
    { ngx_string( "mod_harbour" ), /* directive */
      NGX_HTTP_LOC_CONF|NGX_CONF_NOARGS, /* location context and takes
                                            no arguments*/
      ngx_mod_harbour_main, /* configuration setup function */
      0, /* No offset. Only one context is supported. */
      0, /* No offset when storing the module configuration on struct. */
      NULL},

    ngx_null_command /* command termination */
};

static const char * szMsg = "Yes, hello world from mod_harbour\r\n";

static ngx_http_module_t ngx_mod_harbour_ctx = {
    NULL, /* preconfiguration */
    NULL, /* postconfiguration */

    NULL, /* create main configuration */
    NULL, /* init main configuration */

    NULL, /* create server configuration */
    NULL, /* merge server configuration */

    NULL, /* create location configuration */
    NULL /* merge location configuration */
};

/* Module definition. */
ngx_module_t ngx_mod_harbour = {
    NGX_MODULE_V1,
    &ngx_mod_harbour_ctx, /* module context */
    ngx_mod_harbour_commands, /* module directives */
    NGX_HTTP_MODULE, /* module type */
    NULL, /* init master */
    NULL, /* init module */
    NULL, /* init process */
    NULL, /* init thread */
    NULL, /* exit thread */
    NULL, /* exit process */
    NULL, /* exit master */
    NGX_MODULE_V1_PADDING
};

void mh_setContentType( ngx_http_request_t * r, char * szType )
{
   r->headers_out.content_type.len = strlen( szType ) - 1;
   r->headers_out.content_type.data = ( u_char * ) szType;
}

int mh_rputs( ngx_http_request_t * r, const char * szText )
{
   ngx_buf_t * b = ngx_pcalloc( r->pool, sizeof( ngx_buf_t ) );
   ngx_chain_t out;

   mh_setContentType( r, "text/plain" );

   r->headers_out.status = NGX_HTTP_OK;
   r->headers_out.content_length_n = strlen( szText );
   ngx_http_send_header( r );
 
   out.buf = ( void * ) b;
   out.next = NULL;      

   b->pos = ( void * ) szText;
   b->last = ( void * ) ( ( char * ) szText + strlen( szText ) );
   b->memory = 1;
   b->last_buf = 1;

   return ngx_http_output_filter( r, &out );
}

static ngx_int_t ngx_mod_harbour_handler( ngx_http_request_t * r )
{
   mh_rputs( r, szMsg );
   
   return mh_rputs( r, "another" );
}

/**
 * Configuration setup function that installs the content handler.
 *
 * @param cf
 *   Module configuration structure pointer.
 * @param cmd
 *   Module directives structure pointer.
 * @param conf
 *   Module configuration structure pointer.
 * @return string
 *   Status of the configuration setup.
 */
static char * ngx_mod_harbour_main( ngx_conf_t * cf, ngx_command_t * cmd, void * conf )
{
    ngx_http_core_loc_conf_t *clcf; /* pointer to core location configuration */

    /* Install the hello world handler. */
    clcf = ngx_http_conf_get_module_loc_conf( cf, ngx_http_core_module );
    clcf->handler = ngx_mod_harbour_handler;

    return NGX_CONF_OK;
}
