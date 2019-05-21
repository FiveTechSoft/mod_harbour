#xcommand RAWTEXT => #pragma __cstream | AP_RPuts( %s )

function Main()

   RAWTEXT
<head>
  <title>xcloud</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src="https://fivetechsoft.github.io/xcloud/source/js/xcloud.js"></script>
  <link rel="stylesheet" href="https://fivetechsoft.github.io/xcloud/source/css/xcloud.css">  
</head>

<body>
<div class="container-fluid">
    <div class="container" style="margin-top:50px">

    <div class="panel panel-default">
       <div style="margin:7px">
          <div class="col-xs-6">
          <div class="btn-group">
             <a class="btn btn-default"><span>New</span></a>
             <a class="btn btn-default"><span>Edit</span></a>
             <a class="btn btn-default"><span>Delete</span></a>
          </div>
       </div>
       <div class="col-xs-6 pull-right form-group">
           <input type="text" class="form-control" style="border-radius:0px" placeholder="Search">
       </div>
    </div>
  
    <div class="panel-body" style="padding:0px">
       <table class="table table-striped table-bordered" style="margin:0px">
          <thead>
    	     <tr>
                <th>Browser</th>
                <th>Rendering engine</th>
                <th>Platform(s)</th>
                <th>Engine version</th>
                <th style="width:100px">Actions</th>
             </tr>
	  </thead>
          <tbody>
             <td class="">Internet Explorer 4.0</td>
             <td class="">Trident</td><td class="">Win 95+</td>
             <td class="center">4</td>
             <td>
                <button type="button" class="btn btn-xs btn-default">
    	           <span class="glyphicon glyphicon-pencil"></span>
	        </button>
	        <button type="button" data-bind="click: $parent.remove" class="remove-news btn btn-xs btn-default" data-toggle="tooltip" data-placement="top" data-original-title="Delete">
	           <span class="glyphicon glyphicon-trash"></span>
	        </button>
	        <button type="button" class="enabledisable-news btn btn-xs btn-default">
		   <span class="glyphicon glyphicon-ok"></span>
	        </button></td>   
	        </tr>
          </tbody> 
       </table>
    </div>
    <div class="panel-footer">
       <div class="col-xs-3"><div class="dataTables_info" id="example_info">Showing 51 - 60 of 100 total results</div></div>
          <div class="col-xs-6">
             <div class="dataTables_paginate paging_bootstrap">
                <ul class="pagination pagination-sm" style="margin:0 !important"><li class="prev disabled"><a href="#">← Previous</a></li>
                   <li class="active"><a href="#">1</a></li>
                   <li><a href="#">1</a></li>
                   <li><a href="#">2</a></li>
                   <li><a href="#">3</a></li>
                   <li class="next disabled"><a href="#">Next → </a></li></ul>
             </div>
          </div>
          <div class="btn-group">
             <button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown">
                10 <span class="caret"></span>
             </button>
             <ul class="dropdown-menu" role="menu" style="min-width: 0px ">
                <li><a href="#">5</a></li>
                <li class="active"><a href="#">10</a></li>
                <li><a href="#">15</a></li>
                <li><a href="#">15</a></li>
             </ul>
             <span>items per page </span>
          </div>
       </div>
     </div>	
   </body>
 </html> 
   ENDTEXT

return nil
