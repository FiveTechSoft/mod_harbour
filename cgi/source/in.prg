ANNOUNCE HB_GT_SYS

static cBody, hHeadersIn := {=>}

function AP_BODY()

   local nLen, cBuffer

   if cBody == nil
      nLen = Val( hb_GetEnv( "CONTENT_LENGTH" ) )
      cBody = Space( nLen )
      fread( hb_getStdIn(), @cBody, nLen )
   endif   

return cBody

function AP_HeadersIn()

return hHeadersIn

function AP_HEADERSINCOUNT()

return Len( hHeadersIn )

function AP_HEADERSINKEY( nKey )

return HB_HKeyAt( hHeadersIn, nKey )

function AP_HEADERSINVAL( nKey )

return hHeadersIn[ HB_HKeyAt( hHeadersIn, nKey ) ]

function AP_METHOD()

return hb_GetEnv( "REQUEST_METHOD" )

function AP_USERIP()

return hb_GetEnv( "REMOTE_ADDR" )

function AP_FILENAME()

return If( At( "?", hb_ArgV( 1 ) ) == 0, hb_ArgV( 1 ), SubStr( hb_Argv( 1 ), 1, At( "?", hb_Argv( 1 ) ) - 1 ) )

function AP_ARGS()

return hb_GetEnv( "QUERY_STRING" )

function AP_GETENV( cKey )

return hb_GetEnv( cKey )

function AP_Entry()

return nil
