#include <ngx_config.h>
#include <ngx_core.h>
#include <ngx_http.h>
#include <unistd.h>
#include "/home/anto/mod_harbour/nginx/ngx_mod_harbour.h"

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

// static const char * szMsg = "Yes, hello world from mod_harbour\r\n";

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

static ngx_chain_t out, * pLastChainLink;

const char * mh_args( ngx_http_request_t * r )
{
    return ( const char * ) r->args.data;
}    

void mh_setContentType( ngx_http_request_t * r, char * szType )
{
   r->headers_out.content_type.len = strlen( szType ) - 1;
   r->headers_out.content_type.data = ( u_char * ) szType;
}

int mh_rputs( ngx_http_request_t * r, const char * szText )
{
   ngx_buf_t * buffer = ngx_calloc_buf( r->pool );

   r->headers_out.status = NGX_HTTP_OK;
    
   if( ! out.buf )
   {    
      out.buf = ( void * ) buffer;
      out.next = ngx_alloc_chain_link( r->pool );
      pLastChainLink = out.next;
      r->headers_out.content_length_n = strlen( szText );
   }    
   else 
   {    
       pLastChainLink->buf = ( void * ) buffer;
       pLastChainLink->next = ngx_alloc_chain_link( r->pool );
       pLastChainLink = pLastChainLink->next;
       r->headers_out.content_length_n += strlen( szText );
   }    

   buffer->pos = ( void * ) szText;
   buffer->last = ( void * ) ( ( char * ) szText + strlen( szText ) );
   buffer->memory = 1;

   return 0;
}

int CopyFile( const char * from, const char * to, int iOverWrite )
{
    int fd_to, fd_from;
    char buf[ 4096 ];
    ssize_t nread;
    int saved_errno;

    iOverWrite = iOverWrite;

    fd_from = open( from, O_RDONLY );
    if( fd_from < 0 )
        return -1;

    fd_to = open( to, O_WRONLY | O_CREAT | O_EXCL, 0666 );
    if( fd_to < 0 )
        goto out_error;

    while( nread = read( fd_from, buf, sizeof buf ), nread > 0 )
    {
        char * out_ptr = buf;
        ssize_t nwritten;

        do {
            nwritten = write( fd_to, out_ptr, nread );

            if( nwritten >= 0 )
            {
                nread -= nwritten;
                out_ptr += nwritten;
            }
            else if( errno != EINTR )
            {
                goto out_error;
            }
        } while( nread > 0 );
    }

    if( nread == 0 )
    {
        if( close( fd_to ) < 0 )
        {
            fd_to = -1;
            goto out_error;
        }
        close( fd_from );

        return 0;
    }

  out_error:
    saved_errno = errno;

    close( fd_from );
    if( fd_to >= 0 )
        close( fd_to );

    errno = saved_errno;
    return errno;
}

typedef int ( * PHB_APACHE )( void * pRequestRec, NGX_API * pNgxApi );

static ngx_int_t ngx_mod_harbour_handler( ngx_http_request_t * r )
{
   void * lib_harbour;
   // unsigned int dwThreadId = pthread_self();
   char * szTempFileName = "/tmp/libharbour.so";
   int iResult = NGX_OK;

   out.buf  = NULL;
   out.next = NULL;      

   CopyFile( "./libharbour.so", szTempFileName, 0 );
    
   if( ( lib_harbour = dlopen( szTempFileName, RTLD_LAZY ) ) )
   {     
      PHB_APACHE _hb_apache = NULL;
      
      #ifdef _WINDOWS_
         _hb_apache = ( PHB_APACHE ) GetProcAddress( lib_harbour, "hb_apache" );
      #else
         _hb_apache = dlsym( lib_harbour, "hb_apache" );
      #endif

      if( _hb_apache == NULL )
         mh_rputs( r, "<br>failed to load hb_apache()" );
      else
      {
         NGX_API ngxapi;

         ngxapi.mh_rputs = ( PMH_RPUTS ) mh_rputs;  
         ngxapi.mh_args  = ( PMH_ARGS ) mh_args; 

         mh_setContentType( r, "text/plain" );
          
         iResult = _hb_apache( r, ( void * ) &ngxapi );
          
         mh_rputs( r, "after hb_apache() call" ); 
         ngx_http_send_header( r );
         ngx_http_output_filter( r, &out );
      }
      if( lib_harbour != NULL )
         #ifdef _WINDOWS_	
            FreeLibrary( lib_harbour );
         #else
            dlclose( lib_harbour );
         #endif

      #ifdef _WINDOWS_ 
         DeleteFile( szTempFileName );
      #else
         remove( szTempFileName );
      #endif    
   }
   else
      mh_rputs( r, dlerror() );  
   
   return iResult; 
}

static char * ngx_mod_harbour_main( ngx_conf_t * cf, ngx_command_t * cmd, void * conf )
{
    ngx_http_core_loc_conf_t * clcf;

    clcf = ngx_http_conf_get_module_loc_conf( cf, ngx_http_core_module );
    clcf->handler = ngx_mod_harbour_handler;

    return NGX_CONF_OK;
}
