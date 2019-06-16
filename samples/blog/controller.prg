function Controller( cRequest )

   do case
      case cRequest == "main"
           AP_RPuts( View( "main" ) )
           
      case cRequest == "about"
           AP_RPuts( View( "about" ) ) 

   endcase

return nil

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/view.prg" ) %}
