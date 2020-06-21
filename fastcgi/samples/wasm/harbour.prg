function Main( cCode )

  local oHrb

  if ! Empty( cCode )
     oHrb = hb_compileFromBuf( cCode, .T., "-n", "-q2" )
     hb_HrbDo( hb_HrbLoad( 1, oHrb ) )
  else
     ? "client-side mod_harbour"
  endif

return nil
