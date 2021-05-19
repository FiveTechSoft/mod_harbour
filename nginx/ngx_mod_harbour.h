#ifndef NGX_API

void * GetNgxApi( void );
void * GetRequestRec( void );
// const char * mh_args( void * r );
// int mh_rputs( void * r, const char * szText );

typedef int ( * PMH_RPUTS ) ( void * r, const char * szText );
typedef const char * ( * PMH_ARGS ) ( void * r );

typedef struct _NGX_API
{
   PMH_RPUTS mh_rputs;          
   PMH_ARGS  mh_args;
} NGX_API;

#endif
