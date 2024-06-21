

procedure error5()
	
	? 'Hello'
	
	error4()
	
return

//#include ap_getScriptPath() + 'error4.prg'
{% apr_fileLoad( ap_getScriptPath() + 'error4.prg' ) %}