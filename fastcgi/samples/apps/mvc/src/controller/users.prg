function Controller( o )

	LOCAL cAction := o:cAction

	DO CASE
	
		CASE cAction == 'menu'		; o:View( 'users_menu.view' )
		CASE cAction == 'info'		; Info( o )
		CASE cAction == 'listado'	; Listado( o )
		
	ENDCASE								

RETU NIL

FUNCTION Info( o )

	LOCAL nId 	:= val(lower( o:hParam[ 'id' ] ))
	LOCAL oUsers	:= TUsers():New()
	LOCAL pReg	:= oUsers:Seek( nId )	
	
	o:View( 'users_info.view', pReg )

RETU NIL


FUNCTION Listado( o )

	LOCAL oUsers	:= TUsers():New()
	LOCAL aRows	:= oUsers:List()		

	o:View( 'users_list.view', aRows )

RETU NIL

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/src/model/tusers.prg") %}