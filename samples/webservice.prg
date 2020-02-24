function Main()

   AP_SetContentType( "application/json" )

   ?? hb_jsonEncode( { "Method" => AP_Method(), "Args" => AP_Args(), "Body" => AP_Body() } )
   ? "<hr>" 

   do case
      case AP_Method() == "GET"
         ? "GET request"

      case AP_Method() == "POST"
         ? "POST request"
   endcase

return nil
