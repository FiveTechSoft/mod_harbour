// This example shows how to send javascript values (objects) 
// from javascript (low level) to a Harbour hash (high level)

//----------------------------------------------------------------//

function Main()

   local hPostPairs

   if AP_Method() == "POST"
      ? "<h2>We have converted a javascript object into a Harbour hash</h2>"
      hPostPairs = AP_PostPairs()
      hPostPairs[ "params" ] = hb_UrlDecode( hPostPairs[ "params" ] )
      ? hb_jsonDecode( hPostPairs[ "params" ] ) // Here we get a Harbour hash
      ? "<h3>This way you can send javascript objects (from the client side) to Harbour hashes (on the server side)</h3>"
   else   
      ?? Html()
   endif   

return nil

//----------------------------------------------------------------//

function Html()

   local cHtml

   TEXT INTO cHtml
      <html>
         <head>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
         </head>
         <body>
            <h2>Javacript object (json from low level) to Harbour hash (at high level) demo</h2>
            <button onclick='demo()'>Click to proceed</button> 
            {{JavaScript()}}
         </body>
      </html>
   ENDTEXT
   
return ReplaceBlocks( cHtml )

//----------------------------------------------------------------//

function JavaScript()

   local cScript

   TEXT INTO cScript
      <script>
         function demo() {
            var object = { one: "first", two: "second", three: "third" };

            jsonToPrg( "js_to_prg.prg", object );
         }    

         function jsonToPrg( cUrl, hJson ) {
            var $form = $("<form />");
            $form.attr( "action", cUrl );
            $form.attr( "method", "POST" );
            $form.append( '<textarea style="display:none" name="params">' + JSON.stringify( hJson ) + '</textarea>' );
            $("body").append( $form );
            $form.submit();
         }       
      </script>
   ENDTEXT         
   
return cScript   

//----------------------------------------------------------------//
