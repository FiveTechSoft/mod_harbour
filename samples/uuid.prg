function Main()

   BLOCKS
      <script>
         var value = sessionStorage.getItem( "MyId" );
       
         if( value == null )
         {
            value = "{{generateUUID()}}"; 
            sessionStorage.setItem( "MyId", value );
         }

         document.write( value );
      </script>
   ENDTEXT

   ? "UUID generated on the server"

return nil

function GenerateUUID()

   local cChars := "0123456789ABCDEF"
   local cUUID  := ""

   for n = 1 to 8
      cUUID += SubStr( cChars, hb_Random( 1, 16 ), 1 )
   next
   
   cUUID += "-4"

   for n = 1 to 3
      cUUID += SubStr( cChars, hb_Random( 1, 16 ), 1 )
   next

   cUUID += "-"

   for n = 1 to 4
      cUUID += SubStr( cChars, hb_Random( 1, 16 ), 1 )
   next

   cUUID += "-"

   for n = 1 to 12
      cUUID += SubStr( cChars, hb_Random( 1, 16 ), 1 )
   next
 
return cUUID
