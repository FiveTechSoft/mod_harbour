procedure main()	

	local cDbf := ap_getScriptPath() + 'counter.dbf'
	local nCount
	local cAlias 
	
	use (cDbf) shared new 
	
	cAlias := alias()		
	
	LOCATE FOR (cAlias)->id = 'order'
	
	if (cAlias)->( Found() )		
		if (cAlias)->( Rlock() )								
			nCount := (cAlias)->count + 1			
			(cAlias)->count := nCount												
			(cAlias)->( DbUnlock() )

			? 'Counter:', nCount
		else
			? "La DBF esta bloqueada"		
		endif		
	endif 
	
return 
