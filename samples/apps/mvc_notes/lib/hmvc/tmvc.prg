/*	----------------------------------------------------------------------------
	Name:			LIB HMVC - Libreria Harbour MVC (Model/View/Controller)
	Description: 	Primera libreria para poder emular sistema MVC
	Autor:			Carles Aubia
	Date: 			19/06/19	
-------------------------------------------------------------------------------- */

{% include( AP_GETENV( 'PATH_APP' ) + "/include/hbclass.ch" ) %}
{% include( AP_GETENV( 'PATH_APP' ) + "/include/hboo.ch" ) %}

{% include( AP_GETENV( 'PATH_APP' ) + "/lib/hmvc/tools.prg" ) %}			//	Soporte...
{% include( AP_GETENV( 'PATH_APP' ) + "/lib/hmvc/troute.prg" ) %}			//	Sistema Router
{% include( AP_GETENV( 'PATH_APP' ) + "/lib/hmvc/trequest.prg" ) %}       	//	Sistema Request
{% include( AP_GETENV( 'PATH_APP' ) + "/lib/hmvc/tcontroller.prg" ) %}		//	Sistema Controller
{% include( AP_GETENV( 'PATH_APP' ) + "/lib/hmvc/tview.prg" ) %}			//	Sistema View
{% include( AP_GETENV( 'PATH_APP' ) + "/lib/hmvc/tmodel.prg" ) %}			//	Sistema Model
//	---------------------------------------------------------------------------- //
