function Main()

   local n := 1

   while ! Empty( __ClassName( n ) )
      ? __ClassName( n++ )
   end

return nil
