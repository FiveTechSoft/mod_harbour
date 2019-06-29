function Main()

   TEMPLATE
      <html lang="en">
      <head>
         <title>Panels</title>
         <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
         <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
         <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

         <style>
            .panel-resizable {
               resize: horizontal;
               overflow: auto;
               height: 300px;
               padding: 0px;
               border: 1px;
               border-color: gainsboro;
               border-style: solid;
            }

            .header {
               background-color:gainsboro;
               padding: 7px;
            }
         </style>
      </head>
      
      <body>
         <div class="container-fluid">
            <div class="row">
               <div class="col-sm-2 panel-resizable" style="background-color:lavender;">
                  <div class="header">CLASSES</div>
               </div>
               <div class="col-sm-2 panel-resizable" style="background-color:lavenderblush;">
                  <div class="header">DATAS</div>    
               </div>
               <div class="col-sm-2 panel-resizable" style="background-color:lavender;">
                  <div class="header">METHODS</div>    
               </div>
            </div>
            <div class="row">
               <div class="col-sm-6 panel-resizable" style="resize:both;background-color:lightsteelblue;height:400px;">
                  <div class="header">CODE</div>    
               </div>
            </div>
         </div>
         </body>
      </html>

   ENDTEXT

return nil
