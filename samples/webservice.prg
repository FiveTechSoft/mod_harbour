function Main()

   AP_SetContentType( "application/json" )

   ?? hb_jsonEncode( { "Method" => AP_Method(), "Args" => AP_Args() } )

return nil
