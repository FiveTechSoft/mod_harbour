// Code examples to be shared on the web
//----------------------------------------------------------------------------//

function Main()

   local cArgs := AP_Args()

   if ! File( hb_GetEnv( "PRGPATH" ) + "/snippets.dbf" )
      DbCreate( hb_GetEnv( "PRGPATH" ) + "/snippets.dbf",;
                { { "ID",          "C", 20, 0 },;
                  { "DESCRIPTION", "C", 50, 0 },;
                  { "CODE",        "M", 10, 0 } } )
   endif

   USE ( hb_GetEnv( "PRGPATH" ) + "/snippets" ) SHARED NEW

   LOCATE FOR cArgs $ Field->ID

   ?? View( "default" )

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