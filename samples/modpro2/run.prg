// Used from samples/modpro/modpro.prg

function Main()

   local hPostPairs := AP_PostPairs()
   local cCode
   
   if hb_HHasKey( hPostPairs, "source" )
      cCode = hPostPairs[ "source" ]
   else
      ? "This example is used from samples/modpro/modpro.prg"
   endif   
   
   AP_HeadersOutSet( "Access-Control-Allow-Origin", "*" )
   
   if ! Empty( cCode )
      Execute( cCode, hb_UrlDecode( hPostPairs[ "params" ] ) )
   endif
   
return nil
