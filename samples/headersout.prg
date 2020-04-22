function Main()

   AP_HeadersOutSet( "one", "first" )
   
   SetCookie( "two", "second" )

   ? AP_HeadersOut()

return nil
