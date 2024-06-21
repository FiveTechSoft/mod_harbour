procedure main()

	local cUrl := "https://filr.dipusevilla.es/ssf/a/do?p_name=ss_forum&p_action=1&action=__login&refererUrl=https://filr.dipusevilla.es/ssf/a/c/p_name/ss_forum/p_action/1/action/view_permalink/showCollection/-1/entityType/user/entryId/ss_user_id_place_holder/novl_url/1/novl_root/1#1448826503699"
	local cUrl2
	local cHtml := "Esto es una <prueba> de &HTML encode con símbolos raros: !·$%&/()=?¿*-+^*Ç"

	ap_setCgiVar() // Hay que activar las variable CGI si se va usar

	? "Varias variables Apache"
	? 'ap_getEnv( "SCRIPT_FILENAME" )', ' => ', ap_getEnv( "SCRIPT_FILENAME" )
	? 'hb_FNameDir( ap_getEnv( "SCRIPT_FILENAME" ) )', ' => ', hb_FNameDir( ap_getEnv( "SCRIPT_FILENAME" ) )
	? 'ap_getEnv( "SCRIPT_NAME" )', ' => ', ap_getEnv( "SCRIPT_NAME" )
	? 'ap_getEnv( "PATH" )', ' => ', ap_getEnv( "PATH" ) 
	? '<hr>'
	? "Varias variables del SO"
	? 'ap_getSysEnv( "PATH" )', ' => ', ap_getSysEnv( "PATH" )
	? "Envio variables del SO: mi variable -> 'correo'"
	ap_setSysEnv( "correo", "manu@gmail.com" )
	? 'ap_getSysEnv( "correo" )', ' => ', ap_getSysEnv( "Correo" )
	? 'ap_getEnv( "correo" )', ' => ', ap_getEnv( "correo" )
	? "Elimina variable del SO 'correo'"
	ap_deleteSysEnv( "Correo" )
	? 'ap_getSysEnv( "correo" )', ' => ', ap_getSysEnv( "Correo" )
	? '<hr>'
	? "ap_getUri(): ", ap_getUri()
	? "ap_getScriptPath(): ", ap_getScriptPath()
	? "ap_getFileName():   ", ap_getFileName()
	? "Original.......:    ", cUrl
	? "ap_urlEncode...:    ", cUrl2 := ap_urlEncode( cUrl )
	? "Original.......:    ", cUrl2
	? "ap_urlDecode...:    ", ap_urlDecode( cUrl2 )
	? "Original.......:    ", cHtml
	? "ap_htmlEncode...:   ", ap_htmlEncode( cHtml )
	? '<hr>'
	? "Seconds(): ", Seconds(), "  |  apr_timeNow(): ", apr_timeNow(), "  |  apr_htTime(): ", apr_htTime(), "  |   Un dia mas: ", apr_htTime( apr_timeNow() + apr_msecOneDay() )
	
return	