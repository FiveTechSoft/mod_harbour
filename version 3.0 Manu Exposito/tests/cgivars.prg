procedure main()

   local n, i
   local aEnv := ;
    {   "GATEWAY_INTERFACE",;
        "SERVER_ADDR",;
        "SERVER_NAME",;
        "SERVER_SOFTWARE",;
        "SERVER_PROTOCOL",;
        "REQUEST_METHOD",;
        "REQUEST_TIME",;
        "REQUEST_TIME_FLOAT",;
        "QUERY_STRING",;
        "DOCUMENT_ROOT",;
        "HTTP_ACCEPT",;
        "HTTP_ACCEPT_CHARSET",;
        "HTTP_ACCEPT_ENCODING",;
        "HTTP_ACCEPT_LANGUAGE",;
        "HTTP_CONNECTION", ;
        "HTTP_HOST",;
        "HTTP_REFERER",;
        "HTTP_USER_AGENT",;
        "HTTPS",;
        "REMOTE_ADDR",;
        "REMOTE_HOST",;
        "REMOTE_PORT",;
        "REMOTE_USER",;
        "REDIRECT_REMOTE_USER",;
        "SCRIPT_FILENAME",;
        "SERVER_ADMIN",;
        "SERVER_PORT",;
        "SERVER_SIGNATURE",;
        "PATH_TRANSLATED",;
        "SCRIPT_NAME",;
        "REQUEST_URI",;
        "PHP_AUTH_DIGEST",;
        "PHP_AUTH_USER",;
        "PHP_AUTH_PW",;
        "AUTH_TYPE",;
        "PATH_INFO",;
        "ORIG_PATH_INFO";
    }
   
   ap_setCgiVar() // Activa el entorno de variables CGI
   
   ?? '<table border=0 cellspacing=2>' + CRLF
   ?? '<tr><td><h3><b> ENVIRONMENT CONSTANTS </b></h3></td><td>' + CRLF
   ?? '</table>' + CRLF
   ?? '<table border=1 cellspacing=2>' + CRLF
   ?? '</table>' + CRLF
   ?? '<table border=1 cellspacing=2>' + CRLF

   i := Len( aEnv )
   FOR n := 1 TO i
      ?? '<tr><td><b>' + aEnv[ n ] + '</b></td><td>' + ap_getEnv( aEnv[ n ] ) + '</td></tr>' + CRLF
   NEXT
   ?? '</table>' + CRLF

return     
