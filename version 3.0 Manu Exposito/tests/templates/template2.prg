procedure main()

    local oTemplate, n, i

    TEMPLATE USING oTemplate
	    Raw text to be delivered to Apache...
	    <?prg return time() ?>
	    more raw text
	    <?prg return dtos( date() ) ?>
    ENDTEXT

    ? 
    ? oTemplate:ClassName()
    ? "Total secciones: ", oTemplate:sectionCounter()
    ? 
   
    i := oTemplate:sectionCounter()

    for n = 1 to i
        ? "Seccion: ", n, " : " + oTemplate:getSection( n ) 
        ? "Resultado: ", n, " : " + oTemplate:getResult( n )
        ? 
    next   
   
    ? "Parametros: " + oTemplate:getParams()
    ? "Codigo de salida: " + oTemplate:getOutput()

return
