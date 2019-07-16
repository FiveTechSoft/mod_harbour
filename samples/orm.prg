#include "hbclass.ch"
#include "set.ch"
#include "hbdyn.ch"

#define NULL  0  

#command SELECT <fields,...> [ FROM <cTableName> ] [ INTO <oTable> ]=> ;
            [ <oTable> := ] oOrm:Table( <cTableName>, <fields> ) 

static pLib, hMySQL

//----------------------------------------------------------------------------//

function Main()

   local oOrm, oTable

   // ShowConsole() 
   // SetMode( 60, 120 )

   oOrm = OrmConnect( "MYSQL", "localhost", "harbour", "password", "dbHarbour", 3306 )
   // OrmConnect()

   SELECT "*" FROM "users" INTO oTable

   ? oTable:Count()
   ? oTable:Name

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
         if ! "Windows" $ OS()
            pLib = hb_LibLoad( "/usr/lib/x86_64-linux-gnu/libmysqlclient.so" ) // libmysqlclient.so.20 for mariaDB
         else
            pLib = hb_LibLoad( "c:/Apache24/htdocs/libmysql64.dll" )
         endif  
         if ! Empty( pLib )
            hMySQL = mysql_init()
            if hMySQL != 0
               ::hConnection = mysql_real_connect( cServer, cUsername, cPassword, cDatabase, nPort )
               if ::hConnection != hMySQL
                  ? "Error on connection to server " + cServer
               endif   
            endif 
         else
            ? "c:/Apache24/htdocs/libmysql64.dll not available"     
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
      USE ( cTableName ) VIA ::cRdbms SHARED
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

   DATA  Name
   DATA  Orm

   METHOD New( cTableName, oOrm, ... )

   METHOD Count() VIRTUAL   

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
   METHOD Count() INLINE RecCount()

ENDCLASS      

//----------------------------------------------------------------------------//

METHOD New( cTableName, oOrm, ... ) CLASS DbfTable

   ::Super:New( cTableName, oOrm, ... )
   
   ::cAlias = Alias()

return Self   

//----------------------------------------------------------------------------//

CLASS MySQLTable FROM OrmTable

   DATA  hMyRes

   METHOD New( cTableName, oOrm, ... )

   METHOD Count() INLINE mysql_num_rows( ::hMyRes )   

ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( cTableName, oOrm, ... ) CLASS MySQLTable

   ::Super:New( cTableName, oOrm, ... )

   ::hMyRes = mysql_store_result( oOrm:hConnection )

   if ::hMyRes == 0
      ? "mysql_store_results() failed"
   endif
   
return Self   

//----------------------------------------------------------------------------//

function mysql_init()

return hb_DynCall( { "mysql_init", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED,;
                   If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ) ) }, NULL )

//----------------------------------------------------------------//

function mysql_close( hMySQL )

return hb_DynCall( { "mysql_close", pLib,;
                   If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ),;
                   HB_DYN_CTYPE_LLONG_UNSIGNED }, hMySQL )

//----------------------------------------------------------------//

function mysql_real_connect( cServer, cUserName, cPassword, cDataBaseName, nPort )

   if nPort == nil
      nPort = 3306
   endif   

return hb_DynCall( { "mysql_real_connect", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED,;
                     If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ) ),;
                     HB_DYN_CTYPE_LLONG_UNSIGNED,;
                     HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CTYPE_CHAR_PTR, HB_DYN_CTYPE_CHAR_PTR,;
                     HB_DYN_CTYPE_LONG, HB_DYN_CTYPE_LONG, HB_DYN_CTYPE_LONG },;
                     hMySQL, cServer, cUserName, cPassword, cDataBaseName, nPort, 0, 0 )
                     
//----------------------------------------------------------------//

function mysql_query( hConnect, cQuery )

return hb_DynCall( { "mysql_query", pLib, hb_bitOr( HB_DYN_CTYPE_INT,;
                   If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ) ),;
                   HB_DYN_CTYPE_LLONG_UNSIGNED, HB_DYN_CTYPE_CHAR_PTR },;
                   hConnect, cQuery )

//----------------------------------------------------------------//

function mysql_use_result( hMySQL )

return hb_DynCall( { "mysql_use_result", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED,;
                     If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ) ),;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMySQL )

//----------------------------------------------------------------//

function mysql_store_result( hMySQL )

return hb_DynCall( { "mysql_store_result", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED,;
                     If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ) ),;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMySQL )

//----------------------------------------------------------------//

function mysql_free_result( hMyRes) 

return hb_DynCall( { "mysql_free_result", pLib,;
                   If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ),;
                   HB_DYN_CTYPE_LLONG_UNSIGNED }, hMyRes )

//----------------------------------------------------------------//

function mysql_fetch_row( hMyRes )

return hb_DynCall( { "mysql_fetch_row", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED,;
                   If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ) ),;
                   HB_DYN_CTYPE_LLONG_UNSIGNED }, hMyRes )

//----------------------------------------------------------------//

function mysql_num_rows( hMyRes )

return hb_DynCall( { "mysql_num_rows", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED,;
                     If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ) ),;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMyRes )

//----------------------------------------------------------------//

function mysql_num_fields( hMyRes )

return hb_DynCall( { "mysql_num_fields", pLib, hb_bitOr( HB_DYN_CTYPE_LONG_UNSIGNED,;
                     If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ) ),;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMyRes )

//----------------------------------------------------------------//

function mysql_fetch_field( hMyRes )

return hb_DynCall( { "mysql_fetch_field", pLib, hb_bitOr( HB_DYN_CTYPE_LLONG_UNSIGNED,;
                     If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ) ),;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMyRes )

//----------------------------------------------------------------//

function mysql_get_server_info( hMySQL )

return hb_DynCall( { "mysql_get_server_info", pLib, hb_bitOr( HB_DYN_CTYPE_CHAR_PTR,;
                     If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ) ), ;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMySql )

//----------------------------------------------------------------//

function mysql_error( hMySQL )

return hb_DynCall( { "mysql_error", pLib, hb_bitOr( HB_DYN_CTYPE_CHAR_PTR,;
                     If( ! "Windows" $ OS(), HB_DYN_CALLCONV_CDECL, HB_DYN_CALLCONV_STDCALL ) ), ;
                     HB_DYN_CTYPE_LLONG_UNSIGNED }, hMySql )

//----------------------------------------------------------------//