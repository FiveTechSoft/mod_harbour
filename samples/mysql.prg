#define HB_DYN_CALLCONV_CDECL       0x0000000  // C default
#define HB_DYN_CTYPE_LONG_UNSIGNED  0x0000014
#define HB_DYN_CTYPE_CHAR_PTR       0x0000101
#define HB_DYN_CTYPE_LONG           0x0000004
#define HB_DYN_CTYPE_INT            0x0000003
#define HB_DYN_CTYPE_LLONG_UNSIGNED 0x0000015
#define NULL                        0x0000000         

static pLib, hMySQL, hConnection, hMyRes

//----------------------------------------------------------------//

function Main()

   local nRetVal, n, m, hField, hRow
   
   pLib = hb_LibLoad( "/usr/lib/x86_64-linux-gnu/libmysqlclient.so" ) // libmysqlclient.so.20 for mariaDB
   hMySQL = mysql_init()

   ?? "pLib = " + ValType( pLib ) + ;
      If( ValType( pLib ) == "P", " (MySQL library properly loaded)", " (MySQL library not found)" )
   
   ? "hMySQL = " + Str( hMySQL ) + " (MySQL library " + ;
      If( hMySQL != 0, "initalized)", "failed to initialize)" )
   ? If( hMySQL != 0, "MySQL version: " + mysql_get_server_info( hMySQL ), "" )   

   ?
   ? "Connection: "
   ?? hConnection := mysql_real_connect( "127.0.0.1", "harbour", "password", "dbHarbour", 3306 )
   ?? If( hConnection != hMySQL, " (Failed connection)", " (Successfull connection)" )

   if hConnection != 0
      nRetVal = mysql_query( hConnection, "select * from users" )
      ? "MySQL query " + If( nRetVal == 0, "succeeded", "failed" )
      if nRetVal != 0
         ? "error: " + Str( nRetVal )
      endif
   endif   
   
   if hConnection != 0
      hMyRes = mysql_store_result( hConnection )
      ? "MySQL store result " + If( hMyRes != 0, "succeeded", "failed" )
      ?
   endif   

   if hMyRes != 0
      ? "Number of rows: " + Str( mysql_num_rows( hMyRes ) )
   endif   
   
   if hMyRes != 0
      ? "Number of fields: " + Str( mysql_num_fields( hMyRes ) )
      ?? "<table border=1 cellspacing=0>"
      ?? "<tr>"
      for n = 1 to mysql_num_fields( hMyRes )
         hField = mysql_fetch_field( hMyRes )
         if hField != 0
            ?? "<td>" + PtrToStr( hField, 0 ) + "</td>" 
         endif   
      next
      ?? "</tr>"
      for n = 1 to mysql_num_rows( hMyRes )
         if ( hRow := mysql_fetch_row( hMyRes) ) != 0
            ?? "<tr>"
               for m = 1 to mysql_num_fields( hMyRes )
                  ?? "<td>" + AllTrim( PtrToStr( hRow, m - 1 ) ) + "</td>"
               next
            ?? "</tr>"
         endif   
      next   
      ?? "</table>"      
   endif   

   mysql_free_result( hMyRes )
   mysql_close( hMySQL )
   
   ? "MySQL library properly freed: "
   ?? HB_LibFree( pLib )                        

return nil

//----------------------------------------------------------------//

function mysql_init()

return hb_DynCall( { "mysql_init", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED, HB_DYN_CALLCONV_CDECL ) }, NULL )

//----------------------------------------------------------------//

function mysql_close( hMySQL )

return hb_DynCall( { "mysql_close", pLib, HB_DYN_CALLCONV_CDECL, HB_DYN_CTYPE_LLONG_UNSIGNED }, hMySQL )

//----------------------------------------------------------------//

function mysql_real_connect( cServer, cUserName, cPassword, cDataBaseName, nPort )

   if nPort == nil
      nPort = 3306
   endif   

return hb_DynCall( { "mysql_real_connect", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED, HB_DYN_CALLCONV_CDECL ),;
                     HB_DYN_CTYPE_LLONG_UNSIGNED,;
                     HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CTYPE_CHAR_PTR,;
                     HB_DYN_CTYPE_LONG, HB_DYN_CTYPE_LONG, HB_DYN_CTYPE_LONG },;
                     hMySQL, cServer, cUserName, cPassword, cDataBaseName, nPort, 0, 0 )
                     
//----------------------------------------------------------------//

function mysql_query( hConnect, cQuery )

return hb_DynCall( { "mysql_query", pLib, hb_bitOr( HB_DYN_CTYPE_INT, HB_DYN_CALLCONV_CDECL ),;
                   HB_DYN_CTYPE_LLONG_UNSIGNED, HB_DYN_CTYPE_CHAR_PTR },;
                   hConnect, cQuery )

//----------------------------------------------------------------//

function mysql_use_result( hMySQL )

return hb_DynCall( { "mysql_use_result", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED, HB_DYN_CALLCONV_CDECL ),;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMySQL )

//----------------------------------------------------------------//

function mysql_store_result( hMySQL )

return hb_DynCall( { "mysql_store_result", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED, HB_DYN_CALLCONV_CDECL ),;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMySQL )

//----------------------------------------------------------------//

function mysql_free_result( hMyRes) 

return hb_DynCall( { "mysql_free_result", pLib, HB_DYN_CALLCONV_CDECL, HB_DYN_CTYPE_LLONG_UNSIGNED }, hMyRes )

//----------------------------------------------------------------//

function mysql_fetch_row( hMyRes )

return hb_DynCall( { "mysql_fetch_row", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED, HB_DYN_CALLCONV_CDECL ) }, hMyRes )

//----------------------------------------------------------------//

function mysql_num_rows( hMyRes )

return hb_DynCall( { "mysql_num_rows", pLib, hb_bitOr( HB_DYN_CALLCONV_CDECL, HB_DYN_CTYPE_LLONG_UNSIGNED ),;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMyRes )

//----------------------------------------------------------------//

function mysql_num_fields( hMyRes )

return hb_DynCall( { "mysql_num_fields", pLib, hb_bitOr( HB_DYN_CALLCONV_CDECL, HB_DYN_CTYPE_LONG_UNSIGNED ),;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMyRes )

//----------------------------------------------------------------//

function mysql_fetch_field( hMyRes )

return hb_DynCall( { "mysql_fetch_field", pLib, hb_bitOr( HB_DYN_CALLCONV_CDECL, HB_DYN_CTYPE_LLONG_UNSIGNED ),;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMyRes )

//----------------------------------------------------------------//

function mysql_get_server_info( hMySQL )

return hb_DynCall( { "mysql_get_server_info", pLib, hb_bitOr( HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CALLCONV_CDECL ), ;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMySql )

//----------------------------------------------------------------//
