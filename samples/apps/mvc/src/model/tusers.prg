{% MemoRead( hb_GetEnv( "PRGPATH" ) + "\include\hbclass.ch") %}
{% MemoRead( hb_GetEnv( "PRGPATH" ) + "\include\hboo.ch") %}

CLASS TUsers FROM THDO

   METHOD  New() CONSTRUCTOR			
   
   METHOD  List() 

ENDCLASS

METHOD New() CLASS TUsers

	::cTable 	:= 'users.dbf'	
	::cFocus 	:= 'id'	
	
	::AddField( 'id' )
	::AddField( 'name' )
	::AddField( 'phone' )
	::AddField( 'dpt' )

RETU Self

METHOD List() CLASS TUsers

	LOCAL aRows := {}

	::Open()

	( ::cAlias )->( DbGoTop() )

	WHILE ( ::cAlias )->( !EOF() )
		
		Aadd( aRows, ::Load() )
	
		( ::cAlias )->( DbSkip() )
	
	END	
	
RETU aRows


exit procedure CloseDb()

	DbCloseAll()
   
return 
