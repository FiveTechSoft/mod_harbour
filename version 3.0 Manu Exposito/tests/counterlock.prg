//	"Ejecuta counter.prg para comprobar que la dbf esta bloqueada..."

procedure main()	

	local cDbf := ap_getScriptPath() + 'counter.dbf'
	local cAlias 

	use (cDbf) shared new 	
	
	cAlias := alias()			
	LOCATE FOR (cAlias)->id = 'order'
	
	if (cAlias)->( Found() )		
		(cAlias)->( Rlock() )
	endif		
	
	hb_idleSleep( 5 )	//	wait 
	
	(cAlias)->( DbCloseArea() )	
	
	? 'Counter unlock!'
	
return 
