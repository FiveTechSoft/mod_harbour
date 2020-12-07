function Main()

   local cHtml 

   TEXT INTO cHtml
      <html>
      <head>
         <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
      </head>
      <body>
         <video id="video" controls></video>
         <script>
            if( Hls.isSupported() )
            {
                  var video = document.getElementById('video');
                  var hls = new Hls();
                  hls.loadSource('https://rtvelivestream.akamaized.net/tdp_dvr.m3u8');
                  hls.attachMedia(video);
                  hls.on(Hls.Events.MANIFEST_PARSED,function()
                  {
                     video.play();
                  });
            }
            else if (video.canPlayType('application/vnd.apple.mpegurl'))
            {
                  video.src = 'https://rtvelivestream.akamaized.net/tdp_dvr.m3u8';
                  video.addEventListener('canplay',function()
                  {
                     video.play();
                  });
            }
         </script>
      </body>
      </html>
   ENDTEXT
   
   ?? cHtml

return nil
