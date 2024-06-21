//---------------------------------------------------------------------------
// Notas by Quim Ferrer <quim_ferrer@yahoo.es>
//---------------------------------------------------------------------------
// En PHP es típico gestionar en un único script el siguiente esquema :
// * Controlador (main), podria extenderse a conexion de datos (modelo)
// * Vista Pagina de acceso (login)
// * Vista (o app), si se ha superado el login
//---------------------------------------------------------------------------

procedure main()

    local hPost := ap_readPost()

    if empty( hPost )
        view_login()
    else 
        if data_model( hPost )
            view_app( hPost )
        else 
            view_login( .T. )
        endif
    endif

return 

//---------------------------------------------------------------------------

static function data_model( hData )
return hb_hHasKey( hData, "username" ) .and. hData[ "username" ] == "mod"

//---------------------------------------------------------------------------

static procedure view_login( lMessage )
   
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

static procedure view_app( hPost )
    
   local cMthdType := ap_getMethod()

   if cMthdType == "POST"  
      ? "ap_readPost: ", hPost
   else   
      ? "No se ha enviado nada con el metodo POST"
   endif

   ? 'Method: ', cMthdType
   ? 'Body: ', ap_getBody()   
   ? 'ap_readGet: ', ap_readGet()   
   ? 'Args: ', ap_getArgs()

return

//---------------------------------------------------------------------------
