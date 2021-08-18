function Main()

   local cHtml

   TEXT INTO cHtml
      <video autoplay></video>
      <script>
         const constraints = {
            video: true,
         };

         const video = document.querySelector("video");

         navigator.mediaDevices.getUserMedia(constraints).then((stream) => {
            video.srcObject = stream;
         });
      </script>
  ENDTEXT
  
  ?? cHtml

return nil
