static cContent

function Main()

   do case
      case Ap_Args() == "about"
           cContent = "about"
   endcase        

return nil

function GetContent()

return If( Empty( cContent ), "main", cContent )

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/controller.prg" ) %}
