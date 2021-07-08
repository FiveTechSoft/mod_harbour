static cContent, cAction, cParam1 := "", cParam2 := "", nVal1 := 0, nVal2 := 0,cdart 
static cUserName, cCode,deftable
static valcateg
static imp := "impegna"
static nrow_rastr := 0
//----------------------------------------------------------------------------//

function Main()
   
   SET CENTURY ON
   
   CheckUser()

  
   Controller( AP_Args() )
   
   

return nil

function Getdeftable()   
   deftable := "rastrelliera"
return deftable

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


function GetCateg()

return valcateg




//----------------------------------------------------------------------------//

function ItemStatus( cItem )

return If( cContent == cItem, "class='active'", nil) 

//----------------------------------------------------------------------------//

function GetColor1() ; return "mediumblue"
function GetColor2() ; return "darkblue"
function GetColor3() ; return "rgb(34, 45, 50)"



//----------------------------------------------------------------------------//

function CheckUser()

   local hCookies := GetCookies()

   if hb_HHasKey( hCookies, "genesis" ) .and. ! Empty( hCookies[ "genesis" ] )
      cUserName = hCookies[ "genesis" ]
   
   endif
   
   if cUserName != nil
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
         hb_vfCopyFile( hb_GetEnv( "PRGPATH" ) + "/views/impegna.view",;
                        hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/views/impegna.view" )               
      endif
   endif

return nil   

//----------------------------------------------------------------------------//

function Controller( cRequest )

   local aRequest
   
  
   if ":" $ cRequest
      aRequest = hb_aTokens( cRequest, ":" )
      cRequest = if(aRequest[ 2 ] == imp, aRequest[2],aRequest[1])     
     
   
      cAction  = If( Len( aRequest ) > 1, aRequest[ 2 ], "browse" )
         

      
      cParam1  = If( Len( aRequest ) > 2, aRequest[ 3 ], aRequest[2])
      cParam2  = If( Len( aRequest ) > 3, aRequest[ 4 ], nil)
      valcateg = If( Len( aRequest ) > 3, aRequest[ 4 ], nil)
      nVal1    = Val( iif(cParam1 != nil,cParam1,"" ))
      nVal2    = Val( iif(cParam2 != nil,cParam2,"" ))
     


      nrow_rastr := If( Len( aRequest ) > 4, aRequest[ 5 ],nil)
      
      if nrow_rastr != nil
         MWRITE("nrowrastr",nrow_rastr)
      end if   
      
         
      
      
        
   
   endif    

   if "-" $ cRequest
      aRequest = hb_ATokens(cRequest,"-")
      cRequest = aRequest[1]
      valcateg = aRequest[2]

       
         

   endif   

   if cRequest == "logout"
      AP_HeadersOutSet( "Set-Cookie", "genesis=" )
      cRequest = "login"
      cUserName = nil
   else   
      if ! hb_HhasKey( GetCookies(), "genesis" )
         cRequest = "login"
      else
         if cUserName != nil
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
       If( cRequest $ "login,logout,home,rastrelliera,impegna,controllers,menus,routes,database,users,settings,tasks,views",;
           cRequest, "home" ) )

   do case   
      case AP_Method() == "GET"
         AP_RPuts( View( "default" ) )

      case AP_Method() == "POST"
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
         elseif GetAction() == "impegna"
            cRoute = "impegna"   
            
         else      
            cRoute = "browse"
         endif
      endif   
   endif      

return View( cRoute )    

//----------------------------------------------------------------------------//



function AddLog()

   if GetContent() != "logs" 
      OpenTable( "logs" )
      APPEND BLANK

      if RLock()
         field->date    := Date()
         field->time    := Time()
         field->userip  := AP_UserIP()
         field->method  := AP_Method()
         field->content := If( ! Empty( GetContent() ), GetContent(), nil)
         field->action  := If( ! Empty( GetAction() ), GetAction(), nil)
         field->param1  := If( ! Empty( GetVal1() ), GetVal1(), 0 )
         field->param2  := If( ! Empty( GetVal2() ), GetVal2(), 0 )
         DbUnLock()
      endif

      USE
   endif   
   
return nil   

//----------------------------------------------------------------------------//

function Login()

   local hPairs := AP_PostPairs()
    
   do case
  
         
      case hb_HHasKey( hPairs, "continue" )     
           if Identify( hPairs[ "username" ], hPairs[ "password" ] )
               cContent = "home"
              AP_HeadersOutSet( "Set-Cookie", "genesis=" + cUserName )
             
              AP_RPuts( View( "default" ) )
           else
              AP_RPuts( View( "default" ) )
              AP_RPuts( "<script>MsgInfo( 'wrong username or password', 'Please try it again' )</script>" )
           endif 
           
      case hb_HHasKey( hPairs, "ok" )
           AddUser( hPairs )
           AP_RPuts( View( "default" ) )
           AP_RPuts( "<script>MsgInfo( 'Please identify and press continue' )</script>" )
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
      cUserName = nil  
   endif   

   USE

return lFound



//----------------------------------------------------------------------------//

function View( cView )
   
   local cViewName, lFound, cData 
  
   if cUserName == nil
      cViewName = hb_GetEnv( "PRGPATH" ) + "/views/" + cView + ".view"
   else 
      
      cViewName = hb_GetEnv( "PRGPATH" ) + "/data/"+ cUserName+ + "/views/" + cView + ".view"
   endif

   lFound = File( cViewName )
   
   if ! lFound
      
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

   local cHtml := "", n, nRow := 0,CODART,nrow_imp
   local I_CATEG := '/var/tmp/I_CATEG'
   local I_IMP := '/var/tmp/I_IMP'
   

   
   if cTableName == imp
    
     
      
      
      /*--------------------------------------------------------RASTRELLIERA-----------------------------------------------------------*/
      OpenTable( deftable )
      
      DbGoTo( Val(mread("nrowrastr")) )

      cHtml += '<h2>Riga selezionata:</h2>'
      cHtml += '<table id="browse" class="table  table-striped table-hover;">' + CRLF
      cHtml += '<thead>' + CRLF
         for n = 1 to FCount() 
            if n != 8
               cHtml += '<th>' + FieldName( n ) + '</n>' 
            end if  
         next
      cHtml += '</thead>' + CRLF
      cHtml+='<tbody>'
            
      cHtml += '<tr>'
      for n = 1 to FCount()
   
         if n != 8
            do case
               
               case FieldType( n ) == "D"
                  cHtml += '<td data-title = "' + FieldName( n ) +'">' + DtoC( FieldGet( n ) ) + '</td>' + CRLF             
               otherwise   
                  cHtml += '<td data-title = "' + FieldName( n ) +'" >' + AllTrim(ValToChar( FieldGet( n ) )) + "</td>"  + CRLF   
                  
                  do case
                     case FieldName(n) == "CATEG"
                        valcateg = ValToChar(FieldGet(n))   
                     case FieldName(n) == "CODART"
                        cdart = ValToChar(FieldGet(n))      
                  
                  endcase 
                     
                  
                  

            endcase            
         end if
      next


      cHtml += '</tr>'
      cHtml+='</tbody>'
            
      cHtml += '</table>' + CRLF
      cHtml += '<h2>Elenco barre impegnate:</h2>'



      nrow_imp = nVal1
      nVal1 = 20
    
      USE
      /*----------------------------------------------------------------------------------------------------------------------------*/
     


   end if    
   
   
   
   OpenTable( cTableName ) 

 
 

   if ! Empty( GetAction() ) .and. GetAction() == "add"
      APPEND BLANK
      do case
         case  cTableName == imp
            if RLock()
               replace CATEG with valcateg
               replace impegna->cdart with  cdart
               DbUnLock()
            endif
         case  cTableName == deftable    
            if RLock()
               replace CATEG with valcateg
              
               DbUnLock()
            endif
      endcase 
         
        
     
      GO TOP
   endif   

   if ! Empty( GetAction() ) .and. GetAction() == "del"
      USE
      if cUserName != nil 
         USE ( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/" + cTableName ) NEW
      endif


      if cTableName == imp
         dbGoto(nrow_imp)
      else
         DbGoTo( GetVal1() )
      end if   
      
      DELETE 
      PACK
      USE
      OpenTable( cTableName )
      GO TOP

      cParam1 := ""
      
      nVal1 := 20


   endif

   
   //Quando la tabella diventa rastrelliera creo indice per filtrare con categoria
   do case
      case  cTableName == deftable
      
         INDEX ON rastrelliera->CATEG to (I_CATEG) for rastrelliera->CATEG = valcateg
         SET INDEX TO (I_CATEG)

      case cTableName == imp
        
         INDEX ON impegna->CATEG to (I_IMP) for impegna->CATEG = AllTrim(valcateg) .AND. impegna->cdart = cdart
         SET INDEX TO (I_IMP) 
        
   end case   
   
 
   if ! Empty( GetAction() ) .and. GetAction() == "search"
      SET FILTER TO Upper( GetParam1() ) $ Upper( DBRECORDINFO( 7 ) )
      GO TOP
      nVal1 = 20
   endif   


   if GetVal2() != 0
      DbSkip( GetVal2() )
   endif   

   cHtml += '<div class="panel-body" style="padding:0px">' + CRLF
   cHtml += '<br>'
   cHtml += '<div class="table-responsive">'
   cHtml += '<table class="table  table-striped table-bordered impegno-tb" style="margin:0px;">' + CRLF
   cHtml +=    '<thead>' + CRLF
   cHtml +=      '<tr>' + CRLF

   cHtml += '<th  scope="col">#</th>' + CRLF
         for n = 1 to FCount() 
            if n != 8
               cHtml += '<th>' + FieldName( n ) + '</n>' 
            end if  
         next
   cHtml += '<th>AZIONI</th>'  
   cHtml+= '</tr>' + CRLF
   cHtml += '</thead>'
   cHtml+='<tbody>'
             
               while ! Eof() .and. nRow < GetVal1()
                  
                  
                  cHtml += '<tr>' + CRLF
                  cHtml += '<th scope="row">' + AllTrim( Str( RecNo() ) ) + "</th>" + CRLF
                  for n = 1 to FCount()
                     if n != 8
                        cHtml += '<td data-title="' + ValToChar(FieldName(n)) + '" class="center">' + ValToChar( FieldGet( n ) ) + "</td>"+ CRLF
                     end if   
                  next




                  cHtml += "<td>"+ CRLF
                  cHtml += '<button tooltip="Modifica" onclick="Edit(' + AllTrim( Str( RecNo() ) ) + ');"' + ;
                           ' type="button" class="btn btn-primary"' + CRLF 
                  cHtml += ' style="border-color:gray;color:gray;background-color:#f9f9f9;">' + CRLF
                  cHtml += '<i class="fas fa-edit" style="color:gray;font-size:13px;">' + CRLF
                  cHtml += '</i></button>' + CRLF
                  
                  if cTableName == deftable 

                     cHtml += '<button tooltip="Impegna barre" onclick="Impegna(' + AllTrim( Str( RecNo() ) )  + ',' + AllTrim( Str( RecNo() ) ) + ',' + "'" +valcateg + "'" + ')"' + ;
                     ' type="button" class="btn btn-primary"' + CRLF 
                     cHtml += ' style="border-color:gray;color:gray;background-color:#f9f9f9;">' + CRLF
                     cHtml += '<i class="fas fa-lock" style="color:gray;font-size:13px;">' + CRLF
                     cHtml += '</i></button>' + CRLF
                  end if
            
                  cHtml += '<button tooltip="Elimina" onclick="Delete(' + AllTrim( Str( RecNo() ) ) + ');"' + ;
                           ' type="button" class="btn btn-primary"' + CRLF 
                  cHtml += ' style="border-color:gray;color:gray;background-color:#f9f9f9;">' + CRLF
                  cHtml += '<i class="fas fa-trash" style="color:gray;font-size:13px;">' + CRLF
                  cHtml += '</i></button>' + CRLF


                  cHtml += "</td>"+ CRLF
                  cHtml += "</tr>"+ CRLF
                  SKIP
                  nRow++
               end   
              
            cHtml+='</tbody>' 
      cHtml+='</table>'
cHtml += '</div>'
cHtml += '</div>'
 
   cHtml += "<hr>" + CRLF
   cHtml += '<div class="row" style="padding-left:15px">' + CRLF
   cHtml += '<div class="col-sm-3">' + CRLF
   cHtml += "Showing records " + AllTrim( Str( Max( GetVal2() + 1, 1 ) ) ) + " - " + ;
            AllTrim( Str( RecNo() - 1 ) ) + " / Total: " + AllTrim( Str( RecCount() ) ) + "</div>" + CRLF
   cHtml += '<div class="col-sm-1"></div>' + CRLF         

          

   cHtml += "</div>" + CRLF + "</div>" + CRLF + "</div>" + CRLF 
   RELEASE ALL            
   USE
  
return cHtml   





//----------------------------------------------------------------------------//

function BuildEdit( cTableName)

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
              If( FieldGet( n ), "checked", nil) + "></td>"

         case FieldType( n ) == "D"
            cHtml += '<input id=datepicker' + AllTrim( Str( n ) ) + ;
            ' type="text" autocomplete="off" name="' + FieldName( n ) + ;
            '" class="form-control" style="border-radius:0px;width:100px;"' + ;
            " value=" + DtoC( FieldGet( n ) ) + '></td>' + CRLF + ;
            "<script>$('#datepicker" + AllTrim( Str( n ) ) + ;
            "').datepicker({uiLibrary: 'bootstrap4'});</script>"

         otherwise   
              cHtml += '<input required type="text" name="' + FieldName( n ) + ;
              '" class="form-control" style="border-radius:0px"' + ;
              " value='" + AllTrim(ValToChar( FieldGet( n ) )) + "'" + iif(FieldName(n) == "CATEG", "readonly>" , ">") + " </td>"
              if FieldName(n) == "CATEG"
               valcateg = ValToChar(FieldGet(n))
              end if 
            

      endcase            
      cHtml += '</tr>'
   next

   cHtml += '</table>' + CRLF

   USE

return cHtml

//----------------------------------------------------------------------------//





function Save()

   local hPost := AP_PostPairs(), n

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
                    
               case FieldType( n ) == "N"
                     FieldPut( n, Val(hb_UrlDecode( hb_HGet( hPost, FieldName( n ) ) ) ) )
            
               otherwise   
                    FieldPut( n, hb_UrlDecode( hb_HGet( hPost, FieldName( n ) ) ) )

                    if FieldName(n) == "CATEG"
                     valcateg = ValToChar(FieldGet(n))
                    end if 

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
   
   AP_RPuts( View( "default" ) )

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

function hb_CapFirst( cText )

return Upper( Left( cText, 1 ) ) + SubStr( cText, 2 )   

//----------------------------------------------------------------------------//

function OpenTable( cTableName )

   local oError

   TRY
      if cUserName != nil
        
         USE ( hb_GetEnv( "PRGPATH" ) + "/data/" + cUserName + "/data/" + cTableName ) SHARED NEW
      elseif cTableName == "users"

         USE ( hb_GetEnv( "PRGPATH" ) + "/data/" + cTableName ) SHARED NEW

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
