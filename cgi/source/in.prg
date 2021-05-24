function AP_BODY()

return ""

function AP_HEADERSINCOUNT()

return 0

function AP_HEADERSINKEY( nKey )

return ""

function AP_HEADERSINVAL( nKey )

return ""

function AP_METHOD()

return hb_GetEnv( "REQUEST_METHOD" )

function AP_USERIP()

return hb_GetEnv( "REMOTE_ADDR" )

function AP_FILENAME()

return hb_Argv( 1 )

function AP_ARGS()

return hb_GetEnv( "QUERY_STRING" )

function AP_GETENV( cKey )

return hb_GetEnv( cKey )

function AP_Entry()

return nil
