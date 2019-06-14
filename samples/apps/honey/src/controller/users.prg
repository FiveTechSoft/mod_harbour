function Controller()
	
	LOCAL cAction 	:= TGet( 'action' )

	DO CASE
		CASE cAction == 'load' ; Load()		
		OTHERWISE
			Default()
	ENDCASE
	
RETU NIL

FUNCTION Load()

	LOCAL cDpt 	:= TGet( 'dpt' )
	LOCAL oUsers 	:= TUsers():New()

	//	Carga Datos 
	
		aData := oUsers:Load( cDpt )
		
	//	Pintar datos

		View( 'users_data.view', aData )

RETU NIL

FUNCTION Default()

	//	Pintar...
	
		View( 'users.view' )

RETU NIL

{% MemoRead( hb_GetEnv("HONEY_APP") + "/lib/tbackend.prg") %}
{% MemoRead( hb_GetEnv("HONEY_APP") + "/src/model/tusers.prg") %}
