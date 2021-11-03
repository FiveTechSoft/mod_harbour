static hHeadersOut := {=>}, cContentType := "text/html"
static cOutput := ""

exit procedure OutputFlush()

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
#include <stdio.h>

int mh_rputs( const char * szMsg )
{
   printf( "%s\n", szMsg );
   
   return 0;
}

int mh_rputslen( const char * szMsg, int iLength )
{
   iLength = iLength;
   printf( "%s\n", szMsg );
   
   return 0;
}

#pragma ENDDUMP
