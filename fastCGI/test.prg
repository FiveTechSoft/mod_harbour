#define CRLF Chr(13)+Chr(10)

function Main()

   while FCGI_Accept() >= 0
      printf( "Content-type: text/html" + CRLF + CRLF )
      printf( "Hello 2" )
      printf( "*" + getenv( "CONTENT_LENGTH" ) + "*" )
      Test()
   end

return nil

#pragma BEGINDUMP

#include <hbapi.h>
#include "c:\fastcgi\include\fcgi_stdio.h"

extern char **environ;

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

HB_FUNC( PRINTF )
{
   printf( hb_parc( 1 ) );
}

HB_FUNC( TEST )
{
   PrintEnv( "test", environ );
}

#pragma ENDDUMP