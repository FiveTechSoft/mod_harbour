#ifndef NGX_API

void * GetNgxApi( void );
void * GetRequestRec( void );

typedef int ( * PMH_RPUTS ) ( void * r, const char * szText );

typedef struct _NGX_API
{
   PMH_RPUTS mh_rputs;          
} NGX_API;

#endif
