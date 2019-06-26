// {% hb_SetEnv( "HB_USER_PRGFLAGS", "-B" ) %}

function Main()

   ? hb_GetEnv( "HB_USER_PRGFLAGS" )

   AltD( 1 )   // Enables the debugger

   ? "debugger enabled"

   AltD()      // Invokes the debugger

   ? "debugger invoked"   

return nil
