// This is a work in progress

function Main()

   local aCategory

   ? "<h1 align='center'>Forums categories</h1>"
   ? "<hr />"

   for each aCategory in Categories()
      ? "<h2 align='center'>" + aCategory[ 1 ] + "</h2>"
      ? "<hr />"
   next

return nil

function Categories()

   local cPathLinux := "/var/www/html/"
   local aCategories, nAt

   if File( cPathLinux + "index.html" )
      aCategories = Directory( cPathLinux + "modharbour_samples/blog/", "D" )
   else
      aCategories = Directory( "c:/Apache24/htdocs/modharbour_samples/blog/*.*", "D" )
   endif

   while ( nAt := AScan( aCategories, { | aCategory | aCategory[ 1 ] $ ".,..,layouts,images" } ) ) != 0
      ADel( aCategories, nAt )
      ASize( aCategories, Len( aCategories ) - 1 )
   end 
   
   while ( nAt := AScan( aCategories, { | aCategory | aCategory[ 5 ] != "D" } ) ) != 0
      ADel( aCategories, nAt )
      ASize( aCategories, Len( aCategories ) - 1 )
   end    

return aCategories 
