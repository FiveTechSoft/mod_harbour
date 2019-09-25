//----------------------------------------------------------------------------//

CLASS SeamapModel

   METHOD New()             
   METHOD Add() 
   METHOD Edit()
   METHOD Browse( hData ) 
   METHOD BrowseNext() VIRTUAL
   METHOD BrowsePrev() VIRTUAL
   METHOD Delete( nRecNo ) 
   METHOD Save( nRecno, hData )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS SeamapModel

   if ! File( hb_GetEnv( "PRGPATH" ) + "/data/links.dbf" )
      DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/links.dbf",;
         { { "LINKDEST", "C", 200, 0 },;
           { "LINKNAME", "C", 200, 0 },;
           { "LONGTEXT", "M", 10, 0 } } )
   endif

   if Alias() != "LINKS"
      USE ( hb_GetEnv( "PRGPATH" ) + "/data/links" ) SHARED NEW
   endif

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

return Self

//----------------------------------------------------------------------------//

METHOD Add() CLASS SeamapModel

   APPEND BLANK
   field->linkdest := "www.new.com"
   field->linkname := "new"
   field->longText := "a new link"
   GO TOP

return nil   

//----------------------------------------------------------------------------//

METHOD Browse() CLASS SeamapModel

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

METHOD Delete( nRecNo ) CLASS SeamapModel

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

METHOD Edit( nRecNo ) CLASS SeamapModel

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

METHOD Save( nRecNo, hData ) CLASS SeamapModel  

   GOTO nRecno 

   if RLock()
      for n = 1 to FCount()
         if hb_HHasKey( hData, FieldName( n ) )
            do case
               case FieldType( n ) == "D"
                     FieldPut( n, CToD( hb_UrlDecode( hb_HGet( hData, FieldName( n ) ) ) ) )

               case FieldType( n ) == "L"
                     FieldPut( n, "on" $ hb_UrlDecode( hb_HGet( hData, FieldName( n ) ) ) )     
            
               otherwise   
                     FieldPut( n, hb_UrlDecode( hb_HGet( hData, FieldName( n ) ) ) )
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

return 

//----------------------------------------------------------------------------//