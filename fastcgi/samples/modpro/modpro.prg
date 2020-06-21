//----------------------------------------------------------------------------//

function Main()

   local cArgs := mh_Query()

   ?? View( "default" )

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
   
return cCode  

//----------------------------------------------------------------------------//
