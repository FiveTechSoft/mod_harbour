// To create your plugins for mod_harbour please review:
// https://github.com/FiveTechSoft/mod_harbour/wiki/Building-plugins-for-mod_harbour

static pLib

function Main()

   pLib = hb_LibLoad( "/var/www/html/libmyplugin.so" )

   ?? "pLib = " + ValType( pLib ) + ;
      If( ValType( pLib ) == "P", " (library properly loaded)", " (" + hb_LibError() + ")" )

   if ValType( pLib ) == "P"
      hb_init()
   endif   

   if ValType( pLib ) == "P"
      ? Do( pLib, "Test" )
   endif   
  
   if ValType( pLib ) == "P"
      ? HB_LibFree( pLib )
   endif

return nil

function hb_init()

return hb_DynCall( { "hb_init", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED, HB_DYN_CALLCONV_CDECL ) }, hb_vmProcessSymbols() )
