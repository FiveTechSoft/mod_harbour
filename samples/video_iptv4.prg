function Main()

   local cHtml 

   TEXT INTO cHtml
      <html>
      <head>
         <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
         <style>
         .myvideo {
            float: left;
            width: 50%;
            height: 50%;
         }
         </style>
      </head>
      <body>
         <video id="video1" class="myvideo" controls autoplay></video>
         <video id="video2" class="myvideo" controls autoplay></video>
         <video id="video3" class="myvideo" controls autoplay></video>
         <video id="video4" class="myvideo" controls autoplay></video>
         <script>
            var sources = [ 'https://rtvelivestream.akamaized.net/tdp_dvr.m3u8',
                            'http://rtvev4-live.hss.adaptive.level3.net/egress/ahandler/rtvegl0/irtve03_lv3_aosv4_gl0/irtve03_lv3_aosv4_gl0.isml/master.m3u8',
                            'https://rmtv24hweblive-lh.akamaihd.net/i/rmtv24hwebes_1@300661/master.m3u8',
                            'https://canadaremar2.todostreaming.es/live/peque-pequetv.m3u8' ];
   
            for( i = 1; i <= sources.length; i++ )
            {   
               var video = document.getElementById( 'video' + i );
               var hls = new Hls();
               hls.loadSource( sources[ i - 1 ] );
               hls.attachMedia( video );
               hls.on( Hls.Events.MANIFEST_PARSED, function()
               {
                  video.play();
               } );
            }
         </script>
      </body>
      </html>
   ENDTEXT
   
   ?? cHtml

return nil
