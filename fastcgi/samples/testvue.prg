/*
****************************************************************************
*   Aplicacion: Test Ajax con api fetch y programación reactiva con Vue.js *
*       Fuente: testvue.prg                                              	*
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 06-08-2019                                                 *
****************************************************************************
*/
function Main()

	TEMPLATE
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<title>Test Vue.js</title>
			<script src="https://cdn.jsdelivr.net/npm/vue"></script>
		</head>
		<body>
		<div class="container">
  			<div class="row">
  			   <div id="app">
	  			   <h1>Test Vue.js</h1>
	    			<div class="col-sm-12">
						<img width="200px" v-bind:src="remoteImageUrl" alt="">
						<div>
						  	<em>Remote image : {{ remoteImageUrl }}</em><br>
							<button v-on:click="fetchData">Cambiar</button>
						</div>
					<div>
				</div>
			</div>
		</div>
			<script>
				
				const app = new Vue({
					el: '#app',
					data() {
						return {
							remoteImageUrl:null
						}
					},
					methods: {
						
						fetchData: function(){

							fetch('https://dog.ceo/api/breeds/image/random')
								.then(response => response.json())

								.then(data => {
									console.log(data)

									if (data.status=='success')
										this.remoteImageUrl = data.message
								})
							
						}
					},
					components: {
						// no es necessari 'contacte': contacte
					},
					created: function () {
						this.fetchData()
					}
				});

			</script>
		</body>
		</html>
	ENDTEXT

return nil