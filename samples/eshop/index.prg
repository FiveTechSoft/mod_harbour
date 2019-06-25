static cContent, cUserName

//----------------------------------------------------------------------------//

function Main()

   Controller( AP_Args() )

return nil

//----------------------------------------------------------------------------//

function Controller( cRequest )

   cContent = If( Empty( cRequest ), "home",;
                  If( cRequest $ "wishlist,login,cart,checkout", cRequest, "home" ) )

   do case   
      case AP_Method() == "GET"
         AP_RPuts( View( "default" ) )

      case AP_Method() == "POST"
         do case
            case cRequest == "login"
                 Login() 
         endcase 
   endcase   

return nil

//----------------------------------------------------------------------------//

function Login()

   local hPairs := AP_PostPairs()
    
   do case
      case hb_HHasKey( hPairs, "forgot" )
         AP_RPuts( View( "default" ) )
         if ! Empty( hPairs[ "username" ] ) 
            AP_RPuts( "<script>MsgInfo( 'An email has been sent to you to reset your password' )</script>" )
         else   
            AP_RPuts( "<script>MsgInfo( 'Please write your email or phone number' )</script>" )
         endif 
         
      case hb_HHasKey( hPairs, "continue" )     
           if Identify( hPairs[ "username" ], hPairs[ "password" ] )
              cContent = "welcome"
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

   USE ( hb_GetEnv( "PRGPATH" ) + "/data/users" ) SHARED
   
   APPEND BLANK
   if RLock()
      field->first    := hb_HGet( hPairs, "first" )
      field->last     := hb_HGet( hPairs, "last" )
      field->email    := hb_UrlDecode( hb_HGet( hPairs, "email" ) )
      field->phone    := hb_HGet( hPairs, "phone" )
      field->password := hb_Md5( hb_HGet( hPairs, "password" ) )
      DbUnLock()
   endif   
   USE
   
return nil   

//----------------------------------------------------------------------------//

function Identify( _cUserName, _cPassword )

   local lFound

   USE ( hb_GetEnv( "PRGPATH" ) + "/data/users" ) SHARED

   LOCATE FOR ( field->email = hb_UrlDecode( _cUserName ) .or. field->phone = _cUserName ) .and. ;
                field->password = hb_Md5( _cPassword )
   
   lFound = Found()
   
   if lFound
      cUserName = field->first
   endif   

   USE

return lFound

//----------------------------------------------------------------------------//

function GetContent()

return cContent

//----------------------------------------------------------------------------//

function UserName()

return cUserName

//----------------------------------------------------------------------------//

function MyEShopName()

return "My eshop"

//----------------------------------------------------------------------------//

function ItemStatus( cItem )

return If( cContent == cItem, "class='active'", "" ) 

//----------------------------------------------------------------------------//

function GetColor()

return "#FF7F50" // #19caaf

//----------------------------------------------------------------------------//

function View( cView )

   local cData := MemoRead( hb_GetEnv( "PRGPATH" ) + "/views/" + cView + ".view" )

   while ReplaceBlocks( @cData, "{{", "}}" )
   end

return cData

//----------------------------------------------------------------------------//