function Main()

   BLOCKS
<!DOCTYPE html>
<html>
  <head>
    <meta charset=UTF-8 />
    <script src="https://threejs.org/build/three.js"></script>
    <script src="https://threejs.org/examples/js/controls/OrbitControls.js"></script>
    <script src="https://threejs.org/examples/js/loaders/GLTFLoader.js"></script>
    <style>
    body {
    }
    </style>
  </head>
  <body>
    <script>
    var renderer;
    var scene;
    var camera;
    
    init();
    animate();
    
    function animate() 
    {
      requestAnimationFrame ( animate );
      renderer.render(scene, camera);
    }
    
    function init() 
    {
      renderer = new THREE.WebGLRenderer();      
      renderer.setSize( window.innerWidth, window.innerHeight );      
      document.body.appendChild(renderer.domElement);      
      //Scene init
      scene = new THREE.Scene();
      scene.background = new THREE.Color( 'lightblue' );
      
      //Camera init
      camera = new THREE.PerspectiveCamera( 50, window.innerWidth / window.innerHeight, 1, 10000 );
      camera.position.set( 200, 200, 1000 );
      scene.add( camera );
      
      var geometry = new THREE.PlaneGeometry( 1000, 1000, 1, 1 );
      var material = new THREE.MeshBasicMaterial( { color: 'green' } );
      var floor = new THREE.Mesh( geometry, material );
      floor.material.side = THREE.DoubleSide;
      floor.rotation.x = 90;
      scene.add( floor ); 
        
      var loader = new THREE.GLTFLoader();

      loader.load(
          'lara.glb',
          ( gltf ) => {
              // called when the resource is loaded
              gltf.scene.scale.x = 250;
              gltf.scene.scale.y = 250;
              gltf.scene.scale.z = 250;
              scene.add( gltf.scene );
          },
          ( xhr ) => {
              // called while loading is progressing
              console.log( `${( xhr.loaded / xhr.total * 100 )}% loaded` );
          },
          ( error ) => {
              // called when loading has errors
              console.error( 'An error happened', error );
          },
      );        

      let controls = new THREE.OrbitControls(camera);
      controls.addEventListener('change', renderer);
      controls.minDistance = 500;
      controls.maxDistance = 1500;

      var light = new THREE.AmbientLight(0xffffff);
      scene.add(light);  
    } 
    </script>
  </body>
</html>
   ENDTEXT

return nil
