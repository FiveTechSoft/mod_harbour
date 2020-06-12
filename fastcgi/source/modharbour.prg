#define CRLF hb_osNewLine()

//----------------------------------------------------------------//

function AP_Args()

return GetEnv( "QUERY_STRING" )   

//----------------------------------------------------------------//

function AP_FileName()

return GetEnv( "SCRIPT_FILENAME" )

//----------------------------------------------------------------//

function AP_GetEnv( cKey )

return GetEnv( cKey )   

//----------------------------------------------------------------//

function AP_Method()

return getEnv( "REQUEST_METHOD" )

//----------------------------------------------------------------//

function GetCookies()

return GetEnv( "HTTP_COOKIE" )

//----------------------------------------------------------------//

function AP_UserIP()

return GetEnv( "REMOTE_ADDR" )

//----------------------------------------------------------------//

#pragma BEGINDUMP

#include <hbapi.h>
#include <fcgi_stdio.h>

extern char ** environ;

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
   hb_retnl( FCGI_Accept() );
}

int mh_rputs( const char * szText )
{
   return FCGI_printf( "%s", szText );
}

HB_FUNC( PRINTF )
{
   FCGI_printf( "%s", hb_parc( 1 ) );
}

HB_FUNC( TEST )
{
   PrintEnv( "test", environ );
}

HB_FUNC( AP_BODY )
{
   char * szMethod = getenv( "REQUEST_METHOD" );

   if( ! strcmp( szMethod, "POST" ) ) 
   {
      int iLen = atoi( getenv( "CONTENT_LENGTH" ) );
      char * bufp = hb_xgrab( iLen );
      fread( bufp, iLen, 1, stdin );
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