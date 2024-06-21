
{% apr_fileLoad( ap_getScriptPath() + "module_a.prg") %}
{% apr_fileLoad( ap_getScriptPath() + "module_b.prg") %}

init procedure main

	//	From module_a
	? 'Version Plug: ', PlugVersion()
	? 'Today: ', Today()
		
	//	From module_b
	? 'NextWeek: ' , DToC( NextWeek() )

return	
