function Main()

   local aEnv := ;
    { 'AUTH_TYPE';
    , 'CONTENT_LENGTH';
    , 'CONTENT_TYPE';
    , 'GATEWAY_INTERFACE';
    , 'PATH_INFO';
    , 'PATH_TRANSLATED';
    , 'QUERY_STRING';
    , 'REMOTE_ADDR';
    , 'REMOTE_HOST';
    , 'REMOTE_IDENT';
    , 'REMOTE_USER';
    , 'REQUEST_METHOD';
    , 'SCRIPT_NAME';
    , 'SERVER_NAME';
    , 'SERVER_PORT';
    , 'SERVER_PROTOCOL';
    , 'SERVER_SOFTWARE';
    }, n

    FOR n := 1 TO Len( aEnv )
      ? aEnv[ n ] 
      ? hb_GetEnv( aEnv[ n ] ) 
    NEXT
    
return nil    
