/*
openssl genrsa -out privatekey.pem 2048
openssl req -new -subj "/C=LT/CN=mycompany.org/O=My Company" -key privatekey.pem -out certrequest.csr
openssl x509 -req -days 730 -in certrequest.csr -signkey privatekey.pem -out certificate.pem
openssl x509 -in certificate.pem -text -noout
*/

#require "hbssl"
#require "hbhttpd"

REQUEST __HBEXTERN__HBSSL__

REQUEST DBFCDX

#define CRLF Chr( 13 ) + Chr( 10 )

MEMVAR server, get, post, cookie, session

function Main()

   local oServer, oLogAccess, oLogError, nPort

   IF hb_argCheck( "help" )
      ? "Usage: modharbour [options]"
      ? "Options:"
      ? "  //stop               Stop running server"
      RETURN
   ENDIF

   IF hb_argCheck( "stop" )
      hb_MemoWrit( ".uhttpd.stop", "" )
      RETURN
   ELSE
      FErase( ".uhttpd.stop" )
   ENDIF

   oLogAccess = UHttpdLog():New( "access.log" )
   oLogError  = UHttpdLog():New( "error.log" )

   ? "Starting modharbour server..."
   ? "Listening on port:", nPort := 8002

   oServer := UHttpdNew()

   IF ! oServer:Run( { ;
         "FirewallFilter"      => "", ;
         "LogAccess"           => {| m | oLogAccess:Add( m + hb_eol() ) }, ;
         "LogError"            => {| m | oLogError:Add( m + hb_eol() ) }, ;
         "Trace"               => {| ... | QOut( ... ) }, ;
         "Port"                => nPort, ;
         "Idle"                => {| o | iif( hb_FileExists( ".uhttpd.stop" ), ( FErase( ".uhttpd.stop" ), o:Stop() ), NIL ) }, ;
         "PrivateKeyFilename"  => "private.key", ;
         "CertificateFilename" => "certificate.crt", ;
         "SSL"                 => .F., ;
         "Mount"               => Mount( oServer ) } )
      oLogError:Close()
      oLogAccess:Close()
      ? "Server error:", oServer:cError
      ErrorLevel( 1 )
      RETURN
   ENDIF

   oLogError:Close()
   oLogAccess:Close()

return nil

//----------------------------------------------------------------//

function Mount( oServer )

   local hMount := { ;
      "/"         => { || Execute( hb_memoRead( hb_DirBase() + "index.prg" ), oServer ) } } 

return hMount   

//----------------------------------------------------------------//

function AP_Method()

return server[ "REQUEST_METHOD" ]    

//----------------------------------------------------------------//

function AP_RPuts( cText, ... )

   local n

   UWrite( cText )

   for n = 1 to pcount() - 1 

   next

return nil

//----------------------------------------------------------------//

function Execute( cCode, oServer, ... )

   local oHrb, uRet, lReplaced := .T.
   local cHBheaders1 := "~/harbour/include"
   local cHBheaders2 := "c:\harbour\include"

   // while lReplaced 
   //    lReplaced = ReplaceBlocks( @cCode, "{%", "%}" )
   //    cCode = __pp_process( hPP, cCode )
   // end

   oHrb = HB_CompileFromBuf( cCode, .T., "-n", "-q2", "-I" + cHBheaders1, "-I" + cHBheaders2,;
                              "-I" + hb_GetEnv( "HB_INCLUDE" ), hb_GetEnv( "HB_USER_PRGFLAGS" ) )
   if ! Empty( oHrb )
      uRet = hb_HrbDo( hb_HrbLoad( 1, oHrb ), ... )
   endif

return uRet

//----------------------------------------------------------------//
