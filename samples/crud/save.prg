//----------------------------------------------------------------------------//

function Main()

   ?? "Table:", GetRequest()

   ? AP_PostPairs()

return nil   

//----------------------------------------------------------------------------//

function GetRequest()

   local cArgs := AP_Args(), cRequest

   if At( "&", cArgs ) != 0
      cRequest = SubStr( cArgs, 1, At( "&", cArgs ) - 1 )
   else
      cRequest = cArgs
   endif
   
return cRequest

//----------------------------------------------------------------------------//