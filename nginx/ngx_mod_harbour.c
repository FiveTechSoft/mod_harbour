#include <ngx_config.h>
#include <ngx_core.h>

extern ngx_module_t  ngx_mod_harbour;

static ngx_int_t ngx_mod_harbour_handler( ngx_http_request_t * r )
{
    ngx_buf_t *b;
    ngx_chain_t out;

    /* Set the Content-Type header. */
    r->headers_out.content_type.len = sizeof("text/plain") - 1;
    r->headers_out.content_type.data = (u_char *) "text/plain";

    /* Allocate a new buffer for sending out the reply. */
    b = ngx_pcalloc(r->pool, sizeof(ngx_buf_t));

    /* Insertion in the buffer chain. */
    out.buf = b;
    out.next = NULL; /* just one buffer */

    b->pos = ngx_hello_world; /* first position in memory of the data */
    b->last = ngx_hello_world + sizeof(ngx_hello_world) - 1; /* last position in memory of the data */
    b->memory = 1; /* content is in read-only memory */
    b->last_buf = 1; /* there will be no more buffers in the request */

    /* Sending the headers for the reply. */
    r->headers_out.status = NGX_HTTP_OK; /* 200 status code */
    /* Get the content length of the body. */
    r->headers_out.content_length_n = 10; // fix this!
    ngx_http_send_header( r ); /* Send the headers */

    /* Send the body, and return the status code of the output filter chain. */
    return ngx_http_output_filter( r, &out );
}

static char * ngx_mod_harbour( ngx_conf_t * cf, ngx_command_t * cmd, void * conf )
{
    ngx_http_core_loc_conf_t * clcf; /* pointer to core location configuration */

    /* Install the hello world handler. */
    clcf = ngx_http_conf_get_module_loc_conf( cf, ngx_http_core_module );
    clcf->handler = ngx_http_hello_world_handler;

    return NGX_CONF_OK;
}

ngx_module_t * ngx_modules[] = {
    &ngx_mod_harbour,
    NULL
};

char * ngx_module_names[] = {
    "ngx_mod_harbour",
    NULL
};

char * ngx_module_order[] = {
    NULL
};
