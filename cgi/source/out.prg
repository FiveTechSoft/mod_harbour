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
   
   return 0;
}

int mh_rputslen( void * env, const char * szMsg, int iLength )
{
   printf( "%s\n", szMsg, iLength );
   
   return 0;
}

HB_FUNC( MODBUILDDATE )
{
   char * pszDate;
   
   pszDate = ( char * ) hb_xgrab( 64 );
   hb_snprintf( pszDate, 64, "%s %s", __DATE__, __TIME__ );
   
   hb_retc_buffer( pszDate );
}

#pragma ENDDUMP
