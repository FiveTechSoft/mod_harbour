// Used from samples/sandbox.prg

function Run()

   local hPostPairs := AP_PostPairs()
   local cCode
   
   if hb_HHasKey( hPostPairs, "source" )
      cCode = hPostPairs[ "source" ]
   endif   
   
   AP_HeadersOutSet( "Access-Control-Allow-Origin", "*" )
   
   if ! Empty( cCode )
      Execute( cCode )
   endif
   
return nil
