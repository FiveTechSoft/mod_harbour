//----------------------------------------------------------------//

function MH_Query()

return MH_GetEnv( "QUERY_STRING" )   

//----------------------------------------------------------------//

function MH_FileName()

return MH_GetEnv( "SCRIPT_FILENAME" )

//----------------------------------------------------------------//

function MH_Method()

return MH_GetEnv( "REQUEST_METHOD" )

//----------------------------------------------------------------//

function MH_UserIP()

return MH_GetEnv( "REMOTE_ADDR" )

//----------------------------------------------------------------//

#pragma BEGINDUMP

#include <hbapi.h>
#include <hbapigt.h>
#include <fcgi_stdio.h>

FCGX_Stream * g_in = NULL, * g_out = NULL, * g_err = NULL;
FCGX_ParamArray g_envp = NULL;
HB_BOOL bEcho = HB_FALSE;

HB_FUNC( FCGI_ACCEPT )
{
   hb_retnl( FCGX_Accept( &g_in, &g_out, &g_err, &g_envp ) );
}

HB_FUNC( MH_GETENV )
{
   hb_retc( FCGX_GetParam( hb_parc( 1 ), g_envp ) );
}

int echo( const char * szText )
{
   if( ! bEcho )
   {
      bEcho = HB_TRUE;
      if( g_out != NULL )
         FCGX_FPrintF( g_out, "\r\n" );
   }

   int iRetCode = 0;

   if( g_out != NULL )
      iRetCode = FCGX_FPrintF( g_out, "%s", szText );
   else
      hb_gtOutStd( szText, strlen( szText ) );

   return iRetCode;      
}

HB_FUNC( MH_HEADER )
{
   if( g_out != NULL )
      FCGX_FPrintF( g_out, "%s\r\n", hb_parc( 1 ) );
   else
      hb_gtOutStd( hb_parc( 1 ), hb_parclen( 1 ) );   
   bEcho = HB_FALSE;
}

HB_FUNC( MH_SETCONTENTTYPE )
{
   if( g_out != NULL )
      FCGX_FPrintF( g_out, "%s %s\r\n", "Content-type:", hb_parc( 1 ) );
   else
      printf( "%s", hb_parc( 1 ) );   
   bEcho = HB_FALSE;
}

HB_FUNC( MH_BODY )
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

int mh_headers_in_count( void )
{
   return 0;
}

HB_FUNC( MH_HEADERSINCOUNT )
{
   hb_retni( mh_headers_in_count() );
}

const char * mh_headers_in_key( int iKey )
{
   iKey = iKey;
   return "";
}

HB_FUNC( MH_HEADERSINKEY )
{
   hb_retc( mh_headers_in_key( hb_parni( 1 ) ) );
}

const char * mh_headers_in_val( int iKey )
{
   iKey = iKey;
   return "";
}

HB_FUNC( MH_HEADERSINVAL )
{
   hb_retc( mh_headers_in_val( hb_parni( 1 ) ) );
}

#pragma ENDDUMP

//----------------------------------------------------------------//