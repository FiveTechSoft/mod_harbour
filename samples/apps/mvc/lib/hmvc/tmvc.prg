/*	----------------------------------------------------------------------------
	Name:			LIB HMVC - Libreria Harbour MVC (Model/View/Controller)
	Description: 	Primera libreria para poder emular sistema MVC
	Autor:			Carles Aubia
	Date: 			19/06/19	
-------------------------------------------------------------------------------- */

{% include( "/include/hbclass.ch" ) %}
{% include( "/include/hboo.ch" ) %}

{% include( "/lib/hmvc/troute.prg" ) %}			//	Sistema Router
{% include( "/lib/hmvc/trequest.prg" ) %}       //	Sistema Request
{% include( "/lib/hmvc/tcontroller.prg" ) %}	//	Sistema Controller
{% include( "/lib/hmvc/tmodel.prg" ) %}			//	Sistema Model
{% include( "/lib/hmvc/tview.prg" ) %}			//	Sistema View
{% include( "/lib/hmvc/tools.prg" ) %}			//	Soporte...

//	---------------------------------------------------------------------------- //
