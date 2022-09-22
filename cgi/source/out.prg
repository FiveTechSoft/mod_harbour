static hHeadersOut := {=>}, cContentType := "text/html"
static cOutput := ""

exit procedure OutputFlush()

   local n, cKey

   if ! Empty( cOutput )
      Printf( "Content-type: " + cContentType + hb_OsNewLine() )
   endif   
   
   for n = 1 to Len( hHeadersOut )
      Printf( cKey := HB_HKeyAt( hHeadersOut, n ) )
      Printf( ": " + hHeadersOut[ cKey ] )
   next

   Printf( hb_OsNewLine() + hb_OsNewLine() )

   Printf( cOutput )
   cOutput = ""

return

function Output( cText )

   cOutput += cText

return nil   

function AP_HEADERSOUTCOUNT()

return Len( hHeadersOut )

function AP_HEADERSOUTKEY( nKey )

return HB_HKeyAt( hHeadersOut, nKey )

function AP_HEADERSOUTVAL( nKey )

return hHeadersOut[ HB_HKeyAt( hHeadersOut, nKey ) ]

function AP_HEADERSOUTSET( cKey, uValue )

   hHeadersOut[ cKey ] = uValue

return nil

function AP_RWrite( ... )

return nil

function AP_SETCONTENTTYPE( cType )

   cContentType = cType

return nil

function AP_HEADERSOUT()

return hHeadersOut

function MWRITE()

return nil

function MRead()

return nil

#ifndef __PLATFORM__WINDOWS

function ShowConsole()

return nil

#endif

#pragma BEGINDUMP

#include <hbapi.h>
#include <hbvm.h>
#include <stdio.h>

int mh_rputs( const char * szMsg )
{
   hb_vmPushSymbol( hb_dynsymGetSymbol( "OUTPUT" ) );
   hb_vmPushNil();
   hb_vmPushString( szMsg, strlen( szMsg ) );
   hb_vmFunction( 1 );
   
   return 0;
}

int mh_rputslen( const char * szMsg, int iLength )
{
   hb_vmPushSymbol( hb_dynsymGetSymbol( "OUTPUT" ) );
   hb_vmPushNil();
   hb_vmPushString( szMsg, iLength );
   hb_vmFunction( 1 );
   
   return 0;
}

HB_FUNC( PRINTF )
{
   printf( "%s", hb_parc( 1 ) );
}

#pragma ENDDUMP
