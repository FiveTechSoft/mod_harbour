// #include "ads.ch"

function Main()

   ? RddRegister( "ADS", 1 )
   ? AdsSetServerType( 1 ) // ADS_LOCAL_SERVER )
   ? RDDSetDefault( "ADS" )
   ? RddSetDefault()

   /*
   DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/test.dbf",;
             { { "FIRST", "C", 30, 0 },;
               { "LAST",  "C", 30, 0 } } ) 
   */

   USE ( hb_GetEnv( "PRGPATH" ) + "/data/menus.dbf" ) VIA "ADS"

   ? FieldName( 1 )
   ? FieldGet( 1 )
   ? RecCount()

   USE

return nil