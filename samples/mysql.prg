#define HB_DYN_CALLCONV_CDECL       0x0000000  /* C default */
#define HB_DYN_CTYPE_LONG_UNSIGNED  0x0000014
#define HB_DYN_CTYPE_CHAR_PTR       0x0000101
#define HB_DYN_CTYPE_LONG           0x0000004
#define NULL                        0x0000000         

function Main()
   local pLib := hb_LibLoad( "/usr/lib/x86_64-linux-gnu/libmysqlclient.so" ) // libmysqlclient.so.20 for mariaDB
   local hMySQL := hb_DynCall( { "mysql_init", pLib, HB_DYN_CALLCONV_CDECL }, NULL )

   AP_RPuts( "pLib = " + ValType( pLib ) + '<br>' )
   AP_RPuts( "hMySQL = " + Str( hMySQL ) + '<br>' )

   AP_RPuts( "hb_DynCall = " )
   AP_RPuts( hb_DynCall( { "mysql_real_connect", pLib, HB_DYN_CALLCONV_CDECL, HB_DYN_CTYPE_LONG_UNSIGNED,;
                           HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CTYPE_CHAR_PTR,;
                           HB_DYN_CTYPE_LONG, HB_DYN_CTYPE_LONG, HB_DYN_CTYPE_LONG },;
                           hMySQL, "localhost", "root", "passwd", "DataBaseName", 0, 0, 0 ) )
   AP_RPuts( HB_LibFree( pLib ) )                        

return nil
