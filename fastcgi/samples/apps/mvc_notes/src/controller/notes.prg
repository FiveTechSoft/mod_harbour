function Controller( o )

	LOCAL cAction := o:cAction

	DO CASE
	
		CASE cAction == 'list'	; Listado( o )		//	List() reserved word
		CASE cAction == 'new'	; Edit( o, .T. )
		CASE cAction == 'edit'	; Edit( o, .F. )
		CASE cAction == 'update'; Update( o )
		CASE cAction == 'delete'; Del( o )			//	Delete() reserved word
		
	ENDCASE								

RETU NIL

FUNCTION Listado( o )

	LOCAL oNotes	:= TNotes():New()
	LOCAL aRows	:= oNotes:List()		

	o:View( 'notes_list.view', aRows )

RETU NIL

FUNCTION Edit( o, lNew  )
	
	LOCAL oNotes	:= TNotes():New()
	LOCAL nRecno, aReg		
	
	IF lNew 	
		aReg := oNotes:Blank()
	else
		nRecno	:= o:GetValue( 'recno', 0, 'N')
		aReg 	:= oNotes:GoTo( nRecno )	
	ENDIF
		
	o:View( 'notes_edit.view', aReg )

RETU NIL


FUNCTION Update( o )

	LOCAL oNotes	:= TNotes():New()	
	LOCAL aRows, aError
	LOCAL hReg 	:= {=>}	
	LOCAL hRoles 	:= {=>}

	hReg[ 'recno' ] 	:= o:PostValue( 'recno', 0, 'N' )
	hReg[ 'title' ] 	:= o:PostValue( 'title' )
	hReg[ 'note'  ] 	:= o:PostValue( 'note' )	

	//	Validación de datos
	
		hRoles[ 'title' ] := 'required|string'
		hRoles[ 'note'  ] := 'required|string'

		IF ! o:Validate( hRoles )
			aError	:= { 'success' => .F., 'msg' => o:ErrorMessages() }
			o:View( 'notes_edit.view', hReg, aError )			
			RETU NIL
		endif
	//	-------------------------------------------					

	
	lNew := hReg[ 'recno' ] == 0	

	hMsg := oNotes:Save( hReg, lNew )

	aRows	:= oNotes:List()		
	
	o:View( 'notes_list.view', aRows, hMsg )				

RETU NIL

FUNCTION Del( o )

	LOCAL oNotes	:= TNotes():New()	
	LOCAL nRecno	
	LOCAL aRows
	LOCAL hMsg 

	nRecno 	:= o:PostValue( 'recno', 0, 'N' )
	
	hMsg 	:= oNotes:Del( nRecno )
	
	aRows	:= oNotes:List()		
	
	o:View( 'notes_list.view', aRows, hMsg )	

RETU NIL

{% include( AP_GETENV( 'PATH_APP' ) + "/src/model/tnotes.prg" ) %}
