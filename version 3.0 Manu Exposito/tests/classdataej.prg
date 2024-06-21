//-----------------------------------------------------------------------------

#include "u:\desarrollo\comp\xc\hb\include\hbclass.ch"

//-----------------------------------------------------------------------------

procedure main

    local o1, o2, o3, o4 

    ? "Viendo las classdatas:"
    ? "-----------------------------"
    o1 := TMyClass():new()
    ? "En o1: ", o1:theClsData  
    o2 := TMyClass():new()
    ? "En o2: ", o2:theClsData  
    o3 := TMyClass():new()
    ? "En o3: ", o3:theClsData  
    o4 := TMyClass():new()
    ? "En o4: ", o4:theClsData  
    ?"------------------------------"
    ? "En o1: ", o1:theClsData  
    ? "En o2: ", o2:theClsData  
    ? "En o3: ", o3:theClsData  
    ? "En o4: ", o4:theClsData  
    ?"------------------------------"
    ? Time()

return

//-----------------------------------------------------------------------------

CLASS TMyClass

    CLASSDATA theClsData INIT 0

    METHOD new() CONSTRUCTOR

END CLASS

//-----------------------------------------------------------------------------

METHOD new() CLASS TMyClass

    ::theClsData++

return self

//-----------------------------------------------------------------------------
