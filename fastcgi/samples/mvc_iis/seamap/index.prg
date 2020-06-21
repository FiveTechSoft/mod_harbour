// {% LoadHrb( "/lib/core_lib.hrb" ) %}
// {% LoadHrb( "/lib/mercury.hrb" ) %}

function Main()

   local oApp := App()

   oApp:cPath = hb_GetEnv( "PRGPATH" )
   oApp:cUrl = "/seamap"
 
   oApp:oRoute:Map( "GET,POST", "seamap", "/",         "@seamapcontroller.prg" )
   oApp:oRoute:Map( "GET,POST", "index",  "index.prg", "@seamapcontroller.prg" )

   oApp:Init()

return nil