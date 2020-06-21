// {% LoadHrb( "/lib/core_lib.hrb" ) %}
// {% LoadHrb( "/lib/mercury.hrb" ) %}

function Main()

   local oApp := App()

   oApp:oRoute:Map( "GET,POST", "seamap", "/", "@seamapcontroller.prg" )

   oApp:Init()

return nil