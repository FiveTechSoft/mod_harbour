// To create your plugins for mod_harbour please review:
// https://github.com/FiveTechSoft/mod_harbour/wiki/Building-plugins-for-mod_harbour

#define HB_DYN_CALLCONV_CDECL       0x0000000
#define HB_DYN_CTYPE_LLONG_UNSIGNED 0x0000015

static pLib

//----------------------------------------------------------------//

function Main()

   pLib = hb_LibLoad( "/var/www/html/libmyplugin.so" )

   ?? "pLib = " + ValType( pLib ) + ;
      If( ValType( pLib ) == "P", " (library properly loaded)", " (" + hb_LibError() + ")" )

   if ValType( pLib ) == "P"
      hb_init()
      ? "plugin properly initialized"
   endif   

   if ValType( pLib ) == "P"
      ? Do( "Test" )
   endif   
  
   if ValType( pLib ) == "P"
      ? HB_LibFree( pLib )
   endif

return nil

//----------------------------------------------------------------//

function hb_init()

return hb_DynCall( { "hb_init", pLib, HB_DYN_CALLCONV_CDECL, HB_DYN_CTYPE_LLONG_UNSIGNED, HB_DYN_CTYPE_LLONG_UNSIGNED },;
                   hb_vmProcessSymbols(), hb_vmExecute() )

//----------------------------------------------------------------//
