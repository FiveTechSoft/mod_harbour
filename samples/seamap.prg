// {% hb_SetEnv( "HB_INCLUDE", If( "Windows" $ OS(), "c:/", If( "Darwin" $ OS(), "/Users/anto", "/home/anto" ) ) + "/harbour/include" ) %}

//----------------------------------------------------------------------------//

#include "hbclass.ch"

function Main()

   CheckTables()
   Controller()

return nil

//----------------------------------------------------------------------------//

function Controller()

   local cMethod := AP_Method()
   local aArgs := hb_aTokens( AP_Args(), ":" )
   local oModel := Model():New()
   local oView := View():New()
   
   do case

      case cMethod == "GET"
         ? "We process a GET"

         do case
            case aArgs[ 1 ] == "add"
               ? "add is required"
               oModel:Add()

            case aArgs[ 1 ] == "edit"
               ? "edit is required"
               oModel:Edit()

            case aArgs[ 1 ] == "next"
               ? "browse next is required"
               oModel:BrowseNext()

            case aArgs[ 1 ] == "prev"
               ? "browse prev is required"
               oModel:BrowsePrev()

            case aArgs[ 1 ] == "del"
               ? "del is required"
               oModel:Delete()

            otherwise
               ? "default browse"
               ? oView:Browse( oModel:Browse() )   
         endcase

      case cMethod == "POST"
         ? "We process a POST"
         do case
            case aArgs[ 1 ] == "save"
               ? "save is required"
               oModel:Save()
         endcase
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

   METHOD Add() VIRTUAL
   METHOD Edit() VIRTUAL
   METHOD Browse( hData ) 
   METHOD BrowseNext() VIRTUAL
   METHOD BrowsePrev() VIRTUAL
   METHOD Delete() VIRTUAL
   METHOD Save() VIRTUAL

ENDCLASS

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

CLASS View

   DATA   cHTML INIT ""

   METHOD New()
   METHOD Browse( hData )
   METHOD End()   

ENDCLASS      

//----------------------------------------------------------------------------//

METHOD New() CLASS View

   local cHeader

   TEXT INTO cHeader
      <html>
      <head>
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
         </script>   
      </head>
      <body>
   ENDTEXT   

   ::cHTML += cHeader + CRLF

return Self 

//----------------------------------------------------------------------------//

METHOD Browse( hData ) CLASS View

   local n, nRow

   ::cHtml += "<button onclick='add()'>Add</button>" + CRLF
   ::cHtml += "<table>" + CRLF + "<tr>" + CRLF

   for n = 1 to Len( hData[ "headers" ] )
      ::cHtml += "<th>" + hData[ "headers" ][ n ] + "</th>"
   next

   for n = 1 to Len( hData[ "rows" ] )
      ::cHtml += "<tr>" + CRLF
      for nRow = 1 to Len( hData[ "rows" ][ n ] )
         ::cHtml += "<td>" + hData[ "rows" ][ n ][ nRow ] + "</td>" + CRLF
      next   
      ::cHtml += "</tr>" + CRLF
   next
   
   ::cHtml += "</table>" + CRLF
   ::End() 

return ::cHtml   

//----------------------------------------------------------------------------//

METHOD End() CLASS View

   ::cHtml += "</body>" + CRLF
   ::cHtml += "</html>"

return nil

//----------------------------------------------------------------------------//
