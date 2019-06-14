FUNCTION Controller()
	
	LOCAL cAction 	:= TPost( 'action' )

	DO CASE
		CASE cAction == 'login'		; Login()
	ENDCASE
	
RETU NIL

FUNCTION Login()

	LOCAL cUser 		:= TPost( 'user' )
	LOCAL cPass 		:= TPost( 'pass' )
	LOCAL hRequest  	:= {=>}

	IF ( cUser == 'demo' .and. cPass == 'demo' )
		hRequest[ 'autenticate'    ] := .T.
	ELSE
		hRequest[ 'autenticate'    ] := .F.		
	ENDIF
	
	//AP_SetContentType( "application/json" )
	
	?? hb_jsonEncode( hRequest )

RETU NIL

#include '{{ap_GetEnv("HONEY_APP")}}\lib\tbackend.prg'