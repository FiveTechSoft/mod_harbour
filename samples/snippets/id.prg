// Code examples to be shared on the web
//----------------------------------------------------------------------------//

function Main()

   local cArgs := AP_Args()

   AP_HeadersOutSet( "Access-Control-Allow-Origin", "*" )

   if ! File( hb_GetEnv( "PRGPATH" ) + "/snippets.dbf" )
      DbCreate( hb_GetEnv( "PRGPATH" ) + "/snippets.dbf",;
                { { "ID",          "C", 20, 0 },;
                  { "DESCRIPTION", "C", 50, 0 },;
                  { "CODE",        "M", 10, 0 } } )
   endif

   USE ( hb_GetEnv( "PRGPATH" ) + "/snippets" ) SHARED NEW

   LOCATE FOR cArgs $ Field->ID

   if ! Found()
      if AP_Method() == "POST"
         APPEND BLANK
         if RLock()
            Field->Id = DToS( Date() ) + StrTran( Time(), ":", "" )
            Field->Code = hb_UrlDecode( AP_PostPairs()[ "source" ] )
            DbUnLock()
         endif   
      endif
   endif   

   if AP_Method() != "POST"
      if SubStr( AP_Args(), 1, 3 ) == "src"
         ?? Field->Code
      else   
         ?? View( "default" )
      endif   
   else
      ?? Field->Id 
   endif      

   USE

return nil      

//----------------------------------------------------------------------------//

function View( cName )

   local cData

   if File( hb_GetEnv( "PRGPATH" ) + "/views/" + cName + ".view" )
      cData = MemoRead( hb_GetEnv( "PRGPATH" ) + "/views/" + cName + ".view" )
      while ReplaceBlocks( @cData, "{{", "}}" )
      end
   else
      cData = "<h2>" + cName + " not found!</h2>" 
   endif    

return cData

//----------------------------------------------------------------------------//

function GetCode()

   local cCode 

   TEXT TO cCode
function Main()

   ? "Hello world"

return nil
   ENDTEXT
   
return If( Found(), field->code, cCode )  

//----------------------------------------------------------------------------//