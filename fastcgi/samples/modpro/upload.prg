function Main()

   local hPairs := AP_PostPairs()
   local cData, cFileName, nStart 

   if Len( hPairs ) == 0
      ? "This example is used from samples/modpro/modpro.prg"
   else
      cData = HB_HValueAt( hPairs, 1 )
      cFileName = SubStr( cData, 2, At( ";", cData ) - 3 )
      hb_MemoWrit( hb_GetEnv( "PRGPATH" ) + "/data/" + cFileName,;
                   HB_BASE64DECODE( SubStr( cData, nStart := At( "base64,", cData ) + 7,;
                   At( "------", cData ) - nStart ) ) )
      if File( hb_GetEnv( "PRGPATH" ) + "/data/" + cFileName )
         ?? BuildBrowse( hb_GetEnv( "PRGPATH" ) + "/data/" + cFileName, cFileName )
      else
         ? "File " + hb_GetEnv( "PRGPATH" ) + "/data/" + cFileName + " did not arrived"
         ? "Please check the folder modpro/data permissions"
         ? "Rmember to do: sudo chown www-data:www-data data from modpro folder"
      endif   
   endif

return nil

function BuildBrowse( cFileName, cTableName )

   local cHtml := "<h5 style='padding:5px;padding-left:20px;background-color:white;'>Browse: " + ;
                  cTableName + "</h5>" + CRLF
   local n 

   cHtml += "<table style='height:500px;width:500px;overflow:auto;'>" + CRLF + ;
            "<tr>" + '<th scope="col">#</th>' + CRLF

   USE ( cFileName ) SHARED NEW VIA "DBFFPT"

   for n = 1 to FCount() 
      cHtml += '<th scope="col">' + FieldName( n ) + '</th>' + CRLF
   next

   cHtml += '<th scope="col">ACTIONS</th>' + CRLF

   while ! Eof()
      cHtml += "<tr style='background-color:" + If( RecNo() % 2 == 0, 'white','lightgray') + "'>" + CRLF
      cHtml += '<th scope="row">' + AllTrim( Str( RecNo() ) ) + "</th>" + CRLF

      for n = 1 to FCount()
         do case
            case FieldType( n ) == "M"
               cHtml += '<td>' + If( "</" $ FieldGet( n ), "...", SubStr( FieldGet( n ), 1, 20 ) ) + CRLF
               if ! "</" $ FieldGet( n )
                  cHtml += '<button onclick="MsgInfo(' + "'" + ;
                           StrTran( FieldGet( n ), Chr( 13 ) + Chr( 10 ), "<br>" ) + "', '" + ;
                           FieldName( n ) + "');" + '"' + ;
                           ' type="button" class="btn btn-primary"' + CRLF 
                  cHtml += ' style="border-color:gray;color:gray;background-color:#f9f9f9;">' + CRLF
                  cHtml += '<i class="fas fa-eye"' + ;
                           ' style="color:gray;padding-right:15px;font-size:16px;">' + CRLF
                  cHtml += '</i></button>' + CRLF
               endif   
               if FieldName( n ) == "CODE"
                  cHtml += '<button onclick="location.href=' + "'index.prg?" + Lower( Alias() ) + ":exec:" + ;
                           AllTrim( Str( RecNo() ) ) + "';" + ;
                           '" type="button" class="btn btn-primary"' + CRLF 
                           cHtml += ' style="border-color:gray;color:gray;background-color:#f9f9f9;">' + CRLF
                           cHtml += '<i class="fas fa-flash"' + ;
                                    'style="color:gray;padding-right:15px;font-size:16px;">' + CRLF
                  cHtml += '</i></button>' +  "</td>" + CRLF
               else
                  cHtml += "</td>" + CRLF                
               endif   
                        
            case FieldType( n ) == "L"
               cHtml += '<td><input type="checkbox" onclick="return false;"' + ;
                        If( FieldGet( n ), "checked", "" ) + "></td>" + CRLF

            otherwise
               cHtml += '<td>' + ValToChar( FieldGet( n ) ) + "</td>" + CRLF  
               if FieldType( n ) == "C" .and. "." $ FieldGet( n ) 
                  // if File( hb_GetEnv( "PRGPATH" ) + FieldGet( n ) )
                     cHtml += '<td><img src="' + hb_GetEnv( "DOCUMENT_ROOT" ) + ;
                              AllTrim( FieldGet( n ) ) + ;
                              '" style="width:50px;border-radius:50%;"></td>' + CRLF
                  // endif
               endif      
         endcase   
      next

      cHtml += '<td>' + CRLF
      cHtml += '<button onclick="Edit(' + AllTrim( Str( RecNo() ) ) + ');"' + ;
               ' type="button" class="btn btn-primary"' + CRLF 
      cHtml += ' style="border-color:gray;color:gray;background-color:#f9f9f9;">' + CRLF
      cHtml += '<i class="fas fa-edit" style="color:gray;padding-right:15px;font-size:16px;">' + CRLF
      cHtml += '</i></button>' + CRLF
      cHtml += '<button onclick="Delete(' + AllTrim( Str( RecNo() ) ) + ');"' + ;
               ' type="button" class="btn btn-primary"' + CRLF 
      cHtml += ' style="border-color:gray;color:gray;background-color:#f9f9f9;">' + CRLF
      cHtml += '<i class="fas fa-trash" style="color:gray;padding-right:15px;font-size:16px;">' + CRLF
      cHtml += '</i></button>' + CRLF
      cHtml += '</td>' + CRLF

      SKIP
   end 

   cHtml += '</tbody>' + CRLF
   cHtml += '</table>' + CRLF

   USE

return cHtml   