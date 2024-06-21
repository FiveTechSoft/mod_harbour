// Cuando se cargan ficheros exteros hay que indicar 
// cual va a ser la funcion con la que se va a iniciar la ejecucion
// Otra solucion sería cargar los prgs al final del fuente

{% apr_fileLoad( ap_getScriptPath() + 'loadfile_a.prg' ) %}
{% apr_fileLoad( ap_getScriptPath() + 'loadfile_b.prg' ) %}
{% apr_fileLoad( ap_getScriptPath() + 'dummy.prg' ) %}

init procedure main()

	? 'test1() -> ', test1()
	? 'test2() -> ', test2()
	
return
