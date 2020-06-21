#ifdef __PLATFORM__WINDOWS
   #include "c:\harbour\include\hbdyn.ch"
#else
   #include "/usr/include/harbour/hbdyn.ch"
#endif

#define HB_VERSION_BITWIDTH  17
#define NULL 0         

static pLib, hMySQL := 0, hConnection := 0, hMyRes := 0

//----------------------------------------------------------------//

function Main()

   local nRetVal, n, m, hField, hRow

   // ShowConsole()
   // SetMode( 40, 120 )
   
   pLib = hb_LibLoad( hb_SysMySQL() )

   ?? "pLib = " + ValType( pLib ) + ;
      If( ValType( pLib ) == "P", " (MySQL library properly loaded)", " (MySQL library not found)" )

   if ValType( pLib ) == "P"
      hMySQL = mysql_init()
      ? "hMySQL = " + Str( hMySQL ) + " (MySQL library " + ;
      If( hMySQL != 0, "properly initalized)", "failed to initialize)" )
   endif      
         
   ? If( hMySQL != 0, "MySQL version: " + mysql_get_server_info( hMySQL ), "" )   

   if hMySQL != 0
      ? "Connection = "
      ?? hConnection := mysql_real_connect( "localhost", "harbour", "password", "dbHarbour", 3306 )
      ?? If( hConnection != hMySQL, " (Failed connection)", " (Successfull connection)" )
      ?  If( hConnection != hMySQL, "Error: " + mysql_error( hMySQL ), "" )
   endif
   
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
      ? "<table border=1 cellspacing=0>"
      ?? "<tr>"
      for n = 1 to mysql_num_fields( hMyRes )
         hField = mysql_fetch_field( hMyRes )
         if hField != 0
            ?? "<td>" + PtrToStr( hField, 0 ) + "</td>" 
         endif   
      next
      ?? "</tr>"
      for n = 1 to mysql_num_rows( hMyRes )
         if ( hRow := mysql_fetch_row( hMyRes ) ) != 0
            ?? "<tr>"
               for m = 1 to mysql_num_fields( hMyRes )
                  ?? "<td>" + PtrToStr( hRow, m - 1 ) + "</td>"
               next
            ?? "</tr>"
         endif 
      next   
      ?? "</table>"      
   endif   

   if hMyRes != 0
      mysql_free_result( hMyRes )
   endif

   if hMySQL != 0 
      mysql_close( hMySQL )
   endif   
   
   if ValType( pLib ) == "P"
      ? "MySQL library properly freed: ", HB_LibFree( pLib )
   endif                           

return nil

//----------------------------------------------------------------//

function mysql_init()

return hb_DynCall( { "mysql_init", pLib, hb_bitOr( hb_SysLong(),;
                   hb_SysCallConv() ) }, NULL )

//----------------------------------------------------------------//

function mysql_close( hMySQL )

return hb_DynCall( { "mysql_close", pLib,;
                   hb_SysCallConv(), hb_SysLong() }, hMySQL )

//----------------------------------------------------------------//

function mysql_real_connect( cServer, cUserName, cPassword, cDataBaseName, nPort )

   if nPort == nil
      nPort = 3306
   endif   

return hb_DynCall( { "mysql_real_connect", pLib, hb_bitOr( hb_SysLong(),;
                     hb_SysCallConv() ), hb_SysLong(),;
                     HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CTYPE_CHAR_PTR,;
                     HB_DYN_CTYPE_LONG, HB_DYN_CTYPE_LONG, HB_DYN_CTYPE_LONG },;
                     hMySQL, cServer, cUserName, cPassword, cDataBaseName, nPort, 0, 0 )
                     
//----------------------------------------------------------------//

function mysql_query( hConnect, cQuery )

return hb_DynCall( { "mysql_query", pLib, hb_bitOr( HB_DYN_CTYPE_INT,;
                   hb_SysCallConv() ), hb_SysLong(), HB_DYN_CTYPE_CHAR_PTR },;
                   hConnect, cQuery )

//----------------------------------------------------------------//

function mysql_use_result( hMySQL )

return hb_DynCall( { "mysql_use_result", pLib, hb_bitOr( hb_SysLong(),;
                   hb_SysCallConv() ), hb_SysLong() }, hMySQL )

//----------------------------------------------------------------//

function mysql_store_result( hMySQL )

return hb_DynCall( { "mysql_store_result", pLib, hb_bitOr( hb_SysLong(),;
                   hb_SysCallConv() ), hb_SysLong() }, hMySQL )

//----------------------------------------------------------------//

function mysql_free_result( hMyRes) 

return hb_DynCall( { "mysql_free_result", pLib,;
                   hb_SysCallConv(), hb_SysLong() }, hMyRes )

//----------------------------------------------------------------//

function mysql_fetch_row( hMyRes )

return hb_DynCall( { "mysql_fetch_row", pLib, hb_bitOr( hb_SysLong(),;
                   hb_SysCallConv() ), hb_SysLong() }, hMyRes )

//----------------------------------------------------------------//

function mysql_num_rows( hMyRes )

return hb_DynCall( { "mysql_num_rows", pLib, hb_bitOr( hb_SysLong(),;
                  hb_SysCallConv() ), hb_SysLong() }, hMyRes )

//----------------------------------------------------------------//

function mysql_num_fields( hMyRes )

return hb_DynCall( { "mysql_num_fields", pLib, hb_bitOr( HB_DYN_CTYPE_LONG_UNSIGNED,;
                   hb_SysCallConv() ), hb_SysLong() }, hMyRes )

//----------------------------------------------------------------//

function mysql_fetch_field( hMyRes )

return hb_DynCall( { "mysql_fetch_field", pLib, hb_bitOr( hb_SysLong(),;
                   hb_SysCallConv() ), hb_SysLong() }, hMyRes )

//----------------------------------------------------------------//

function mysql_get_server_info( hMySQL )

return hb_DynCall( { "mysql_get_server_info", pLib, hb_bitOr( HB_DYN_CTYPE_CHAR_PTR,;
                   hb_SysCallConv() ), hb_SysLong() }, hMySql )

//----------------------------------------------------------------//

function mysql_error( hMySQL )

return hb_DynCall( { "mysql_error", pLib, hb_bitOr( HB_DYN_CTYPE_CHAR_PTR,;
                   hb_SysCallConv() ), hb_SysLong() }, hMySql )

//----------------------------------------------------------------//

function hb_SysLong()

return If( hb_OSIS64BIT(), HB_DYN_CTYPE_LLONG_UNSIGNED, HB_DYN_CTYPE_LONG_UNSIGNED )   

//----------------------------------------------------------------//

function hb_SysCallConv()

return If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL )

//----------------------------------------------------------------//
   
function hb_SysMySQL()

   local cLibName

   if ! "Windows" $ OS()
      if "Darwin" $ OS()
         cLibName = "/usr/local/Cellar/mysql/8.0.16/lib/libmysqlclient.dylib"
      else   
         cLibName = If( hb_version( HB_VERSION_BITWIDTH ) == 64,;
                        "/usr/lib/x86_64-linux-gnu/libmariadb.so.3",; // libmysqlclient.so.20 for mariaDB
                        "/usr/lib/x86-linux-gnu/libmariadbclient.so" )
      endif                  
   else
      cLibName = If( hb_version( HB_VERSION_BITWIDTH ) == 64,;
                     "c:/Apache24/htdocs/libmysql64.dll",;
                     "c:/Apache24/htdocs/libmysql.dll" )
   endif

return cLibName    

//----------------------------------------------------------------//
