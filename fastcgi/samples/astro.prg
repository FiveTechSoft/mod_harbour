function Main()

   TEMPLATE
		<!DOCTYPE html>
		<html lang="en">
			<head>
				<meta charset="utf-8">
				<title>AstroChart</title>  
				<style>
					#paper{
						background:aquamarine;
					}
				</style>                   
			</head>
			<body>    	    
				<div id="paper"></div>
											
				<script src="https://cdn.rawgit.com/Kibo/AstroChart/master/project/build/astrochart.js"></script>
				<script type="text/javascript"> 
				
					var data = {
						"planets":{"Lilith":[18], "Chiron":[18], "Pluto":[63], "Neptune":[110, 0.2], "Uranus":[318], "Saturn":[201, -0.2], "Jupiter":[192], "Mars":[210], "Moon":[268], "Sun":[281], "Mercury":[312], "Venus":[330], "NNode":[2]},
						"cusps":[296, 350, 30, 56, 75, 94, 116, 170, 210, 236, 255, 274]			
					};
															
					window.onload = function () {            	     
						var radix = new astrology.Chart('paper', 900, 900).radix( data );
										
						// Aspect calculation
						// default is planet to planet, but it is possible add some important points:				
						radix.addPointsOfInterest( {"As":[data.cusps[0]],"Ic":[data.cusps[3]],"Ds":[data.cusps[6]],"Mc":[data.cusps[9]]});				
						radix.aspects();																								
					};
				</script>		    
			</body>
		</html>
	ENDTEXT
	
return nil	