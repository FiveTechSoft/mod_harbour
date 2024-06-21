procedure main()

    local oTemplate, n, i, x := " first ", y := " second ", z := " third " 
   
    TEMPLATE USING oTemplate PARAMS x, y, z   
        Texto sin procesar para entregar a Apache...
        <?prg return x ?>   
        ...mas texto sin procesar
        <?prg return DToC( Date() ) + y + z ?>
    ENDTEXT

    ? 
    ? oTemplate:ClassName()
    ? "Total secciones: ", oTemplate:sectionCounter()
    ? 
   
    i := oTemplate:sectionCounter()

    for n := 1 to i
        ? "Seccion: ", n, " : " + oTemplate:getSection( n ) 
        ? "Resultado: ", n, " : " + oTemplate:getResult( n )
        ? 
    next   
   
    ? "Parametros: " + oTemplate:getParams()
    ? "Codigo de salida: " + oTemplate:getOutput()
   
return 
