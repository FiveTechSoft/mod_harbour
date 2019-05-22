#xcommand TEMPLATE => #pragma __cstream | AP_RPuts( Template( %s ) )

function Main()

   USE "/var/www/test/customer.dbf"
   
   TEMPLATE
<html>   
<head>
  <title>modHarbour dbGen</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src="https://fivetechsoft.github.io/xcloud/source/js/xcloud.js"></script>
  <link rel="stylesheet" href="https://fivetechsoft.github.io/xcloud/source/css/xcloud.css"> 
  <style>
     .table-striped>tbody>tr:nth-of-type(odd) {background-color: #ecf3f7;}  
     .table-striped>tbody>tr:nth-of-type(even) {background-color: #e1ebf2;}  
     .table-striped>tbody>tr:hover>td {background-color: #f6f4d0;}  
  </style>   
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
       <table class="table table-striped table-bordered" style="margin:0px;">
          <thead>
             <tr>
               <?prg local cCols := ""
                     for n = 1 to FCount()
                        cCols += "<th>" + FieldName( n ) + "</n>"
                     next
                     return cCols ?>
             </tr>
	       </thead>
          <tbody>
             <?prg local cRow := "", nRow := 1, n
                   while nRow < 10 .and. ! Eof()
                      cRow += '<tr>' 
                      for n = 1 to FCount()
                         cRow += '<td class="center">' + ValToChar( FieldGet( n ) ) + "</td>"
                      next
                      cRow += "<td>"
                      cRow += '<button type="button" class="btn btn-xs btn-default">'
    	                cRow += '   <span class="glyphicon glyphicon-pencil"></span>'
                      cRow += "</button>"
	                   cRow += '<button type="button" data-bind="click: $parent.remove" class="remove-news btn btn-xs btn-default" data-toggle="tooltip" data-placement="top" data-original-title="Delete">'
                      cRow += '   <span class="glyphicon glyphicon-trash"></span>'
	                   cRow += "</button>"
	                   cRow += '<button type="button" class="enabledisable-news btn btn-xs btn-default">'
		                cRow += '   <span class="glyphicon glyphicon-ok"></span>'
                      cRow += "</button>"
                      cRow += "</td>"
                      cRow += "</tr>"
                      SKIP
                      nRow++
                   end   
                   return cRow ?>
          </tbody> 
       </table>
    </div>
    
    <div class="panel-footer">
       <div class="col-xs-3"><div class="dataTables_info" id="example_info">Showing 51 - 60 of 100 total results</div></div>
          <div class="col-xs-6">
             <div class="dataTables_paginate paging_bootstrap">
                <ul class="pagination pagination-sm" style="margin:0 !important"><li class="prev disabled"><a href="#">? Previous</a></li>
                   <li class="active"><a href="#">1</a></li>
                   <li><a href="#">1</a></li>
                   <li><a href="#">2</a></li>
                   <li><a href="#">3</a></li>
                   <li class="next disabled"><a href="#">Next ? </a></li></ul>
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

function Template( cText )

   local nStart, nEnd, cCode

   while ( nStart := At( "<?prg", cText ) ) != 0
      nEnd = At( "?>", SubStr( cText, nStart + 5 ) )
      cCode = SubStr( cText, nStart + 5, nEnd - 1 )
      cText = SubStr( cText, 1, nStart - 1 ) + Replace( cCode ) + SubStr( cText, nStart + nEnd + 6 )
   end 
   
return cText

function Replace( cCode )

return Execute( "function __Inline()" + HB_OsNewLine() + cCode )   
   
