//---------------------------------------------------------------------------
// Notas by Quim Ferrer <quim_ferrer@yahoo.es>
//---------------------------------------------------------------------------
// En PHP es típico gestionar en un único script el siguiente esquema :
// * Controlador (main), podria extenderse a conexion de datos (modelo)
// * Vista Pagina de acceso (login)
// * Vista (o app), si se ha superado el login
//---------------------------------------------------------------------------

procedure main()

    local oApp := App():new()

    oApp:run()

return 

//---------------------------------------------------------------------------

CLASS App

    DATA hPost

    METHOD new() CONSTRUCTOR
    METHOD run()
    METHOD vLogin()
    METHOD view()
    METHOD isValid()

ENDCLASS

//---------------------------------------------------------------------------

METHOD new() CLASS App

    ::hPost := ap_readPost()

return self

//---------------------------------------------------------------------------

PROCEDURE run() CLASS App

    if empty( ::hPost )
        vLogin()
    else 
        if isValid()
            ::view()
        else 
            ::vLogin( .T. )
        endif
    endif

return

//---------------------------------------------------------------------------

METHOD isValid() CLASS App
return hb_hHasKey( ::hPost, "username" ) .and. ::hPost[ "username" ] == "mod"

//---------------------------------------------------------------------------

PROCEDURE vLogin( lMessage ) CLASS App
   
   __defaultNIL( @lMessage, .F. )

   TEMPLATE PARAMS lMessage
   <html>
      <head>
          <meta charset="utf-8">
          <title>POST example</title>
      </head>
      <body>
          <form action="post2.prg?lang=en" method="POST">
              User name:
              <br>
              <input type="text" name="username">
                Usuario "mod"
              <br>
              Password:
              <br>
              <input type="password" name="passw">
              <br><br>
              <input type="submit" value="Send data">
          </form>

         <?prg return If( lMessage, '<div style="color:red">Error: Usuario no válido o no registrado</div>', '' ) ?> 

      </body>
   </html>
   ENDTEXT

return 

//---------------------------------------------------------------------------

PROCEDURE view() CLASS App
    
   local cMthdType := ap_getMethod()

   if cMthdType == "POST"  
      ? "ap_readPost: ", ::hPost
   else   
      ? "No se ha enviado nada con el metodo POST"
   endif

   ? 'Method: ', cMthdType
   ? 'Body: ', ap_getBody()   
   ? 'ap_readGet: ', ap_readGet()   
   ? 'Args: ', ap_getArgs()

return

//---------------------------------------------------------------------------
