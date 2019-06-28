// {% hb_SetEnv( "HB_USER_PRGFLAGS", "-B" ) %}

function Main()

   ShowConsole()

   SetMode( 40, 120 )

   AltD()

   ? "debugger enabled"

   AltD( 1 )

   ? "debugger visible"

return nil
