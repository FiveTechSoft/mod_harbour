function Main()

   BLOCKS
      <html>
      <head>
         <script src="https://threejs.org/build/three.js"></script>

         <style>
            body { margin: 0; }
            canvas { width: 100%; height: 100% }
         </style>
      </head>
      <body>
         <script>
            var scene = new THREE.Scene();
            var camera = new THREE.PerspectiveCamera( 65, window.innerWidth/window.innerHeight, 0.1, 1000 );
            var renderer = new THREE.WebGLRenderer();
            var geometry = new THREE.BoxGeometry( 2, 2, 2 );
            var cube = new THREE.Mesh( geometry, new THREE.MeshNormalMaterial() );
            var animate = function () {
               requestAnimationFrame( animate );
         
               cube.rotation.x += 0.01;
               cube.rotation.y += 0.02;
         
               renderer.render( scene, camera );
            };
         
            renderer.setSize( window.innerWidth, window.innerHeight );
            document.body.appendChild( renderer.domElement );
            scene.add( cube );
            camera.position.z = 4;
            renderer.render( scene, camera );
            animate();
         </script>
      </body>
      </html>
   ENDTEXT

return nil
