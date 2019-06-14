/*	---------------------------------------------------------------
	Name:			Honey
	Description:	First App with Mod Harbour
	Autor:			Carles Aubia
	Date:			02/06/2019
	System: 		HWEB (Harbour for Web)
-------------------------------------------------------------------	*/

/* Settings for the app
{%hb_SetEnv( "HONEY_APP", If( "Linux" $ OS(), "/var/www/html/modharbour_samples/apps/honey", "c:/Apache24/htdocs/modharbour_samples/apps/honey" ) )%}
{%hb_SetEnv( "HONEY_URL", "modharbour_samples/apps/honey" )%} 
*/

FUNCTION Main()

   View( 'splash.view' )

return nil

#include '{%hb_GetEnv("HONEY_APP")%}/lib/tbackend.prg'
