#ifdef __PLATFORM__WINDOWS
   #include "c:\harbour\include\hbclass.ch"
   #include "c:\harbour\include\set.ch"
   #include "c:\harbour\include\hbdyn.ch"
#else
   #include "/usr/include/harbour/hbclass.ch"
   #include "/usr/include/harbour/set.ch"
   #include "/usr/include/harbour/hbdyn.ch"
#endif

#define HB_VERSION_BITWIDTH  17
#define NULL  0  

#command SELECT <fields,...> [ FROM <cTableName> ] [ INTO <oTable> ]=> ;
            [ <oTable> := ] oOrm:Table( <cTableName>, <fields> )
            
#command CREATE TABLE <cTableName> FIELDS <aFields> => ;
            oOrm:CreateTable( <cTableName>, <aFields> )            

static pLib, hMySQL

//----------------------------------------------------------------------------//

function Main()

   local oOrm, oTable, n, m

   // ShowConsole() 
   // SetMode( 60, 120 )

   oOrm = OrmConnect( "MYSQL", "localhost", "harbour", "password", "dbHarbour", 3306 )
   // oOrm = OrmConnect( "DBFNTX", hb_GetEnv( "PRGPATH" ) + "/data/" )

   CREATE TABLE "menus" FIELDS { { "GLYPH",  "C", 20, 0 },;
                                 { "PROMPT", "C", 30, 0 },;
                                 { "ACTION", "C", 50, 0 } }

   ? oOrm:cSQL 

   SELECT "*" FROM "menus" INTO oTable

   ? oTable:Name
   ? oTable:Count()

   SELECT "*" FROM "users" INTO oTable

   ? "Name of the table: ", oTable:Name
   ? "Number of records: ", oTable:Count()

   for n = 1 to oTable:FCount()
      ? "Field name", n, ":", oTable:FieldName( n )
      ? "Field type", n, ":", oTable:FieldType( n )
   next   

   ? oTable:FieldPos( "name" )

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
   DATA  nRetVal
   DATA  cSQL

   METHOD New( cRdbms, cServer, cUsername, cPassword, cDatabase, nPort )

   METHOD Table( cTableName, ... )

   METHOD CreateTable( cTableName, aFields )

   METHOD Exec( cSQL ) INLINE ::nRetVal := mysql_query( ::hConnection, ::cSQL := cSQL ) 

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
         AAdd( ::Tables, oTable )   
      endif   
   endif

return oTable

//----------------------------------------------------------------------------//

METHOD CreateTable( cTableName, aFields ) CLASS Orm

   local cSQL, n, hTypes 

   if ::cRdbms $ "MYSQL,MARIADB"
      cSQL = "CREATE TABLE " + cTableName + " ("
      hTypes = {=>}
      hTypes[ "C" ] = "varchar"
      for n = 1 to Len( aFields )
         if n > 1
            cSQL += ","
         endif   
         cSQL += aFields[ n ][ 1 ] + " " + hTypes[ aFields[ n ][ 2 ] ] + "(" + ;
                 AllTrim( Str( aFields[ n ][ 3 ] ) ) + ")"
      next          
      cSQL += ")"
      ::Exec( cSQL )
      if ::nRetVal != 0
         ? mysql_error( hMySQL )
      endif   
   else
      DbCreate( cTableName, aFields, ::cRdbms )   
   endif
   
return nil   

//----------------------------------------------------------------------------//

CLASS OrmTable

   DATA   Name
   DATA   Orm
   DATA   aFields

   METHOD New( cTableName, oOrm, ... )

   METHOD Count()  VIRTUAL 
   METHOD FCount() VIRTUAL   
   METHOD FieldName( n ) VIRTUAL
   METHOD FieldGet( ncField ) VIRTUAL
   METHOD FieldPut( ncField, uValue ) VIRTUAL   
   METHOD FieldPos( cFieldName )
   METHOD FieldType( cnField ) VIRTUAL   
   METHOD First() VIRTUAL
   METHOD Last()  VIRTUAL         
   METHOD Next()  VIRTUAL  
   METHOD Prev()  VIRTUAL       

ENDCLASS 

//----------------------------------------------------------------------------//

METHOD New( cTableName, oOrm, ... ) CLASS OrmTable

   ::Name = cTableName
   ::Orm  = oOrm

return Self   

//----------------------------------------------------------------------------//

METHOD FieldPos( cFieldName ) CLASS OrmTable

   cFieldName = Upper( cFieldName )

return AScan( ::aFields, { | aField | Upper( aField[ 1 ] ) == cFieldName } )   

//----------------------------------------------------------------------------//

CLASS DbfTable FROM OrmTable

   DATA   cAlias

   METHOD New( cTableName, oOrm, ... )

   METHOD Count()  INLINE RecCount()
   METHOD FCount() INLINE FCount()
   METHOD FieldName( n ) INLINE FieldName( n )

   METHOD FieldGet( ncField ) ;
      INLINE FieldGet( If( ValType( ncField ) == "C", ::FieldPos( ncField ), ncField ) )

   METHOD FieldPut( ncField, uValue ) INLINE ;
                    If( RLock(), ( FieldPut( If( ValType( ncField ) == "C",;
                        ::FieldPos( ncField ), ncField ), uValue ), DbUnLock() ),)   

   METHOD FieldType( ncField ) INLINE ;
            FieldType( If( ValType( ncField ) == "C", ::FieldPos( ncField ), ncField ) )

   METHOD Next()  INLINE DbSkip()
   METHOD Prev()  INLINE DbSkip( -1 )   
   METHOD First() INLINE DbGoTop()
   METHOD Last()  INLINE DbGoBottom()   

ENDCLASS      

//----------------------------------------------------------------------------//

METHOD New( cTableName, oOrm, ... ) CLASS DbfTable

   ::Super:New( cTableName, oOrm, ... )
   
   ::cAlias  = Alias()
   ::aFields = DbStruct()

return Self   

//----------------------------------------------------------------------------//

CLASS MySQLTable FROM OrmTable

   DATA   hMyRes
   DATA   aRows
   DATA   nRow   INIT 1

   METHOD New( cTableName, oOrm, ... )

   METHOD Count()  INLINE mysql_num_rows( ::hMyRes )   
   METHOD FCount() INLINE Len( ::aFields )
   METHOD FieldName( n ) INLINE ::aFields[ n ][ 1 ]

   METHOD FieldGet( ncField )  INLINE ;
      ::aRows[ ::nRow ][ If( ValType( ncField ) == "C", ::FieldPos( ncField ), ncField ) ]

   METHOD FieldPut( ncField, uValue ) INLINE ;
      ::aRows[ ::nRow ][ If( ValType( ncField ) == "C", ::FieldPos( ncField ), ncField ) ] := uValue   

   METHOD FieldType( ncField ) INLINE ;
      ::aFields[ If( ValType( ncField ) == "C", ::FieldPos( ncField ), ncField ) ][ 2 ]  

   METHOD Next()   INLINE ::nRow++   
   METHOD Prev()   INLINE If( ::nRow > 1, ::nRow--,)   
   METHOD First()  INLINE ::nRow := 1
   METHOD Last()   INLINE ::nRow := Len( ::aRows )

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
            do case
               case AScan( { 253, 254, 12 }, PtrToUI( hField, hb_SysMyTypePos() ) ) != 0
                    ::aFields[ n ][ 2 ] = "C"

               case AScan( { 1, 3, 4, 5, 8, 9, 246 }, PtrToUI( hField, hb_SysMyTypePos() ) ) != 0
                    ::aFields[ n ][ 2 ] = "N"

               case AScan( { 10 }, PtrToUI( hField, hb_SysMyTypePos() ) ) != 0
                    ::aFields[ n ][ 2 ] = "D"

               case AScan( { 250, 252 }, PtrToUI( hField, hb_SysMyTypePos() ) ) != 0
                    ::aFields[ n ][ 2 ] = "M"
            endcase 
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
         cLibName = If( hb_version( HB_VERSION_BITWIDTH ) == 64,;
                        "/usr/lib/x86_64-linux-gnu/libmariadbclient.so",; // libmysqlclient.so.20 for mariaDB
                        "/usr/lib/x86-linux-gnu/libmariadbclient.so" )
      endif                  
   else
      cLibName = If( hb_version( HB_VERSION_BITWIDTH ) == 64,;
                     "c:/Apache24/htdocs/libmysql64.dll",;
                     "c:/Apache24/htdocs/libmysql.dll" )
   endif

return cLibName    

//----------------------------------------------------------------//

function hb_SysMyTypePos()

return If( hb_version( HB_VERSION_BITWIDTH ) == 64,;
       If( "Windows" $ OS(), 26, 28 ), 19 )   

//----------------------------------------------------------------//
