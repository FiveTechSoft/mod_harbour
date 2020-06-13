#define CRLF hb_osNewLine()

//----------------------------------------------------------------//

function AP_Args()

return ap_GetEnv( "QUERY_STRING" )   

//----------------------------------------------------------------//

function AP_FileName()

return ap_GetEnv( "SCRIPT_FILENAME" )

//----------------------------------------------------------------//

function AP_Method()

return ap_GetEnv( "REQUEST_METHOD" )

//----------------------------------------------------------------//

function GetCookies()

return ap_GetEnv( "HTTP_COOKIE" )

//----------------------------------------------------------------//

function AP_UserIP()

return ap_GetEnv( "REMOTE_ADDR" )

//----------------------------------------------------------------//

#pragma BEGINDUMP

#include <hbapi.h>
#include <fcgi_stdio.h>

extern char ** environ;

static FCGX_Stream * g_in, * g_out, * g_err;
static FCGX_ParamArray g_envp;

static void PrintEnv(char *label, char **envp)
{
    printf("%s:<br>\n<pre>\n", label);
    for ( ; *envp != NULL; envp++) {
        printf("%s\n", *envp);
    }
    printf("</pre><p>\n");
}

HB_FUNC( FCGI_ACCEPT )
{
   hb_retnl( FCGX_Accept( &g_in, &g_out, &g_err, &g_envp ) );
}

HB_FUNC( AP_GETENV )
{
   hb_retc( FCGX_GetParam( hb_parc( 1 ), g_envp ) );
}

int mh_rputs( const char * szText )
{
   return FCGX_FPrintF( g_out, "%s", szText );
}

HB_FUNC( PRINTF )
{
   FCGX_FPrintF( g_out, "%s", hb_parc( 1 ) );
}

HB_FUNC( TEST )
{
   PrintEnv( "test", environ );
}

HB_FUNC( AP_BODY )
{
   char * szMethod = FCGX_GetParam( "REQUEST_METHOD", g_envp );

   if( ! strcmp( szMethod, "POST" ) ) 
   {
      int iLen = atoi( FCGX_GetParam( "CONTENT_LENGTH", g_envp ) );
      char * bufp = hb_xgrab( iLen + 1 );
      FCGX_GetStr( bufp, iLen, g_in );
      hb_retclen( bufp, iLen );
      hb_xfree( bufp );
   }
   else
      hb_retc( "" );   
}

HB_FUNC( SETEXITSTATUS )
{
   FCGI_SetExitStatus( hb_parni( 1 ) );   
}

#pragma ENDDUMP

//----------------------------------------------------------------//
