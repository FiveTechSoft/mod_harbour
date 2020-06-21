//-------------------------------------------------------------------------------------//

/*
   index.prg - Example - Sessions Engine for mod_harbour
   (c) 2020 Lorenzo De Linares Álvarez - lorenzo.linares@icloud.com
   Released under MIT Licence. Please use it giving credit to the author of the code.
*/

//-------------------------------------------------------------------------------------//

function Main()
   
   if GetSession() != nil
      if AP_Method() == "POST"
         if Login()
            ? "<script>location.href='info.prg';</script>"
         else
            Html()
         endif
      else
         Html()
      endif
   else
      ? "<script>location.href='info.prg';</script>"
   endif

return nil

//-------------------------------------------------------------------------------------//

function Html()
   
   TEMPLATE
   <html>
      <head>
         <title>Sessions Example</title>
      </head>
      <body>
         <h2>mod_harbour Sessions Example</h2>
         <form method="post">
            User: <input type="text" name="user"><br>
            Password: <input type="password" name="password"><br>
            <button type="submit">Login</button>
         </form>
         <p>For testing use user01 or user02 as user and password</p>
      </body>
   </html>
   ENDTEXT

return nil

//-------------------------------------------------------------------------------------//

function Login()
   
    local lReturned := .F.

   if AP_PostPairs()[ "user" ] == "user01" .and. AP_PostPairs()[ "password" ] == "user01"
      SessionStart()
      SetSessionByKey("user", "user01")
      SetSessionByKey("name", "John Appleseed")
      lReturned := .T.
   elseif AP_PostPairs()[ "user" ] == "user02" .and. AP_PostPairs()[ "password" ] == "user02"
      SessionStart()
      SetSessionByKey("user", "user02")
      SetSessionByKey("name", "Lisa Margaret")
      lReturned := .T.
   endif

return lReturned

//-------------------------------------------------------------------------------------//

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/sessions.prg" ) %}
