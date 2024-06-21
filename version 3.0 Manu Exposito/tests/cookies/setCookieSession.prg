procedure main()
	
    ? "<h2>Creando a cookie de sesion</h2>"

    if ap_cookieWrite( 'MyCookieSession', 'Esta cookie de sesion se ha creado a las ' + Time() + '. Estara activa una sesion completa...' )

        ? 'Se ha creado la cookie!'
        ?
        ? '<button type="button" onclick="location.href=' + "'getcookie.prg'" + '">get cookie</button>'
    else
        ? 'No se ha creado la cookie!'
    endif

 return
