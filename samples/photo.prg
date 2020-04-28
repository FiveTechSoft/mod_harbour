function Main()

   ?? PhotoView()   

return nil

function PhotoView()

   local cHtml

   TEXT INTO cHtml
      <!DOCTYPE html>
      <html>
        <head>
          <title>
            HTML Webcam Capture Demo
          </title>
          <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
          <style>
            #vid-show, #vid-canvas, #vid-take {
              display: block;
              margin-bottom: 20px;
              width: 500px
            }
            html, body {
              background-color: rgba(104, 171, 173, 0.52);
              padding: 0;
              margin: 0;
            }
          </style>
        </head>
        <body>
          <div id="vid-controls" style="display:block">
            <video id="vid-show" autoplay></video>
            <input id="vid-take" type="button" value="Take Photo"/>
            <div id="vid-canvas"></div>
          </div>
          <script>
          {{PhotoScript()}}
          </script>    
        </body>
      </html>
   ENDTEXT

return ReplaceBlocks( cHTML )

function PhotoScript()

   local cJS

   TEXT INTO cJS
      window.addEventListener("load", function(){
        var video = document.getElementById("vid-show"),
            canvas = document.getElementById("vid-canvas"),
            take = document.getElementById("vid-take");
      
        navigator.mediaDevices.getUserMedia({ video : true })
        .then(function(stream) {
          video.srcObject = stream;
          video.play();
      
          take.addEventListener("click", function(){
            var draw = document.createElement("canvas");
            draw.width = video.videoWidth / 1.27;
            draw.height = video.videoHeight / 1.27;
            var context2D = draw.getContext("2d");
            context2D.drawImage(video, 0, 0, video.videoWidth / 1.27, video.videoHeight / 1.27 );
            canvas.innerHTML = "";
            canvas.appendChild(draw);
            var anchor = document.createElement("a");
            anchor.href = draw.toDataURL("image/png");
            anchor.download = "webcam.png";
            anchor.innerHTML = "Click to download";
            canvas.appendChild(anchor);
          });
        })
        .catch(function(err) {
          document.getElementById("vid-controls").innerHTML = "Please enable access and attach a camera";
        });
      });
   ENDTEXT

return cJS