function Main()

   TEMPLATE
      <html>
      <head>
         <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
         <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
         <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
         <link rel="stylesheet" type="text/css" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.1/themes/base/jquery-ui.css"/>   <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
      <style>
         #container {
         border: solid blue 1px;
         width: 800px;
         height: 400px;
         position: absolute;
         overflow: hidden;
         background: whitesmoke url('https://s3.amazonaws.com/com.appgrinders.test/images/grid_20.png') repeat;
         }
         #elementResizable {
            border: 1px solid #000000;
            width: 300px;
            height: 100px;
            overflow: hidden;
         }
         #nwgrip, #negrip, #swgrip, #segrip, #ngrip, #egrip, #sgrip, #wgrip {
            width: 7px;
            height: 11px;
            background-color: #000000;
            border: 1px solid #000000;
         }
         #nwgrip {
            left: -5px;
            top: -5px;
            width: 11px;
         }
         #negrip{
            top: -5px;
            right: -5px;
            width: 11px;
         }
         #swgrip{
            bottom: -5px;
            left: -5px;
            width: 11px;
         }
         #segrip{
            bottom: -5px;
            right:-5px;
            width: 11px;
         }
         #ngrip{
            top: -5px;
            left:50%;
         }
         #sgrip{
            bottom: -5px;
            left: 50%;
         }
         #wgrip{
            left:-5px;
            top:50%;
            width: 11px;
            height: 7px;
         }
         #egrip{
            right:-5px;
            top:50%;
            width: 11px;
            height: 7px;     
         }
      </style>   
      </head>
      <body>
         <h2>mod_harbour designer prototype</h2>
         <div id="container" style="top:150px;left:400px;width:1000px;height:600px;">
            <div id='elementResizable'>
               <div class="ui-resizable-handle ui-resizable-nw" id="nwgrip"></div>
               <div class="ui-resizable-handle ui-resizable-ne" id="negrip"></div>
               <div class="ui-resizable-handle ui-resizable-sw" id="swgrip"></div>
               <div class="ui-resizable-handle ui-resizable-se" id="segrip"></div>
               <div class="ui-resizable-handle ui-resizable-n" id="ngrip"></div>
               <div class="ui-resizable-handle ui-resizable-s" id="sgrip"></div>
               <div class="ui-resizable-handle ui-resizable-e" id="egrip"></div>
               <div class="ui-resizable-handle ui-resizable-w" id="wgrip"></div>
            </div>
         </div>
         <script>
               $('#elementResizable').resizable({
                  handles: {
                     'nw': '#nwgrip',
                     'ne': '#negrip',
                     'sw': '#swgrip',
                     'se': '#segrip',
                     'n': '#ngrip',
                     'e': '#egrip',
                     's': '#sgrip',
                     'w': '#wgrip'
                  }
            }).draggable( { grid: [20, 20],
               axis: "x,y",
               containment: '#container' } );
         </script>
      </body>
   ENDTEXT

return nil   