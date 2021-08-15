//----------------------------------------------------------------------------//

function Main()

   if ! Empty( GetRequest() )
      USE ( HB_GetEnv( "PRGPATH" ) + '/data/' + GetRequest() ) SHARED NEW VIA 'DBFCDX'
   endif   

   ?? View( "main" )

return nil

//----------------------------------------------------------------------------//

function View( cName )

   local cData

   if File( hb_GetEnv( "PRGPATH" ) + "/views/" + cName + ".view" )
      cData = MemoRead( hb_GetEnv( "PRGPATH" ) + "/views/" + cName + ".view" )
      while ReplaceBlocks( @cData, "{{", "}}" )
      end
   else
      cData = "<h2>View " + cName + " not found!</h2>" 
   endif    

return InlinePrg( cData )

//----------------------------------------------------------------------------//

function GetRequest()

   local cArgs := AP_Args(), cRequest

   if At( "&", cArgs ) != 0
      cRequest = SubStr( cArgs, 1, At( "&", cArgs ) - 1 )
   else
      cRequest = cArgs
   endif
   
return cRequest

//----------------------------------------------------------------------------//

function GetColumns()

   local cHtml := "<thead>" + CRLF + Space( 7 ) + "<tr>" + CRLF
   local n

   cHtml += Space( 10 ) + "<th data-checkbox='true'></th>" + CRLF

   for n = 1 to FCount()
      cHtml += Space( 10 ) + "<th data-field=" + "'" + FieldName( n ) + "'" + ;
               " data-sortable='true'>" + FieldName( n ) + "</th>" + CRLF
   next  

return cHtml + Space( 7 ) + "</tr>" + CRLF + Space( 5 ) + "</thead>" + CRLF

//----------------------------------------------------------------------------//

function RecEdit()

   local cHtml := Space( 8 ) + "<div class='form-group custom-input'>" + CRLF
   local n, cValue, cRow

   for n = 1 to FCount()
      cValue = FieldGet( n )
      cRow = Space( 22 ) + "<label id='label_" + FieldName( n ) + ;
             "' class='col-2 col-form-label float: right'>" + ;
             FieldName( n ) + ":</label>" + CRLF
      cRow += Space( 22 ) + "<div class='col-10'>" + CRLF
      do case
         case FieldType( n ) == "L"
            cRow += Space( 25 ) + '<input type="checkbox" id="' + FieldName( n ) + '" ' + ;
                    If( FieldGet( n ), "checked", "" ) + ;
                    ' data-toggle="toggle"' + ;
                    ' data-on="Yes" data-off="No"' + ;
                    ' data-type="' + FieldType( n ) + '"' + ;
                    ' data-onstyle="success" data-offstyle="danger">' + CRLF

         case FieldType( n ) == "D"
            cRow += Space( 25 ) + "<input class='form-control' type='date' id='" + FieldName( n ) + ;
                    "' value='" + AllTrim( Str( Year( cValue ) ) ) + "-" + ;
                    StrZero( Month( cValue ), 2 ) + "-" + StrZero( Day( cValue ), 2 ) + "'" + ;
                    ' data-type="' + FieldType( n ) + '">' + CRLF
         
         otherwise
            cRow += Space( 25 ) + "<input class='form-control' type='text' id='" + FieldName( n ) + ;
                    "'" + ' data-type="' + FieldType( n ) + '"' + ;
                    " value='" + ValToChar( cValue ) + "'>" + CRLF
      endcase
      cRow  += Space( 22 ) + "</div>" + CRLF
      cHtml += cRow
   next

return cHtml + Space( 19 ) + "</div>" + CRLF

//----------------------------------------------------------------------------//


