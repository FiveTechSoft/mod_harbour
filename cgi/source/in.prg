function AP_BODY()

   local nLen := Val( hb_GetEnv( "CONTENT_LENGTH" ) )
   local cBuffer := Space( nLen )

   fread( hb_GetStdIn(), @cBuffer, nLen )

return cBuffer

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
