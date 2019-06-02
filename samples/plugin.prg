// To create your plugins for mod_harbour please review:
// https://github.com/FiveTechSoft/mod_harbour/wiki/Building-plugins-for-mod_harbour

function Main()

   local pLib := hb_LibLoad( "/var/www/html/libmyplugin.so" )

   ?? "pLib = " + ValType( pLib ) + ;
      If( ValType( pLib ) == "P", " (library properly loaded)", "(" + hb_LibError() + ")" )

   if ValType( pLib ) == "P"
      ? Do( pLib, "Test" )
   endif   
  
   ? HB_LibFree( pLib )

return nil
