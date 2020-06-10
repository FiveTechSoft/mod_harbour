/*
**  mod_harbour.c -- Apache harbour module
** (c) FiveTech Software SL, 2019-2020
** Developed by Antonio Linares alinares@fivetechsoft.com
** MIT license https://github.com/FiveTechSoft/mod_harbour/blob/master/LICENSE
*/

#include "httpd.h"
#include "http_config.h"
#include "http_core.h"
#include "http_log.h"
#include "http_protocol.h"
#include "ap_config.h"
#include "util_script.h"
#include "apr.h"
#include "apr_atomic.h"
#include "apr_strings.h"

#ifdef _WINDOWS_
   #include <windows.h>
#else
   #include <dlfcn.h>
   #include <unistd.h>
#endif        

#ifdef _WINDOWS_

char * GetErrorMessage( DWORD dwLastError )
{
   LPVOID lpMsgBuf;

   FormatMessage( FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
                  NULL,
                  dwLastError,
                  MAKELANGID( LANG_NEUTRAL, SUBLANG_DEFAULT ), // Default language
                  ( LPTSTR ) &lpMsgBuf,
                  0,
                  NULL );

   return ( ( char * ) lpMsgBuf );
}

#else

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

#endif

typedef int ( * PHB_APACHE )( void * pRequestRec );

#ifdef _WINDOWS_
   volatile static int iLib = 0;
   volatile static HMODULE lib_harbour[ 25 ] = { NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                                                   NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                                                   NULL, NULL, NULL, NULL, NULL }; 
#else
   volatile static void lib_harbour[ 25 ] = { NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                                                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                                                NULL, NULL, NULL, NULL, NULL };
#endif

static int harbour_handler( request_rec * r )
{
   const char * szTempPath;
   char * szTempFileName;
   const char * szDllName;

   PHB_APACHE _hb_apache = NULL;
   int iResult = OK;
   int i = ++iLib;

   if( iLib > 24 )
   {
      iLib = 0;
      i = 0;
   }

   while( lib_harbour[ iLib ] != NULL )
   {
      iLib++;
      if( iLib > 24 )
         iLib = 0;
      i = iLib;
   }
 
   lib_harbour[ i ] = 5;

   if( strcmp( r->handler, "harbour" ) )
      return DECLINED;

   /*
   apr_atomic_init( r->pool );

   do
   {
      if( iLib == 25 )
         iLib = 0;
   } while( ( iLib < 24 ) && ( apr_atomic_xchgptr( ( volatile void ** ) &lib_harbour[ iLib++ ], ( void * ) 5 ) != NULL ) );
   iLib--;
   */

   OutputDebugString( apr_psprintf( r->pool, "%d\n", i ) );   
   
   if( ! ( szDllName = apr_table_get( r->subprocess_env, "LIBHARBOUR" ), szDllName ) )  // pacified warning
   #ifdef _WINDOWS_
      szDllName = "c:\\Apache24\\htdocs\\libharbour.dll";
   #else       
      #ifdef DARWIN
         szDllName = "/Library/WebServer/Documents/libharbour.3.2.0.dylib";
      #else   
         szDllName = "/var/www/html/libharbour.so.3.2.0";
      #endif
   #endif   

   apr_temp_dir_get( &szTempPath, r->pool );
   szTempFileName = apr_psprintf( r->pool, "%s\\%s%d.dll", szTempPath, "libharbour", i );
   if( _access( szTempFileName, 0 ) == -1 )
      CopyFile( szDllName, szTempFileName, 0 );

   OutputDebugString( apr_psprintf( r->pool, "%s\n", szTempFileName ) );   

   r->content_type = "text/html";

   ap_add_cgi_vars( r );
   ap_add_common_vars( r );

   #ifdef _WINDOWS_
      // apr_atomic_xchgptr( ( volatile void ** ) &lib_harbour[ iLib ], LoadLibrary( szTempFileName ) );
      lib_harbour[ i ] = LoadLibrary( szTempFileName );
   #else
      apr_atomic_xchgptr( ( volatile void ** ) &lib_harbour[ iLib ], dlopen( szTempFileName, RTLD_LAZY ) );
   #endif

   if( lib_harbour[ i ] == NULL )
   {
      ap_rprintf( r, "mod_harbour version %s, %s<br>", __DATE__, __TIME__ );
      #ifdef _WINDOWS_
         char * szErrorMessage = GetErrorMessage( GetLastError() );
  
         ap_rprintf( r, "%s<br>", szDllName );
         ap_rputs( szErrorMessage, r );
         LocalFree( ( void * ) szErrorMessage );
      #else
         ap_rputs( dlerror(), r ); 
      #endif
   }   

   #ifdef _WINDOWS_
      _hb_apache = ( PHB_APACHE ) GetProcAddress( lib_harbour[ i ], "hb_apache" );
   #else
      _hb_apache = dlsym( lib_harbour[ i ], "hb_apache" );
   #endif

   if( _hb_apache == NULL )
      ap_rputs( "<br>failed to load hb_apache()", r );
   else
      iResult = _hb_apache( r );

   if( lib_harbour[ i ] != NULL )
      #ifdef _WINDOWS_	
         FreeLibrary( lib_harbour[ i ] );
      #else
         dlclose( lib_harbour[ i ] );
      #endif

   lib_harbour[ i ] = NULL; 
   // apr_atomic_xchgptr( ( volatile void ** ) &lib_harbour[ iLib ], NULL );

   return iResult;
}

static void harbour_register_hooks( apr_pool_t * p )
{
   p = p;
   ap_hook_handler( harbour_handler, NULL, NULL, APR_HOOK_MIDDLE );
}

/* Dispatch list for API hooks */
module AP_MODULE_DECLARE_DATA harbour_module = {
    STANDARD20_MODULE_STUFF,
    NULL,                  /* create per-dir    config structures */
    NULL,                  /* merge  per-dir    config structures */
    NULL,                  /* create per-server config structures */
    NULL,                  /* merge  per-server config structures */
    NULL,                  /* table of config file commands       */
    #ifdef _WINDOWS_
       harbour_register_hooks, /* register hooks                  */
       0
    #else
       harbour_register_hooks  /* register hooks                  */
    #endif
};