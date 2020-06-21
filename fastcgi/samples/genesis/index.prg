static cContent, cAction, cParam1 := "", cParam2 := "", nVal1 := 0, nVal2 := 0
static cUserName, cCode

//----------------------------------------------------------------------------//

function Main()

   SET CENTURY ON

   CheckUser()
   CheckDataBase()

   Controller( mh_Query() )

   AddLog()

return nil

//----------------------------------------------------------------------------//

function CheckUser()

   local hCookies := GetCookies()

   if hb_HHasKey( hCookies, "genesis" ) .and. ! Empty( hCookies[ "genesis" ] )
      cUserName = hCookies[ "genesis" ]
   else
      cUserName = "guest"   
   endif

   if cUserName != "guest" 
      if ! File( hb_vfDirExists( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName ) )
         hb_vfDirMake( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName )
         hb_vfDirMake( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data" )
         hb_vfDirMake( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/images" )
         hb_vfDirMake( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/default.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/default.view" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/head.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/head.view" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/body.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/body.view" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/browse.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/browse.view" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/edit.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/edit.view" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/menu.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/menu.view" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/home.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/home.view" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/login.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/login.view" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/exec.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/exec.view" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/code.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/code.view" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/sendfile.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/sendfile.view" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/form.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/form.view" )
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/designer.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/designer.view" )
      endif
   endif

return nil   

//----------------------------------------------------------------------------//

function Controller( cRequest )

   local aRequest

   if ":" $ cRequest
      aRequest = hb_aTokens( cRequest, ":" )
      cRequest = aRequest[ 1 ]
      cAction  = If( Len( aRequest ) > 1, aRequest[ 2 ], "browse" )
      cParam1  = If( Len( aRequest ) > 2, aRequest[ 3 ], "" )
      cParam2  = If( Len( aRequest ) > 3, aRequest[ 4 ], "" )
      nVal1    = Val( cParam1 )
      nVal2    = Val( cParam2 )
   endif    

   if cRequest == "logout"
      mh_Header( "Set-Cookie: genesis=" )
      cRequest = "login"
      cUserName = "guest"
   else   
      if ! hb_HhasKey( GetCookies(), "genesis" )
         cRequest = "login"
      else
         if cUserName != "guest"
            if cRequest == "login"
               cRequest = "home"
            endif 
         else
            cRequest = "login"
         endif
      endif              
   endif      

   hb_default( @cAction, "browse" )

   if cAction $ "add,browse" 
      if nVal1 == 0
         nVal1 = 20
      endif  
   endif   

   cContent = If( Empty( cRequest ), "home",;
       If( cRequest $ "login,logout,home,controllers,logs,menus,routes,database,users,settings,tasks,views",;
           cRequest, "home" ) )

   do case   
      case mh_Method() == "GET"
         mh_Echo( View( "default" ) )

      case mh_Method() == "POST"
         do case
            case cAction == "save"
                 Save()

            case cRequest == "login"
                 Login() 
         endcase 
   endcase   

return nil

//----------------------------------------------------------------------------//

function Router()

   local cRoute := "home"

   if GetContent() != "home"
      if GetContent() == "login"
         cRoute = "login"
      else         
         if GetAction() == "edit"
            cRoute = "edit"
         elseif GetAction() == "exec"
            cRoute = "exec"
         else      
            cRoute = "browse"
         endif
      endif   
   endif      

return View( cRoute )    

//----------------------------------------------------------------------------//

function CheckDataBase()

   if ! File( hb_GetEnv( "PRGPATH" ) + "/data/users.dbf" ) .or. ; // for ALL users of Genesis
      ! File( hb_GetEnv( "PRGPATH" ) + "/data/users.dbt" )
      DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/users.dbf",;
                { { "DATE",    "D",  8, 0 },;
                  { "FIRST",   "C", 20, 0 },;
                  { "LAST",    "C", 20, 0 },;
                  { "ACTIVE",  "L",  1, 0 },;
                  { "EMAIL",   "C", 30, 0 },;
                  { "PHONE",   "C", 20, 0 },;
                  { "PASSMD5", "C", 32, 0 },;
                  { "NOTES",   "M", 10, 0 } } )
   endif

   if ! File( hb_GetEnv( "PRGPATH" ) + "/data/logs.dbf" )  // for ALL users
      DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/logs.dbf",;
                { { "DATE",    "D",  8, 0 },;
                  { "TIME",    "C",  8, 0 },;
                  { "USERIP",  "C", 20, 0 },;
                  { "METHOD",  "C", 10, 0 },;
                  { "CONTENT", "C", 15, 0 },;
                  { "ACTION",  "C", 10, 0 },;
                  { "PARAM1",  "N",  8, 0 },;
                  { "PARAM2",  "N",  8, 0 } } )
   endif   

   if cUserName != "guest"
      if ! File( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/database.dbf" )
         DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/database.dbf",;
                   { { "TABLE",       "C", 20, 0 },;
                     { "DESCRIPTIO",  "C", 30, 0 },;
                     { "FIELDS",      "M", 10, 0 },;
                     { "INDEXES",     "M", 10, 0 },;
                     { "ONNEW",       "M", 10, 0 },;      
                     { "ONPOSTEDIT",  "M", 10, 0 } } )
      endif               
        
      if ! File( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/logs.dbf" )
         DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/logs.dbf",;
                  { { "DATE",    "D",  8, 0 },;
                     { "TIME",    "C",  8, 0 },;
                     { "USERIP",  "C", 20, 0 },;
                     { "METHOD",  "C", 10, 0 },;
                     { "CONTENT", "C", 15, 0 },;
                     { "ACTION",  "C", 10, 0 },;
                     { "PARAM1",  "N",  8, 0 },;
                     { "PARAM2",  "N",  8, 0 } } )
      endif

      if ! File( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/menus.dbf" )
         DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/menus.dbf",;
                  { { "GLYPH",   "C", 20, 0 },;
                     { "PROMPT",  "C", 20, 0 },;
                     { "ACTION",  "C", 30, 0 } } )
      endif

      if ! File( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/tasks.dbf" )
         DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/tasks.dbf",;
                  { { "NAME",       "C", 20, 0 },;
                     { "DESCRIPTIO", "C", 40, 0 },;
                     { "CODE",       "M", 10, 0 } } )
      endif

      if ! File( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/users.dbf" )
         DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/users.dbf",;
                  { { "DATE",    "D",  8, 0 },;
                     { "FIRST",   "C", 20, 0 },;
                     { "LAST",    "C", 20, 0 },;
                     { "ACTIVE",  "L",  1, 0 },;
                     { "EMAIL",   "C", 30, 0 },;
                     { "PHONE",   "C", 20, 0 },;
                     { "PASSMD5", "C", 32, 0 },;
                     { "NOTES",   "M", 10, 0 } } )
      endif

      if ! File( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/views.dbf" )
         DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/views.dbf",;
                  { { "NAME",       "C", 20, 0, 0 },;
                     { "DESCRIPTIO", "C", 40, 0, 0 },;
                     { "FILE",       "C", 50, 0, 0 },;
                     { "CODE",       "M", 10, 0, 0 } } )
      endif

      if ! File( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/settings.dbf" )
         DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/settings.dbf",;
                  { { "USERID",     "C", 20, 0, 0 },;
                     { "THEME",      "C", 40, 0, 0 },;
                     { "PERMITS",    "M", 150, 0, 0 } } )
      endif
   endif
      
return nil   

//----------------------------------------------------------------------------//

function AddLog()

   if GetContent() != "logs" 
      OpenTable( "logs" )
      APPEND BLANK

      if RLock()
         field->date    := Date()
         field->time    := Time()
         field->userip  := mh_UserIP()
         field->method  := mh_Method()
         field->content := If( ! Empty( GetContent() ), GetContent(), "" )
         field->action  := If( ! Empty( GetAction() ), GetAction(), "" )
         field->param1  := If( ! Empty( GetVal1() ), GetVal1(), 0 )
         field->param2  := If( ! Empty( GetVal2() ), GetVal2(), 0 )
         DbUnLock()
      endif

      USE
   endif   
   
return nil   

//----------------------------------------------------------------------------//

function Login()

   local hPairs := mh_PostPairs()
    
   do case
      case hb_HHasKey( hPairs, "forgot" )
         mh_Echo( View( "default" ) )
         if ! Empty( hPairs[ "username" ] ) 
            mh_Echo( "<script>MsgInfo( 'An email has been sent to you to reset your password' )</script>" )
         else   
            mh_Echo( "<script>MsgInfo( 'Please write your email or phone number' )</script>" )
         endif 
         
      case hb_HHasKey( hPairs, "continue" )     
           if Identify( hPairs[ "username" ], hPairs[ "password" ] )
              cContent = "home"
              mh_Header( "Set-Cookie: genesis=" + cUserName )
              mh_Echo( View( "default" ) )
           else
              mh_Echo( View( "default" ) )
              mh_Echo( "<script>MsgInfo( 'wrong username or password', 'Please try it again' )</script>" )
           endif 
           
      case hb_HHasKey( hPairs, "ok" )
           AddUser( hPairs )
           mh_Echo( View( "default" ) )
           mh_Echo( "<script>MsgInfo( 'Please identify and press continue' )</script>" )
   endcase 

return nil

//----------------------------------------------------------------------------//

function AddUser( hPairs )

   OpenTable( "users" )
   APPEND BLANK

   if RLock()
      field->date    := Date()
      field->first   := hb_HGet( hPairs, "first" )
      field->last    := hb_HGet( hPairs, "last" )
      field->email   := hb_UrlDecode( hb_HGet( hPairs, "email" ) )
      field->phone   := hb_HGet( hPairs, "phone" )
      field->passmd5 := hb_Md5( hb_HGet( hPairs, "password" ) )
      DbUnLock()
   endif   
   USE
   
return nil   

//----------------------------------------------------------------------------//

function Identify( _cUserName, _cPassword )

   local lFound

   OpenTable( "users" )

   LOCATE FOR ( field->email = hb_UrlDecode( _cUserName ) .or. field->phone = _cUserName ) .and. ;
                field->passmd5 = hb_Md5( _cPassword )
   
   lFound = Found()
   
   if lFound
      cUserName = AllTrim( field->first )
   else
      cUserName = "guest"   
   endif   

   USE

return lFound

//----------------------------------------------------------------------------//

function GetContent()

return cContent

//----------------------------------------------------------------------------//

function GetAction()

return cAction   

//----------------------------------------------------------------------------//

function GetParam1()

return cParam1   

//----------------------------------------------------------------------------//

function GetParam2()

return cParam2   

//----------------------------------------------------------------------------//

function GetVal1()

return nVal1   

//----------------------------------------------------------------------------//

function GetVal2()

return nVal2   

//----------------------------------------------------------------------------//

function GetUserName()

return cUserName

//----------------------------------------------------------------------------//

function GetCode()

return cCode   

//----------------------------------------------------------------------------//

function ItemStatus( cItem )

return If( cContent == cItem, "class='active'", "" ) 

//----------------------------------------------------------------------------//

function GetColor1() ; return "mediumblue"
function GetColor2() ; return "darkblue"
function GetColor3() ; return "rgb(34, 45, 50)"

//----------------------------------------------------------------------------//

function View( cView )

   local cViewName, lFound, cData 

   if cUserName == "guest"
      cViewName = hb_GetEnv( "PRGPATH" ) + "/views/" + cView + ".view"
   else   
      cViewName = hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/" + cView + ".view"
   endif

   lFound = File( cViewName )

   if ! lFound
      OpenTable( "views" )
      LOCATE FOR AllTrim( field->name ) = AllTrim( cView )
       if lFound := Found()
         cData = field->code
      endif
      USE
   endif      

   if lFound
      if Empty( cData )
         cData = MemoRead( cViewName )
      endif   
    
      while ReplaceBlocks( @cData, "{{", "}}" )
      end
   else
      cData = "<h2>" + cViewName + " not found!</h2>" 
   endif    

return cData

//----------------------------------------------------------------------------//

function BuildBrowse( cTableName )

   local cHtml := "", n, nRow := 0

   OpenTable( cTableName ) 

   if ! Empty( GetAction() ) .and. GetAction() == "add"
      APPEND BLANK
      GO TOP
   endif   

   if ! Empty( GetAction() ) .and. GetAction() == "del"
      USE
      if cUserName == "guest"
         USE ( hb_GetEnv( "PRGPATH" ) + "/data/" + cTableName ) NEW
      else
         USE ( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/" + cTableName ) NEW
      endif

      DbGoTo( GetVal1() )
      DELETE 
      PACK
      USE
      OpenTable( cTableName )
      GO TOP
   endif

   if ! Empty( GetAction() ) .and. GetAction() == "search"
      SET FILTER TO Upper( GetParam1() ) $ Upper( DBRECORDINFO( 7 ) )
      GO TOP
      nVal1 = 20
   endif   

   if GetVal2() != 0
      DbSkip( GetVal2() )
   endif   

   cHtml += '<table id="browse" class="table table-striped table-hover;"">' + CRLF
   cHtml += '<thead>' + CRLF
   cHtml += '<tr>' + CRLF
   cHtml += '<th scope="col">#</th>' + CRLF

   for n = 1 to FCount() 
      cHtml += '<th scope="col">' + FieldName( n ) + '</th>' + CRLF
   next

   cHtml += '<th scope="col">ACTIONS</th>' + CRLF

   cHtml += '</tr>' + CRLF
   cHtml += '</thead>' + CRLF
   cHtml += '<tbody>' + CRLF

   while ! Eof() .and. nRow < GetVal1()
      cHtml += "<tr>" + CRLF
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
                  cHtml += '</i>View</button>' + CRLF
               endif   
               if FieldName( n ) == "CODE"
                  cHtml += '<button onclick="location.href=' + "'index.prg?" + Lower( Alias() ) + ":exec:" + ;
                           AllTrim( Str( RecNo() ) ) + "';" + ;
                           '" type="button" class="btn btn-primary"' + CRLF 
                           cHtml += ' style="border-color:gray;color:gray;background-color:#f9f9f9;">' + CRLF
                           cHtml += '<i class="fas fa-flash"' + ;
                                    'style="color:gray;padding-right:15px;font-size:16px;">' + CRLF
                  cHtml += '</i>Exec</button>' +  "</td>" + CRLF
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
      cHtml += '</i>Edit</button>' + CRLF
      cHtml += '<button onclick="Delete(' + AllTrim( Str( RecNo() ) ) + ');"' + ;
               ' type="button" class="btn btn-primary"' + CRLF 
      cHtml += ' style="border-color:gray;color:gray;background-color:#f9f9f9;">' + CRLF
      cHtml += '<i class="fas fa-trash" style="color:gray;padding-right:15px;font-size:16px;">' + CRLF
      cHtml += '</i>Delete</button>' + CRLF
      cHtml += '</td>' + CRLF

      SKIP
      nRow++
   end 

   cHtml += '</tbody>' + CRLF
   cHtml += '</table>' + CRLF

   cHtml += "<hr>" + CRLF
   cHtml += '<div class="row" style="padding-left:15px">' + CRLF
   cHtml += '<div class="col-sm-3">' + CRLF
   cHtml += "Showing records " + AllTrim( Str( Max( GetVal2() + 1, 1 ) ) ) + " - " + ;
            AllTrim( Str( RecNo() - 1 ) ) + " / Total: " + AllTrim( Str( RecCount() ) ) + "</div>" + CRLF
   cHtml += '<div class="col-sm-1"></div>' + CRLF         

   if RecCount() > nRow 
      cHtml += '<div class="col-sm-3 btn-group" style="height:50px;">' + CRLF
      cHtml += '   <button onclick="' + "location.href='index.prg?" + GetContent() + ":browse:' + GetRowsPerPage() + ':" + ;
               AllTrim( Str( 0 ) ) + "'" + '" type="button" class="btn btn-primary" style="background-color:{{GetColor1()}};">' + ;
               '<i class="fas fa-angle-double-left" style="color:white;padding-right:15px;font-size:18px;"></i>First</button>' + CRLF
      cHtml += '   <button onclick="' + "location.href='index.prg?" + GetContent() + ":browse:' + GetRowsPerPage() + ':" + ;
               AllTrim( Str( RecNo() - 41 ) ) + "'" + '" type="button" class="btn btn-primary" style="background-color:{{GetColor2()}};">' + ;
               '<i class="fas fa-angle-left" style="color:white;padding-right:15px;font-size:18px;"></i>Prev</button>' + CRLF
      cHtml += '   <button onclick="' + "location.href='index.prg?" + GetContent() + ":browse:' + GetRowsPerPage() + ':" + ;
               AllTrim( Str( RecNo() - 1 ) ) + "'" + '" type="button" class="btn btn-primary" style="background-color:{{GetColor2()}};">Next' + ;
               '<i class="fas fa-angle-right" style="color:white;padding-left:15px;font-size:18px;"></i></button>' + CRLF
      cHtml += '   <button onclick="' + "location.href='index.prg?" + GetContent() + ":browse:' + GetRowsPerPage() + ':" + ;
               AllTrim( Str( RecCount() - 20 ) ) + "'" + '" type="button" class="btn btn-primary" style="background-color:{{GetColor1()}};">Last' + ;
               '<i class="fas fa-angle-double-right" style="color:white;padding-left:15px;font-size:18px;"></i></button>' + CRLF
      cHtml += '</div>' + CRLF
   endif              

   cHtml += "</div>" + CRLF + "</div>" + CRLF + "</div>" + CRLF 

   USE

return cHtml   

//----------------------------------------------------------------------------//

function BuildEdit( cTableName )

   local cHtml := "", n

   OpenTable( cTableName )
   DbGoTo( GetVal1() )

   cHtml += '<form action="index.prg?' + GetContent() + ":save:" + AllTrim( Str( GetVal1() ) ) + '" ' + ;
            'method="post">' + CRLF
   cHtml += '<table id="browse" class="table table-striped table-hover;">' + CRLF
   cHtml += '<thead>' + CRLF
   cHtml += '</thead>' + CRLF
 
   for n = 1 to FCount()
      cHtml += '<tr>'
      cHtml += '   <td class="text-right" style="padding-top:22px;">' + FieldName( n ) + "</td>"
      cHtml += '   <td class="center">'
      do case
         case FieldType( n ) == "M"
              cHtml += '<textarea class="form-control" rows="5" name="' + ;
              FieldName( n ) + '">' + FieldGet( n ) + '</textarea>' + CRLF

         case FieldType( n ) == "L"     
              cHtml += '<input type="checkbox" name="' + FieldName( n ) + ;
              '" class="form-control" style="border-radius:0px;" ' + ;
              If( FieldGet( n ), "checked", "" ) + "></td>"

         case FieldType( n ) == "D"
            cHtml += '<input id=datepicker' + AllTrim( Str( n ) ) + ;
            ' type="text" autocomplete="off" name="' + FieldName( n ) + ;
            '" class="form-control" style="border-radius:0px;width:100px;"' + ;
            " value=" + DtoC( FieldGet( n ) ) + '></td>' + CRLF + ;
            "<script>$('#datepicker" + AllTrim( Str( n ) ) + ;
            "').datepicker({uiLibrary: 'bootstrap4'});</script>"

         otherwise   
              cHtml += '<input type="text" name="' + FieldName( n ) + ;
              '" class="form-control" style="border-radius:0px"' + ;
              " value='" + ValToChar( FieldGet( n ) ) + "'></td>"
      endcase            
      cHtml += '</tr>'
   next

   cHtml += '</table>' + CRLF

   USE

return cHtml

//----------------------------------------------------------------------------//

function Save()

   local hPost := mh_PostPairs(), n

   if GetContent() != "database" 
      OpenTable( "database" )
   endif

   OpenTable( GetContent() )
   DbGoTo( nVal1 )
   
   if RLock()
      for n = 1 to FCount()
         if hb_HHasKey( hPost, FieldName( n ) )
            do case
               case FieldType( n ) == "D"
                    FieldPut( n, CToD( hb_UrlDecode( hb_HGet( hPost, FieldName( n ) ) ) ) )

               case FieldType( n ) == "L"
                    FieldPut( n, "on" $ hb_UrlDecode( hb_HGet( hPost, FieldName( n ) ) ) )     
            
               otherwise   
                    FieldPut( n, hb_UrlDecode( hb_HGet( hPost, FieldName( n ) ) ) )
            endcase   
         else
            if FieldType( n ) == "L"
               FieldPut( n, .F. )
            endif      
         endif 
      next 

      if GetContent() != "database"
         SELECT "database"
         LOCATE FOR RTrim( database->table ) == GetContent()
         if Found() .and. ! Empty( database->OnPostEdit )
            Execute( database->OnPostEdit )
         endif
         USE
         SELECT ( GetContent() )
      endif

      DbUnLock()
   endif   

   USE

   mh_Echo( View( "default" ) )

return nil

//----------------------------------------------------------------------------//

function Task()

   local cResult := ""

   OpenTable( GetContent() )
   DbGoTo( GetVal1() )

   cCode = field->code
   cCode = StrTran( cCode, "Main", "__Main" ) 

   USE

   if ! Empty( cCode )
      if "func" $ cCode .or. "proc" $ cCode 
         cResult = Execute( cCode )
      else
         cResult = cCode
      endif      
   endif   

return cResult

//----------------------------------------------------------------------------//

function GetCookies()

   local hHeadersIn := mh_HeadersIn()
   local cCookies := If( hb_HHasKey( hHeadersIn, "Cookie" ), hb_hGet( hHeadersIn, "Cookie" ), "" )
   local aCookies := hb_aTokens( cCookies, ";" )
   local cCookie, hCookies := {=>}
   
   for each cCookie in aCookies
      cCookie = AllTrim( cCookie )
      hb_HSet( hCookies, SubStr( cCookie, 1, At( "=", cCookie ) - 1 ),;
               SubStr( cCookie, At( "=", cCookie ) + 1 ) )
   next            
   
return hCookies

//----------------------------------------------------------------//

function hb_CapFirst( cText )

return Upper( Left( cText, 1 ) ) + SubStr( cText, 2 )   

//----------------------------------------------------------------------------//

function OpenTable( cTableName )

   local oError

   TRY
      if cUserName == "guest"
         USE ( hb_GetEnv( "PRGPATH" ) + "/data/" + cTableName ) SHARED NEW
      else
         USE ( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/" + cTableName ) SHARED NEW
      endif
   CATCH oError
      ?? "Error opening table: " + cTableName
      ?  "UserName: " + cUserName
      ? "File to open: " + hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/" + cTableName
      ? "File exists: " + ;
         If( File( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/" + cTableName ),;
             "Yes", "No" )
      ? GetErrorInfo( oError )
      BREAK
   END    

return nil   

//----------------------------------------------------------------------------//
