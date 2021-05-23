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

function AP_RPUTS( ... )

return nil

#pragma BEGINDUMP

int mh_rputs( void * env, const char * szMsg )
{
   printf( "%s\n", szMsg );
}

int mh_rputslen( void * env, const char * szMsg, int iLength )
{
   printf( "%s\n", szMsg, iLength );
}

#pragma ENDDUMP
