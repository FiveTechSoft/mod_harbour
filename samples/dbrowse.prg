function Main()

   local cArgs := AP_Args(), nRecNo

   USE "/var/www/test/customer.dbf" SHARED
   
   if ! Empty( cArgs )
      if Left( cArgs, 5 ) == "next:"
         nRecNo = Val( SubStr( cArgs, 6 ) )
         if nRecNo < RecCount() - 10
            GOTO nRecNo
         endif   
      endif
      if Left( cArgs, 5 ) == "prev:"
         nRecNo = Val( SubStr( cArgs, 6 ) )
         if nRecNo > 20
            GOTO nRecNo - 10
         endif   
      endif
   endif   
   
   TEMPLATE
<html>   
<head>
  <title>modHarbour dbGen</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <style>
     .table-striped>tbody>tr:nth-of-type(odd) {background-color: #ecf3f7;}  
     .table-striped>tbody>tr:nth-of-type(even) {background-color: #e1ebf2;}  
     .table-striped>tbody>tr:hover>td {background-color: #f6f4d0;}  
  </style>   
</head>

<body>
<div class="container-fluid">
    <div class="container" style="margin-top:50px">

    <div class="panel panel-default" style="background-color:#f5f5f5;">
       <div style="margin:7px">
          <div class="col-xs-6">
          <div class="btn-group">
             <a class="btn btn-default" style="background-color:#0ed145;"><span>New</span></a>
             <a class="btn btn-default" style="background-color:#fff200;"><span>Edit</span></a>
             <a class="btn btn-default" style="background-color:#ec1c24;"><span>Delete</span></a>
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
                   while nRow < 11 .and. ! Eof()
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
       <div class="col-xs-3"><div class="dataTables_info" id="example_info">Showing <?prg return AllTrim( Str( RecNo() - 10 ) ) + " - " + AllTrim( Str( RecNo() - 1 ) ) ?> of <?prg return Str( RecCount() ) ?> total results</div></div>
          <div class="col-xs-6">
             <div class="dataTables_paginate paging_bootstrap">
                <ul class="pagination pagination-sm" style="margin:0 !important">
                   <li class="prev"><a href="dbrowse.prg?prev:<?prg return AllTrim( Str( RecNo() - 10 ) )?>">Previous</a></li>
                   <li class="active"><a href="#">1</a></li>
                   <li><a href="#">2</a></li>
                   <li><a href="#">3</a></li>
                   <li><a href="#">4</a></li>
                   <li class="next"><a href="dbrowse.prg?next:<?prg return AllTrim( Str( RecNo() ) )?>">Next</a></li></ul>
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
