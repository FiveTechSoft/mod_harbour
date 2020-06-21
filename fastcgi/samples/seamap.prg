// {% hb_SetEnv( "HB_INCLUDE", If( "Windows" $ OS(), "c:/", If( "Darwin" $ OS(), "/Users/user", "/home/user" ) ) + "/harbour/include" ) %}

//----------------------------------------------------------------------------//

#include "hbclass.ch"

function Main()

   CheckTables()
   Controller()

return nil

//----------------------------------------------------------------------------//

function Controller()

   local cMethod := AP_Method()
   local aArgs  := hb_aTokens( AP_Args(), ":" )
   local oModel := Model():New()
   local oView  := View():New()
   local nRecNo 

   if Len( aArgs ) > 1
      nRecNo = Val( aArgs[ 2 ] )
   endif   

   do case

      case cMethod == "GET"
         ? "We process a GET"

         do case
            case aArgs[ 1 ] == "add"
               ? "add is required" + "<br>"
               oModel:Add()
               ? oView:Browse( oModel:Browse() )

            case aArgs[ 1 ] == "edit"
               ? "edit is required" + "<br>"
               ? oView:Edit( oModel:Edit( nRecNo ) )

            case aArgs[ 1 ] == "next"
               ? "browse next is required" + "<br>"
               oModel:BrowseNext()

            case aArgs[ 1 ] == "prev"
               ? "browse prev is required" + "<br>"
               oModel:BrowsePrev()

            case aArgs[ 1 ] == "del"
               ? "del is required" + "<br>"
               oModel:Delete( nRecNo )
               ? oView:Browse( oModel:Browse() )   

            otherwise
               ? "default browse" + "<br>"
               ? oView:Browse( oModel:Browse() )   
         endcase

      case cMethod == "POST"
         ? "We process a POST"
         oModel:Save()
         ? oView:Browse( oModel:Browse() )   
      endcase

return nil

//----------------------------------------------------------------------------//

function CheckTables()

   if ! File( hb_GetEnv( "PRGPATH" ) + "/data/links.dbf" )
      DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/links.dbf",;
         { { "LINKDEST", "C", 200, 0 },;
           { "LINKNAME", "C", 200, 0 },;
           { "LONGTEXT", "M", 10, 0 } } )
   endif

   USE ( hb_GetEnv( "PRGPATH" ) + "/data/links" ) SHARED NEW

   if RecCount() == 0
      APPEND BLANK
      field->linkdest := "www.google.com"
      field->linkname := "google"
      field->longText := "search engine"
      APPEND BLANK
      field->linkdest := "www.modharbour.live"
      field->linkname := "mod_harbour"
      field->longText := "harbour on the web"
      GO TOP
   endif   

return nil

//----------------------------------------------------------------------------//

CLASS Model

   METHOD Add() 
   METHOD Edit()
   METHOD Browse( hData ) 
   METHOD BrowseNext() VIRTUAL
   METHOD BrowsePrev() VIRTUAL
   METHOD Delete( nRecNo ) 
   METHOD Save( nRecNo ) 

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Add() CLASS Model

   APPEND BLANK
   field->linkdest := "www.new.com"
   field->linkname := "new"
   field->longText := "a new link"

   GO TOP

return nil   

//----------------------------------------------------------------------------//

METHOD Browse() CLASS Model

   local hData := {=>}
   local n, aHeaders := {}, aRows := {}, aRow := {}

   for n = 1 to FCount()
      AAdd( aHeaders, FieldName( n ) )
   next
   
   hData[ "headers" ] = aHeaders

   while ! Eof()
      aRow = {}
      for n = 1 to FCount()
         AAdd( aRow, AllTrim( FieldGet( n ) ) )
      next
      AAdd( aRows, aRow )
      SKIP
   end      

   hData[ "rows" ] = aRows

return hData   

//----------------------------------------------------------------------------//

METHOD Delete( nRecNo ) CLASS Model

   GOTO nRecNo
   
   if RLock()
      DELETE
      DbUnLock() 
   endif

   USE 
   USE ( hb_GetEnv( "PRGPATH" ) + "/data/links" )
   PACK
   USE
   USE ( hb_GetEnv( "PRGPATH" ) + "/data/links" ) SHARED NEW

   GO TOP
   
return nil   

//----------------------------------------------------------------------------//

METHOD Edit( nRecNo ) CLASS Model

   local hData := {=>}
   local n, aFields := {}, aValues := {}

   GOTO nRecNo

   for n = 1 to FCount()
      AAdd( aFields, FieldName( n ) )
      AAdd( aValues, FieldGet( n ) )
   next
   
   hData[ "fields" ] = aFields
   hData[ "values" ] = aValues
   hData[ "recno"  ] = nRecNo

return hData   

//----------------------------------------------------------------------------//

METHOD Save() CLASS Model

   local n, hPairs := AP_PostPairs()
   
   GOTO Val( hPairs[ "recno" ] )

   if RLock()
      for n = 1 to FCount()
         if hb_HHasKey( hPairs, FieldName( n ) )
            do case
               case FieldType( n ) == "D"
                     FieldPut( n, CToD( hb_UrlDecode( hb_HGet( hPairs, FieldName( n ) ) ) ) )

               case FieldType( n ) == "L"
                     FieldPut( n, "on" $ hb_UrlDecode( hb_HGet( hPairs, FieldName( n ) ) ) )     
            
               otherwise   
                     FieldPut( n, hb_UrlDecode( hb_HGet( hPairs, FieldName( n ) ) ) )
            endcase   
         else
            if FieldType( n ) == "L"
               FieldPut( n, .F. )
            endif      
         endif 
      next
      DbUnLock()
   endif

   GO TOP 

return nil      

//----------------------------------------------------------------------------//

CLASS View

   DATA   cHTML INIT ""

   METHOD New()
   METHOD Browse( hData )
   METHOD Edit( hData )   
   METHOD End()   

ENDCLASS      

//----------------------------------------------------------------------------//

METHOD New() CLASS View

   local cHeader

   TEXT INTO cHeader
      <html>
      <head>
         <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
         <style>
            table, th, td {
               border: 1px solid black;
               border-collapse: collapse;
            }
         </style>
         <script>
            function add()
            {
               location.href = "seamap.prg?add";
            }
            function edit( nRecord )
            {
               location.href = "seamap.prg?edit:" + nRecord;
            }   
            function del( nRecord )
            {
               location.href = "seamap.prg?del:" + nRecord;
            }
            function cancel()
            {
               location.href = "seamap.prg";

               return false;
            }   
            </script>   
      </head>
      <body>
   ENDTEXT   

   ::cHTML += cHeader + CRLF

return Self 

//----------------------------------------------------------------------------//

METHOD Browse( hData ) CLASS View

   local n, nRow

   ::cHtml += "<button onclick='add()'>Add</button><br><br>" + CRLF
   ::cHtml += "<table>" + CRLF + "<tr>" + CRLF

   for n = 1 to Len( hData[ "headers" ] )
      ::cHtml += "<th>" + hData[ "headers" ][ n ] + "</th>"
   next
   ::cHtml += "<th>Actions</th>"

   for n = 1 to Len( hData[ "rows" ] )
      ::cHtml += "<tr>" + CRLF
      for nRow = 1 to Len( hData[ "rows" ][ n ] )
         ::cHtml += "<td>" + hData[ "rows" ][ n ][ nRow ] + "</td>" + CRLF
      next   
      ::cHtml += "<td>"
      ::cHtml += '<button type="button" onclick="edit(' + AllTrim( Str( n ) ) + ")" + '" class="btn btn-xs btn-default">'
      ::cHtml += '   <span class="glyphicon glyphicon-pencil"></span>'
      ::cHtml += "</button>"
      ::cHtml += '<button type="button" onclick="del(' + AllTrim( Str( n ) ) + ")" + '" class="remove-news btn btn-xs btn-default" data-toggle="tooltip" data-placement="top" data-original-title="Delete">'
      ::cHtml += '   <span class="glyphicon glyphicon-trash"></span>'
      ::cHtml += "</button>"
      ::cHtml += "</td>"
      ::cHtml += "</tr>" + CRLF
   next
   
   ::cHtml += "</table>" + CRLF
   ::End() 

return ::cHtml   

//----------------------------------------------------------------------------//

METHOD Edit( hData ) CLASS View

   local n

   ::cHtml += "<form action='seamap.prg' method='post'>" + CRLF

   ::cHtml += "<table>" + CRLF + "<tr>" + CRLF
   ::cHtml += "<tr>" + CRLF
   ::cHtml += "<th>FieldName</th>" + CRLF
   ::cHtml += "<th>Value</th>" + CRLF
   ::cHtml += "</tr>" + CRLF 

   for n = 1 to Len( hData[ "fields" ] )
      ::cHtml += "<tr>" + CRLF
      ::cHtml += "<td>" + hData[ "fields" ][ n ] + "</td>" + CRLF
      ::cHtml += "<td><input name='" + hData[ "fields" ][ n ] + "' type='text' value='" + hData[ "values" ][ n ] + "'></td>" + CRLF
      ::cHtml += "</tr>" + CRLF
   next
   
   ::cHtml += "</table><br>" + CRLF
   ::cHtml += "<input type='text' name='recno' id='recno' value='" + AllTrim( Str( hData[ "recno" ] ) ) + "' hidden>"
   ::cHtml += "<input type='submit' value='Save'>"
   ::cHtml += "<input type='button' onclick='cancel()' value='Cancel'>" + CRLF
   ::cHtml += "</form>" 
   ::End()

return ::cHtml   

//----------------------------------------------------------------------------//

METHOD End() CLASS View

   ::cHtml += "</body>" + CRLF
   ::cHtml += "</html>"

return nil

//----------------------------------------------------------------------------//
