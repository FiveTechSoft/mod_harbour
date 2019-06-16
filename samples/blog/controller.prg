//----------------------------------------------------------------------------//

function Controller( cRequest )

   cContent = If( Empty( cRequest ), "home", cRequest )
   
   AP_RPuts( View( "default" ) )

return nil

//----------------------------------------------------------------------------//

function GetContent()

return If( Empty( cContent ), "content", cContent )

//----------------------------------------------------------------------------//

function BlogName()

return "My blog"

//----------------------------------------------------------------------------//

function ItemStatus( cItem )

return If( cContent == cItem, "class='active'", "" ) 

//----------------------------------------------------------------------------//

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/view.prg" ) %}
