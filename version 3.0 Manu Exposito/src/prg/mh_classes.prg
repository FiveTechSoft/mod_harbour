//-----------------------------------------------------------------------------------
// Mod_Habour Plus v1.00
// Fuente: mod_harbour.c
//-----------------------------------------------------------------------------------

#include "mod_harbour.ch" 

//===================================================================================
// Clase para el manejo de templates, secciones y resultados evaluados

CLASS mh_TTemplate

    DATA aSections INIT {}
    DATA aResults INIT {}
    DATA cParams INIT ""
    DATA cOutput INIT ""

    METHOD new() CONSTRUCTOR
    METHOD addSection( cSec ) 
    METHOD getSection( n ) 
    METHOD sectionCounter() 
    METHOD addResult( cRes ) 
    METHOD getResult( n ) 
    METHOD setParams( cParams )      
    METHOD getParams() 
    METHOD getOutput()   
    METHOD setOutput( cOutput )  

    METHOD process() VIRTUAL // meter aqui la funcion mh_inlinePRG( cText, oTemplate, cParams, ... )
                             // Poner los ambitos de visibilidad
ENDCLASS

//-----------------------------------------------------------------------------------  

METHOD new() CLASS mh_TTemplate

    ::aSections := {}
    ::aResults := {}
    ::cParams := ""
    ::cOutput := ""

return self

//-----------------------------------------------------------------------------------  

PROCEDURE addSection( cSec ) CLASS mh_TTemplate 
    
    AAdd( ::aSections, cSec )

return

//-----------------------------------------------------------------------------------  

METHOD getSection( n ) CLASS mh_TTemplate  
return ::aSections[ n ]

//-----------------------------------------------------------------------------------  

METHOD sectionCounter() CLASS mh_TTemplate 
return len( ::aSections )

//-----------------------------------------------------------------------------------  

PROCEDURE addResult( cRes ) CLASS mh_TTemplate 
    
    AAdd( ::aResults, cRes )

return

//-----------------------------------------------------------------------------------  

METHOD getResult( n ) CLASS mh_TTemplate 
return ::aResults[ n ]

//-----------------------------------------------------------------------------------  

PROCEDURE setParams( cParams ) CLASS mh_TTemplate
    
    ::cParams := cParams 

return

//-----------------------------------------------------------------------------------  

METHOD getParams() CLASS mh_TTemplate 
return ::cParams 

//-----------------------------------------------------------------------------------  

METHOD getOutput() CLASS mh_TTemplate 
return ::cOutput   

//-----------------------------------------------------------------------------------  

PROCEDURE setOutput( cOutput ) CLASS mh_TTemplate 
    
    ::cOutput := cOutput 

return

//===================================================================================
// Clase para el manejo de sesiones

CLASS mh_TSession
 
    DATA Id

    METHOD new() CONSTRUCTOR
    METHOD create() CONSTRUCTOR
    METHOD getSessionId() 
    METHOD destroy() VIRTUAL 
    METHOD setData( cKey, xValue ) VIRTUAL
    METHOD getData( cKey ) VIRTUAL
    METHOD flashData( cKey, xValue ) VIRTUAL
    METHOD getFlashData( cKey, xValue ) VIRTUAL

ENDCLASS

//-----------------------------------------------------------------------------------  

METHOD new() CLASS mh_TSession
return ::create()

//-----------------------------------------------------------------------------------  

METHOD create() CLASS mh_TSession

    ::id := 0 // Crear un ID nuevo que no se pueda repetir

return self

//-----------------------------------------------------------------------------------  

METHOD getSessionId() CLASS mh_TSession 
return ::Id

//-----------------------------------------------------------------------------------  

