function Main()

   local cArgs := AP_Args(), nRecNo

   USE "/var/www/test/customer.dbf" SHARED
   
   if ! Empty( cArgs )
      if Left( cArgs, 5 ) == "prev:"
         nRecNo = Val( SubStr( cArgs, 6 ) )
         if nRecNo > 1
            GOTO nRecNo - 1
         endif   
      endif
      if Left( cArgs, 5 ) == "next:"
         nRecNo = Val( SubStr( cArgs, 6 ) )
         if nRecNo < RecCount()
            GOTO nRecNo + 1
         endif   
      endif
      if Left( cArgs, 4 ) == "last"
         GOTO BOTTOM
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
                <a class="btn btn-default" style="background-color:#0ed145;"><span>Save</span></a>
                <a class="btn btn-default" style="background-color:#ec1c24;"><span>Cancel</span></a>
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
                <th>FieldName</th>
                <th>Value</th>
	       </thead>
          <tbody>
             <?prg local cRows := "", n
                   for n = 1 to FCount()
                      cRows += '<tr>'
                      cRows += '   <td class="center">' + FieldName( n ) + "</td>"
                      cRows += '   <td class="center"><input type="text" class="form-control" style="border-radius:0px"' + ;
                                   " value='" + ValToChar( FieldGet( n ) ) + "'></td>"
                      cRows += '</tr>'
                   next
                   return cRows?>
          </tbody> 
       </table>
    </div>
    
    <div class="panel-default" style="margin:20px">
       <div class="btn-group">
          <a class="btn btn-default" href="dbedit.prg?first"><span>Top</span></a>
          <a class="btn btn-default" href="dbedit.prg?prev:<?prg return AllTrim( Str( RecNo() ) )?>"><span>Prev</span></a>
          <a class="btn btn-default" href="dbedit.prg?next:<?prg return AllTrim( Str( RecNo() ) )?>"><span>Next</span></a>
          <a class="btn btn-default" href="dbedit.prg?last"><span>Bottom</span></a>
       </div>
    </div>	
  </body>
</html> 
   ENDTEXT

return nil
