function Main()

   do case
      case Ap_Args() == "about"
           Controller( "about" )
           
      otherwise     
           Controller( "main" )
   endcase        

return nil

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/controller.prg" ) %}
