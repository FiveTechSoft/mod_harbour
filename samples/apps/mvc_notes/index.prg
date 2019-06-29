 /*	---------------------------------------------------------------
	Name:           MVC
	Description:    Second App with Mod Harbour (Evolution)
	                Inicio sistema MVC (Model/View/Controller)
	Autor:          Carles Aubia
	Date:           17/06/2019
	System:         HWEB (Harbour for Web)
-------------------------------------------------------------------	*/

//#define __LOG__

FUNCTION Main()

	LOCAL oRequest	
	LOCAL oRoute		

	Config()

	oRequest	:= TRequest():New()	
	oRoute		:= TRoute():New( oRequest )	
		
		oRoute:Map( 'GET'	, 'help'			, '?'							, 'help.prg' )
		oRoute:Map( 'GET'	, 'home'			, '/'							, 'home.prg' )
		oRoute:Map( 'GET'	, 'notes.list'		, 'list'						, 'list@notes.prg' )
		oRoute:Map( 'GET'	, 'notes.new'		, 'new'							, 'new@notes.prg' )
		oRoute:Map( 'GET'	, 'notes.edit'		, 'edit/(recno)'				, 'edit@notes.prg' )	
		oRoute:Map( 'POST'	, 'notes.update'	, 'update'						, 'update@notes.prg' )	
		oRoute:Map( 'POST'	, 'notes.delete'	, 'delete/(recno)'				, 'delete@notes.prg' )	

	oRoute:Listen()	//	Escucha entrada !				

RETURN NIL

FUNCTION Config()

	SET DELETED ON
	SET DATE TO ITALIAN 
	
	SetLogView()
	
	IF ( ( AP_GETENV( 'DOCUMENT_ROOT' ) + AP_GETENV( 'PATH_APP' ) ) <> HB_GETENV( 'PRGPATH' ) )
	
		? "<script>alert( '" + 'Config .htacces path...' + "' ) </script>"
		
		QUIT
		
	ENDIF
	
RETU NIL

//	Loading system MVC...
{% include( AP_GETENV( 'PATH_APP' ) + "/lib/hmvc/tmvc.prg" ) %}
