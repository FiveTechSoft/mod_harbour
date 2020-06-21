// Used from samples/modpro/modpro.prg

function Main()

   local hPostPairs := mh_PostPairs()
   local cCode
   
   if hb_HHasKey( hPostPairs, "source" )
      cCode = hb_UrlDecode( hPostPairs[ "source" ] )
   else
      ? "This example is used from samples/modpro/modpro.prg"
   endif   
   
   mh_Header( "Access-Control-Allow-Origin: *" )
   
   if ! Empty( cCode )
      Execute( cCode, hb_UrlDecode( hPostPairs[ "params" ] ) )
   endif
   
return nil
