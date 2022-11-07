ANNOUNCE HB_GT_SYS

static cBody, hHeadersIn := {=>}

function AP_BODY()

   local nLen

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

   local hGet, cFileName := hb_ArgV( 1 )

   If Len( cFileName ) == 0
      cFileName := GetEnv( "REQUEST_URI" )
   EndIf

   If At( "?prg=", cFileName ) > 0 .and. hb_isHash( hGet := AP_GetPairs() ) .and. hb_hHasKey( hGet, "prg" )
      cFileName := hGet[ "prg" ]
   ElseIf At( "?", cFileName ) > 0
      cFileName := SubStr( cFileName, 1, At( "?", cFileName ) - 1 )
   EndIf

   If Left( cFileName, 1 ) == "/"
      cFileName := SubStr( cFileName, 2, Len( cFileName ) )
   EndIf

   If Len( cFileName ) > 0 .and. ( At( ".prg", cFileName ) == 0 .or. At( ".hrb", cFileName ) )
      cFileName := cFileName + ".prg"
   EndIf

return cFileName

function AP_ARGS()

return hb_GetEnv( "QUERY_STRING" )

function AP_GETENV( cKey )

return hb_GetEnv( cKey )

function AP_Entry()

return nil
