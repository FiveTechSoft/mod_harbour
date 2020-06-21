// Used from HRB runner from Antonino Perricone

function Main()

   local hPostPairs := AP_PostPairs()
   local cCode
   
   if hb_HHasKey( hPostPairs, "source" )
      cCode = hb_UrlDecode( hPostPairs[ "source" ] )
   else
      ? "This example is used from https://github.com/FiveTechSoft/HRB-Runner/blob/master/editor.html"
   endif   
   
   AP_HeadersOutSet( "Access-Control-Allow-Origin", "*" )
   
   if ! Empty( cCode )    
      // ? hb_GetEnv( "PRGPATH" ) + "/data/runner.hrb_"
      MemoWrit( hb_GetEnv( "PRGPATH" ) + "/data/runner.hrb_", hb_compileFromBuf( cCode, .T. ) )
   endif
   
return nil
