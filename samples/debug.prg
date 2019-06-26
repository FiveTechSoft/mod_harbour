// {% hb_SetEnv( "HB_USER_PRGFLAGS", "-B" ) %}

function Main()

   ? hb_GetEnv( "HB_USER_PRGFLAGS" )

   AltD( 1 )   // Enables the debugger. Press F5 to go

   ? "debugger enabled"

   AltD()      // Invokes the debugger

   ? "debugger invoked"   

return nil
