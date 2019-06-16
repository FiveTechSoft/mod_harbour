function Controller( cRequest )

   cContent = cRequest
   
   // AP_RPuts( View( "main" ) )

   ? GetContent()

return nil

function GetContent()

return If( Empty( cContent ), "main", cContent )

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/view.prg" ) %}
