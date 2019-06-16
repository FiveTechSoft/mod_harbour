function Controller( cRequest )

   cContent = cRequest
   
   AP_RPuts( View( "main" ) )

return nil

function GetContent()

return If( Empty( cContent ), "content", cContent )

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/view.prg" ) %}
