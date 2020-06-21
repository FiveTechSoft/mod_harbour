{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/include/hbclass.ch") %}
{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/include/hboo.ch") %}

CLASS TNotes FROM THDO

   METHOD  New() CONSTRUCTOR			
   
   METHOD  Load() 
   METHOD  List() 
   METHOD  GoTo( nRecno ) 
   METHOD  Blank()
   METHOD  Save( aReg , lNew )
   METHOD  Del( nRecno )

ENDCLASS

METHOD New() CLASS TNotes

	::cTable 	:= 'notes.dbf'	
	//::cFocus 	:= 'id'		
	
	::AddField( 'title' )
	::AddField( 'note' )
	::AddField( 'update' )

RETU Self

METHOD Load() CLASS TNotes

	LOCAL	aReg := {=>}
		
	aReg[ 'recno' ] := (::cAlias)->( Recno() ) 
	aReg[ 'title' ] := alltrim((::cAlias)->( FieldGet( FieldPos( 'title' ))))
	aReg[ 'note'  ] := alltrim((::cAlias)->( FieldGet( FieldPos( 'note' ))))
	aReg[ 'update'  ] := (::cAlias)->( FieldGet( FieldPos( 'update' )))

RETU aReg 

METHOD Blank() CLASS TNotes

	LOCAL	aReg := {=>}
		
	aReg[ 'recno' ] := 0
	aReg[ 'title' ] := ''
	aReg[ 'note'  ] := ''
	aReg[ 'update'  ] := ''

RETU aReg 

METHOD Save( hReg, lNew ) CLASS TNotes

	LOCAL lUpdate := .F.
	LOCAL hMsg 	:= {=>}
	LOCAL cTS	:= DToC( date() ) + ' ' + time()
	LOCAL nRecno	:= hReg[ 'recno' ]


	::Open()

	IF lNew 
	
		(::cAlias)->( DbAppend() )
		
		(::cAlias)->title 		:= hReg[ 'title' ]
		(::cAlias)->note  		:= hReg[ 'note'  ]
		(::cAlias)->update 		:= cTS
		
		nRecno := (::cAlias)->( Recno() )
		
		(::cAlias)->( DbUnLock() )

		lUpdate := .T.	
	
	ELSE

		(::cAlias)->( DbGoTo( nRecno ) ) 
		
		IF ( ::cAlias)->( DbRLock() )
	
			(::cAlias)->title 	:= hReg[ 'title' ]	
			(::cAlias)->note  	:= hReg[ 'note'  ]	
			(::cAlias)->update	:= cTS		
			
			(::cAlias)->( DbUnLock() )	

			lUpdate := .T.			
		
		ENDIF				

	ENDIF

	IF lUpdate 
		hMsg[ 'success' ] := .T.
		IF lNew
			hMsg[ 'msg'     ] := 'Se ha creado el registro => ' + ltrim(str( nRecno))
		ELSE
			hMsg[ 'msg'     ] := 'Registro se actualizado con exito ! => ' + ltrim(str( nRecno))
		ENDIF
	ELSE
		hMsg[ 'success' ] := .F.
		hMsg[ 'msg'     ] := 'Error actualizando registro'		
	ENDIF		

RETU hMsg

METHOD Del( nRecno ) CLASS TNotes

	LOCAL hMsg 		:= {=>}
	LOCAL lDelete 	:= .F.

	::Open()

	(::cAlias)->( DbGoTo( nRecno) ) 
	
	IF ( ::cAlias)->( DbRLock() )

		(::cAlias)->( DbDelete() )
		(::cAlias)->( DbUnLock() )	

		lDelete := .T.
	
	ENDIF				

	IF lDelete 
		hMsg[ 'success' ] := .T.
		hMsg[ 'msg'     ] := 'Registro se ha eliminado con exito !'
	ELSE
		hMsg[ 'success' ] := .F.
		hMsg[ 'msg'     ] := 'Error eliminando registro'		
	ENDIF	
	
RETU hMsg


METHOD List() CLASS TNotes

	LOCAL aRows := {}
	LOCAL aReg  := { => }

	::Open()

	( ::cAlias )->( DbGoTop() )

	WHILE ( ::cAlias )->( !EOF() )
		
		Aadd( aRows, ::Load() )
	
		( ::cAlias )->( DbSkip() )
	
	END	
	
RETU aRows

METHOD GoTo( nRecno ) CLASS TNotes

	LOCAL aReg  := { => }

	::Open()

	( ::cAlias )->( DbGoTo( nRecno ) )
	
RETU ::Load()


exit procedure CloseDb()

	DbCloseAll()
   
return 
