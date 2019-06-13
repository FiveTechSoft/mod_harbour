function Main()

   TEMPLATE
<html lang="en">
<head>
  <title>MsgGet</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src="https://fivetechsoft.github.io/xcloud/source/js/xcloud.js"></script>
  <link rel="stylesheet" href="https://fivetechsoft.github.io/xcloud/source/css/xcloud.css"> 
</head>

<style>
.table-striped>tbody>tr:nth-of-type(odd) {
    background-color: #c0c0c0;
</style>

<script>
function MsgGet( cMsg, cTitle )
{  
   var div1 = document.createElement( "div" );
   var div2 = document.createElement( "div" );
   var div3 = document.createElement( "div" );
   var div4 = document.createElement( "div" );
   var div5 = document.createElement( "div" );
   var div6 = document.createElement( "div" );
   var cAction;

   if( ! cTitle )
      cTitle = "Information";
   
   div1.className = "modal fade";
   div1.id = "msgget";

   div2.className = "modal-dialog";
   div1.appendChild( div2 );

   div3.className = "modal-content";
   div2.appendChild( div3 );
   
   div4.className = "modal-header";
   div3.appendChild( div4 );
   div4.innerHTML = "<button type='button' class='close' data-dismiss='modal'>&times;</button>" +
                    "<h4 class='modal-title'>" + cTitle + "</h4>";

   div5.className = "modal-body";
   div3.appendChild( div5 );
   div5.innerHTML = '<table class="table table-striped table-bordered" style="background-color:#c0c0c0"><tr><td>' + 
                    '<p align="right">' + cMsg + "</p></td><td><input type='text' id='get'>" + "</td></tr></table>";

   div6.className = "modal-footer";
   div3.appendChild( div6 );
   cAction = "document.getElementById('msgget').remove();";
   div6.innerHTML = "<button type='button' class='btn btn-default' data-dismiss='modal' style='width:90px'" + 
                    "onclick=" + cAction + ">Ok</button>" + 
                    "<button type='button' class='btn btn-default' data-dismiss='modal' style='width:90px'" + 
                    "onclick=" + cAction + ">Cancel</button>";

   document.body.appendChild( div1 );
   $('#msgget').modal('show');  
   $('#get').focus();
}
</script>

<body><div class="container-fluid">
<script>MsgGet( "username:", "Please identify" );</script>
</div>
</body>

ENDTEXT

return nil
