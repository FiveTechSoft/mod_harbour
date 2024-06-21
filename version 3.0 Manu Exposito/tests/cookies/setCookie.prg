procedure main()
	
    ? "<h2>Creating a cookie</h2>"

    if ap_cookieWrite( 'MyCookieName', 'Esta cookie se ha creado a las ' + Time() + ;
               '. Estara activa 60 segundos...', 60 )

        ? 'Se ha creado la cookie!'
        ?
        ? '<button type="button" onclick="location.href=' + "'getcookie.prg'" + '">get cookie</button>'
    else
        ? 'No se ha creado la cookie!'
    endif

 return
