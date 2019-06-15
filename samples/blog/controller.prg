function Controller( cRequest )

   do case
      case cRequest == "main"
           AP_RPuts( View( "main" ) )

   endcase

return nil

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/view.prg" ) %}