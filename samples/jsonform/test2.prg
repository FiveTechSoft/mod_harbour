/*
****************************************************************************
*   Aplicacion: Diseñador de formularios para mod_harbour            		*
*       Fuente: test2.prg                             		               *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 16-08-2019                                                 *
****************************************************************************
* Introduccion al ecosistema formeo  
* https://draggable.github.io/formeo/
****************************************************************************
*/
function Main()

	TEMPLATE
	  <!DOCTYPE html>
	  <html>
	    <head>
	      <meta charset="utf-8" />
	      <meta
	        name="viewport"
	        content="user-scalable=no, width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"
	      />
	    
	      <link rel="stylesheet" type="text/css" href="https://draggable.github.io/formeo/assets/css/demo.min.css" />
			<link rel="stylesheet" style="text/css" href="jsonform/deps/opt/bootstrap.css" />

	      <title>FDW. Form Design Workshop</title>
	    </head>
	    <body>
	      <div class="site-wrap">
	        <section id="main_content" class="inner">
	          <h1>FDW. Form Design Workshop</h1>
	          <form class="build-form clearfix"></form>
	          <div class="render-form"></div>
	        </section>
	        <div class="container render-btn-wrap" id="editor-action-buttons">
	        </div>
	      </div>
	      <script src="https://draggable.github.io/formeo/assets/js/demo.min.js"></script>
	    </body>
	  </html>
	ENDTEXT

return nil