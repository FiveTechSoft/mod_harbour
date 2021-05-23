function AP_HEADERSOUTCOUNT()

return 0

function AP_HEADERSOUTKEY( nKey )

return ""

function AP_HEADERSOUTVAL( nKey )

return ""

function AP_HEADERSOUTSET( cKey, uValue )

return nil

function AP_RWrite( ... )

return nil

function AP_SETCONTENTTYPE( cType )

return nil

function AP_HEADERSIN()

return {=>}

function AP_HEADERSOUT()

return nil

function AP_HEADERSIN()

return nil

function AP_HEADERSOUT()

return nil

function MWRITE()

return nil

function MRead()

return nil

function SHOWCONSOLE()

return nil

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
   printf( "%s\n", szMsg, iLength );
   
   return 0;
}

#pragma ENDDUMP
