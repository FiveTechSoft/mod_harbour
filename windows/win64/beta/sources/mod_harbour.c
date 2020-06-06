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

#endif

typedef int ( * PHB_APACHE )( void * pRequestRec );

static int harbour_handler( request_rec * r )
{
   const char * szDllName;

   #ifdef _WINDOWS_
      HMODULE lib_harbour = NULL;
   #else
      void * lib_harbour = NULL;
   #endif
   
   PHB_APACHE _hb_apache = NULL;
   int iResult = OK;

   if( strcmp( r->handler, "harbour" ) )
      return DECLINED;

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

   r->content_type = "text/html";

   ap_add_cgi_vars( r );
   ap_add_common_vars( r );

   #ifdef _WINDOWS_
      if( lib_harbour == NULL )
         lib_harbour = LoadLibrary( szDllName );
   #else
      lib_harbour = dlopen( szDllName, RTLD_LAZY );
   #endif

   if( lib_harbour == NULL )
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
      _hb_apache = ( PHB_APACHE ) GetProcAddress( lib_harbour, "hb_apache" );
   #else
      _hb_apache = dlsym( lib_harbour, "hb_apache" );
   #endif

   if( _hb_apache == NULL )
      ap_rputs( "<br>failed to load hb_apache()", r );
   else
      iResult = _hb_apache( r );

   if( lib_harbour != NULL )
      #ifdef _WINDOWS_	
         FreeLibrary( lib_harbour );
      #else
         dlclose( lib_harbour );
      #endif

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