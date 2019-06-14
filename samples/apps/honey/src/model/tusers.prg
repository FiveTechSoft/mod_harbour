#include '{%hb_GetEnv("HONEY_APP")%}/include/hbclass.ch'
#include '{%hb_GetEnv("HONEY_APP")%}/include/hboo.ch'

CLASS TUsers

	DATA cFile     // INLINE 'c:/Apache24/htdocs/modharbour_samples/apps/honey/data/users.dbf'
	DATA cAlias

	METHOD  New() CONSTRUCTOR
	METHOD  Load()					

ENDCLASS

METHOD New() CLASS TUsers

        ::cFile = '{%hb_GetEnv("HONEY_APP")%}/data/users.dbf'

	USE ( ::cFile ) SHARED NEW VIA "DBFCDX"

	::cAlias 	:= Alias()

	(::cAlias)->( OrdSetFocus( 'dpt' ))	

RETU Self

METHOD Load( cDpt ) CLASS TUsers

	LOCAL aRows := {}
	LOCAL aReg  := {=>}	
	LOCAL cPath := '{%hb_GetEnv( "HONEY_REPOSITORY" )%}'
	LOCAL lFind := .T.
	
	hb_default( @cDpt, '' )
	
	if ( cDpt == 'ALL' )
		(::cAlias)->( dbGoTop() )
	ELSE
		(::cAlias)->( dbSeek( cDpt, .t. ) )
	ENDIF

	WHILE lFind 
	
		if ( cDpt == 'ALL' )
		
			lFind := (  (::cAlias)->( !Eof() )  ) 

		ELSE 

			lFind := ( (::cAlias)->dpt == cDpt .and. (::cAlias)->( !Eof() ) ) 
			
		ENDIF
		
		IF lFind

			aReg  := {=>}
			aReg[ 'id'    ] := hb_valtostr( (::cALias)->id )
			aReg[ 'name'  ] := (::cALias)->name
			aReg[ 'dpt'   ] := (::cALias)->dpt
			aReg[ 'phone' ] := hb_valtostr( (::cALias)->phone )
			aReg[ 'image' ] := alltrim(cPath + (::cALias)->image)
			
			Aadd( aRows, aReg )	

			( ::cAlias)->( DbSkip() )
		
		ENDIF

	END 
	
	

RETU aRows

//	Para testear... de no dejarse tablas abiertas

EXIT PROCEDURE CloseDb()

	DbCloseAll()
	
RETURN 

