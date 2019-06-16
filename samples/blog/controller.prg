function Controller( cRequest )

   cContent = cRequest
   
   AP_RPuts( View( "main" ) )

return nil

function GetContent()

return If( Empty( cContent ), "content", cContent )

function BlogName()

return "My blog"

function ItemStatus()

return If( Empty( cContent ), "class='active'", "" ) 

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/view.prg" ) %}
