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

	LOCAL oRequest	:= TRequest():New()
	LOCAL oRoute		:= TRoute():New( oRequest )
		
		oRoute:Map( 'GET'	, 'help'			, '?'							, 'help.prg' )
		oRoute:Map( 'GET'	, 'home'			, '/'							, 'default.prg' )
		oRoute:Map( 'GET'	, 'users'			, 'users'						, 'menu@users.prg' )	
		oRoute:Map( 'GET'	, 'users.info'		, 'users/(id)'					, 'info@users.prg' )	
		oRoute:Map( 'GET'	, 'users.list'		, 'users/listado'				, 'listado@users.prg' )	
		oRoute:Map( 'GET'	, 'compras.test1'	, 'compras/customer/(id)'		, 'edit@dummy.prg' )	
		oRoute:Map( 'GET'	, 'compras.test2'	, 'compras/customer/(id)/(age)'	, 'update@dummy.prg' )	
		oRoute:Map( 'GET'	, 'compras.test3'	, 'compras/customer/view/(id)'	, 'view@dummy.prg' )	
		oRoute:Map( 'GET'	, 'view'			, 'vista'						, 'vista.prg' )	
		oRoute:Map( 'GET'	, 'view.param'		, 'vista/(peticion)'			, 'controlvista.prg' )	
		oRoute:Map( 'GET'	, 'list'			, 'list'						, 'list.prg' )
		oRoute:Map( 'POST'	, 'list'			, 'list'						, 'list.prg' )	
	
	oRoute:Listen()	//	Escucha entrada !

RETURN NIL

//	Loading system MVC...
{% include( AP_GETENV( 'PATH_APP' ) + "/lib/hmvc/tmvc.prg" ) %}
