//-----------------------------------------------------------------------------

#include "u:\desarrollo\comp\xc\hb\include\hbclass.ch"

//-----------------------------------------------------------------------------

procedure main

    local  o1 := TMyClass():new()

    o1:say()
    ? "Hora: ", time()
    o1:imp()

return

//-----------------------------------------------------------------------------

CLASS TMyClass

    DATA nNum
    DATA cStr
    DATA dFecha

    METHOD new() CONSTRUCTOR
    METHOD say()
    METHOD imp()
    
END CLASS

//-----------------------------------------------------------------------------

METHOD new() CLASS TMyClass

   ::nNum := 1
   ::cStr := "Prueba"
   ::dFecha := date()

return self

//-----------------------------------------------------------------------------

PROCEDURE say() CLASS TMyClass

    ? ::nNum
    ? ::cStr
    ? ::dFecha

return

//-----------------------------------------------------------------------------

PROCEDURE imp() CLASS TMyClass

    ? ::nNum, " - ", ::cStr, " - ", ::dFecha

return

//-----------------------------------------------------------------------------
