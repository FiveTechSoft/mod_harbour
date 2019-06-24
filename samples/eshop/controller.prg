//----------------------------------------------------------------------------//

function Controller( cRequest )

   cContent = If( Empty( cRequest ), "home",;
                  If( cRequest $ "wishlist,login,cart,checkout,about,contact", cRequest, "home" ) )
   
   AP_RPuts( View( "default" ) )

return nil

//----------------------------------------------------------------------------//

function GetContent()

return cContent

//----------------------------------------------------------------------------//

function BlogName()

return "My blog"

//----------------------------------------------------------------------------//

function ItemStatus( cItem )

return If( cContent == cItem, "class='active'", "" ) 

//----------------------------------------------------------------------------//

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/view.prg" ) %}
