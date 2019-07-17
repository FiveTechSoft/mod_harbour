// {% hb_SetEnv( "HB_INCLUDE", "/home/anto/harbour/include" ) %}

#include "hbclass.ch"
#include "set.ch"
#include "hbdyn.ch"

#define NULL  0  

#command SELECT <fields,...> [ FROM <cTableName> ] [ INTO <oTable> ]=> ;
            [ <oTable> := ] oOrm:Table( <cTableName>, <fields> ) 

static pLib, hMySQL

//----------------------------------------------------------------------------//

function Main()

   local oOrm, oTable, n, m

   // ShowConsole() 
   // SetMode( 60, 120 )

   oOrm = OrmConnect( "MYSQL", "localhost", "harbour", "password", "dbHarbour", 3306 )
   // oOrm = OrmConnect( "DBFNTX", hb_GetEnv( "PRGPATH" ) + "/data/" )

   SELECT "*" FROM "users" INTO oTable

   ? "Name of the table: ", oTable:Name
   ? "Number of records: ", oTable:Count()

   for n = 1 to oTable:FCount()
      ? "Field name", n, ":", oTable:FieldName( n )
   next   

   for n = 1 to oTable:Count()
      for m = 1 to oTable:FCount()
         ? oTable:FieldGet( m )
      next
      oTable:Next()
   next    

return nil

//----------------------------------------------------------------------------//

function OrmConnect( cRdbms, cServer, cUsername, cPassword, cDatabase, nPort )

return Orm():New( cRdbms, cServer, cUsername, cPassword, cDatabase, nPort )

//----------------------------------------------------------------------------//

CLASS Orm

   DATA  cRdbms
   DATA  cServer
   DATA  cUsername
   DATA  cDatabase
   DATA  nPort
   DATA  hConnection 
   DATA  Tables   INIT {}

   METHOD New( cRdbms, cServer, cUsername, cPassword, cDatabase, nPort )

   METHOD Table( cTableName, ... )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cRdbms, cServer, cUsername, cPassword, cDatabase, nPort ) CLASS Orm

   hb_default( @cRdbms, RddSetDefault() )
   hb_default( @cServer, Set( _SET_PATH ) )

   ::cRdbms    = cRdbms
   ::cServer   = cServer
   ::cUsername = cUsername
   ::cDatabase = cDatabase
   ::nPort     = nPort

   do case
      case cRdbms == "MYSQL"
         pLib = hb_LibLoad( hb_SysMySQL() )
         if ! Empty( pLib )
            hMySQL = mysql_init()
            if hMySQL != 0
               ::hConnection = mysql_real_connect( cServer, cUsername, cPassword, cDatabase, nPort )
               if ::hConnection != hMySQL
                  ? "Error on connection to server " + cServer
               endif   
            endif 
         else
            ? hb_SysMySQL() + " not available"     
         endif   
   endcase

return Self

//----------------------------------------------------------------------------//

METHOD Table( cTableName, ... ) CLASS Orm

   local oTable, cFields := "", n, nRetVal

   if Empty( ::cRdbms )
      ::New()
   endif   

   if ! ::cRdbms $ "MYSQL,MARIADB"
      USE ( ::cServer + cTableName ) VIA ::cRdbms SHARED
      oTable = DbfTable():New( cTableName, Self )
      AAdd( ::Tables, oTable )
   else
      for n = 2 to PCount()
         cFields += If( n > 2, ",", "" ) + PValue( n )
      next   
      nRetVal = mysql_query( ::hConnection, "select " + cFields + " from " + cTableName )
      if nRetVal != 0
         ? "error selecting table " + cTableName, mysql_error( hMySQL )
      else
         oTable = MySqlTable():New( cTableName, Self, ... )   
      endif   
   endif

return oTable

//----------------------------------------------------------------------------//

CLASS OrmTable

   DATA   Name
   DATA   Orm
   DATA   aFields

   METHOD New( cTableName, oOrm, ... )

   METHOD Count() VIRTUAL 
   METHOD FCount() VIRTUAL   
   METHOD FieldName( n ) VIRTUAL
   METHOD FieldGet( n ) VIRTUAL
   METHOD Next() VIRTUAL      

ENDCLASS 

//----------------------------------------------------------------------------//

METHOD New( cTableName, oOrm, ... ) CLASS OrmTable

   ::Name = cTableName
   ::Orm  = oOrm

return Self   

//----------------------------------------------------------------------------//

CLASS DbfTable FROM OrmTable

   DATA   cAlias

   METHOD New( cTableName, oOrm, ... )

   METHOD Count()  INLINE RecCount()
   METHOD FCount() INLINE FCount()
   METHOD FieldName( n ) INLINE FieldName( n )
   METHOD FieldGet( n ) INLINE FieldGet( n )
   METHOD Next() INLINE DbSkip()

ENDCLASS      

//----------------------------------------------------------------------------//

METHOD New( cTableName, oOrm, ... ) CLASS DbfTable

   ::Super:New( cTableName, oOrm, ... )
   
   ::cAlias = Alias()

return Self   

//----------------------------------------------------------------------------//

CLASS MySQLTable FROM OrmTable

   DATA   hMyRes
   DATA   aRows
   DATA   nRow   INIT 1

   METHOD New( cTableName, oOrm, ... )

   METHOD Count() INLINE mysql_num_rows( ::hMyRes )   
   METHOD FCount() INLINE Len( ::aFields )
   METHOD FieldName( n ) INLINE ::aFields[ n ][ 1 ]
   METHOD FieldGet( n ) INLINE ::aRows[ ::nRow ][ n ]
   METHOD Next() INLINE ::nRow++   

ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( cTableName, oOrm, ... ) CLASS MySQLTable

   local n, m, hField, hRow

   ::Super:New( cTableName, oOrm, ... )

   ::hMyRes = mysql_store_result( oOrm:hConnection )

   if ::hMyRes == 0
      ? "mysql_store_results() failed"
   else
      ::aFields = Array( mysql_num_fields( ::hMyRes ) )
      
      for n = 1 to Len( ::aFields )
         hField = mysql_fetch_field( ::hMyRes )
         if hField != 0
            ::aFields[ n ] = Array( 4 )
            ::aFields[ n ][ 1 ] = PtrToStr( hField, 0 )
         endif   
      next   

      ::aRows = Array( mysql_num_rows( ::hMyRes ), ::FCount() )

      for n = 1 to Len( ::aRows )
         if ( hRow := mysql_fetch_row( ::hMyRes ) ) != 0
            for m = 1 to ::FCount()
               ::aRows[ n, m ] = PtrToStr( hRow, m - 1 )
            next
         endif
      next         

   endif
   
return Self   

//----------------------------------------------------------------------------//

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
         cLibName = If( hb_OSIS64BIT(),;
                        "/usr/lib/x86_64-linux-gnu/libmysqlclient.so",; // libmysqlclient.so.20 for mariaDB
                        "/usr/lib/x86-linux-gnu/libmysqlclient.so" )
      endif                  
   else
      cLibName = If( hb_OSIS64BIT(),;
                     "c:/Apache24/htdocs/libmysql64.dll",;
                     "c:/Apache24/htdocs/libmysql.dll" )
   endif

return cLibName    

//----------------------------------------------------------------//