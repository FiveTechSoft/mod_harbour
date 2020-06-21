function Main()

   BLOCKS
<!DOCTYPE html>
<html>
  <head>
    <meta charset=UTF-8 />
    <script src="https://threejs.org/build/three.js"></script>
    <script src="https://threejs.org/examples/js/controls/OrbitControls.js"></script>
    <style>
    body {
      width: 100vw;
      height: 100vh;
      margin: 0;
      overflow: hidden;
    }
    </style>
  </head>
  <body>
    <script>
      let scene, camera, renderer,skybox;
      function init() {
        scene = new THREE.Scene();
        camera = new THREE.PerspectiveCamera(55,window.innerWidth/window.innerHeight,45,30000);
        camera.position.set(-900,-200,-900);
        renderer = new THREE.WebGLRenderer({antialias:true});
        renderer.setSize(window.innerWidth,window.innerHeight);
        document.body.appendChild(renderer.domElement);
        let controls = new THREE.OrbitControls(camera);
        controls.addEventListener('change', renderer);
        controls.minDistance = 500;
        controls.maxDistance = 1500;
        
        let materialArray = [];
        let texture_ft = new THREE.TextureLoader().load( 'castle/sandcastle_ft.jpg');
        let texture_bk = new THREE.TextureLoader().load( 'castle/sandcastle_bk.jpg');
        let texture_up = new THREE.TextureLoader().load( 'castle/sandcastle_up.jpg');
        let texture_dn = new THREE.TextureLoader().load( 'castle/sandcastle_dn.jpg');
        let texture_rt = new THREE.TextureLoader().load( 'castle/sandcastle_rt.jpg');
        let texture_lf = new THREE.TextureLoader().load( 'castle/sandcastle_lf.jpg');
          
        materialArray.push(new THREE.MeshBasicMaterial( { map: texture_ft }));
        materialArray.push(new THREE.MeshBasicMaterial( { map: texture_bk }));
        materialArray.push(new THREE.MeshBasicMaterial( { map: texture_up }));
        materialArray.push(new THREE.MeshBasicMaterial( { map: texture_dn }));
        materialArray.push(new THREE.MeshBasicMaterial( { map: texture_rt }));
        materialArray.push(new THREE.MeshBasicMaterial( { map: texture_lf }));
   
        for (let i = 0; i < 6; i++)
           materialArray[i].side = THREE.BackSide;

        let skyboxGeo = new THREE.BoxGeometry( 10000, 10000, 10000);
        skybox = new THREE.Mesh( skyboxGeo, materialArray );
        scene.add( skybox );  
        animate();
      }
      function animate() {
        renderer.render(scene,camera);
        requestAnimationFrame(animate);
        skybox.rotation.y += 0.02;
      }
      init();
    </script>
  </body>
</html>
   ENDTEXT

return nil
