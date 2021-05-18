#ifndef NGX_API

typedef int ( * PMH_RPUTS ) ( void * r, char * szText );

typedef struct _NGX_API
{
   PMH_RPUTS mh_rputs;          
} NGX_API;

#endif
