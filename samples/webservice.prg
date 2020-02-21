function Main()

   AP_SetContentType( "application/json" )

return hb_jsonEncode( { "Method" => AP_Method(), "Args" => AP_Args() } )
