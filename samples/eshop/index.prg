static cContent

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
                 
   if hb_HHasKey( hPairs, "forgot" )
      AP_RPuts( View( "default" ) )
      if ! Empty( hPairs[ "username" ] ) 
         AP_RPuts( "<script>MsgInfo( 'An email has been sent to you to reset your password' )</script>" )
      else   
         AP_RPuts( "<script>MsgInfo( 'Please write your email or phone number' )</script>" )
      endif    
   else
      if Identify( hPairs[ "username" ], hPairs[ "passw" ] )
      else
         AP_RPuts( View( "default" ) )
         AP_RPuts( "<script>MsgInfo( 'wrong username or password', 'Please try it again' )</script>" )
      endif 
   endif 

return nil

//----------------------------------------------------------------------------//

function Identify( cUserName, cPassword )

return .F.

//----------------------------------------------------------------------------//

function GetContent()

return cContent

//----------------------------------------------------------------------------//

function BlogName()

return "My blog"

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