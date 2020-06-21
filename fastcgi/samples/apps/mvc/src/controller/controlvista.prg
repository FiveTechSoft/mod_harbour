function Controller( o )

	LOCAL cPeticion := lower( o:hParam[ 'peticion' ] )
	
	//	En funcion del parámetro 'peticion', el controlador ejecutara y procesará una
	//	vista u otra...
	//	Parámetros permitidos: lista, pos

	
	DO CASE
	
		CASE cPeticion == 'lista'	; o:View( 'vista_lista.view' )
		CASE cPeticion == 'pos'		; o:View( 'vista_pos.view' )
		OTHERWISE
			o:View( 'vista_error.view' )
		
	ENDCASE								

RETU NIL