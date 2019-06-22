function Controller( o )
	
	?? '<h2>Hi controller Dummy()</h2>'
	
	? 'Clase: ' + o:ClassName()
	? 'Accion/metodo: ' + o:cAction
	? 'Parametros: ' + ValToChar( o:hParam )

retu nil