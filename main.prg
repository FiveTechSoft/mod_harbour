#xcommand ? <cText> => AP_RPuts( <cText> )

extern Version

//----------------------------------------------------------------//

function Main()

   ErrorSys( { | o | ? GetErrorInfo( o ) } )

   AP_SetContentType( "text/html" )

   if File( AP_FileName() )
      Execute( MemoRead( AP_FileName() ), AP_Args() )
   else
      ? "File not found: " + AP_FileName()
   endif   

return nil

//----------------------------------------------------------------//

function Alert( x )

return ? x

//----------------------------------------------------------------//

function Execute( cCode, ... )

   local oHrb, cResult, bOldError, uRet
   local cHBheaders := "c:\harbour\include"

   oHrb = HB_CompileFromBuf( cCode, .T., "-n", "-I" + cHBheaders )
   if ! Empty( oHrb )
      BEGIN SEQUENCE
      bOldError = ErrorBlock( { | o | DoBreak( o ) } )
      uRet = hb_HrbDo( hb_HrbLoad( oHrb ), ... )
      END SEQUENCE
      ErrorBlock( bOldError )
   endif

return uRet

//----------------------------------------------------------------//

function GetErrorInfo( oError )

   local cInfo := oError:operation, n

   if ValType( oError:Args ) == "A"
      cInfo += "   Args:" + CRLF
      for n = 1 to Len( oError:Args )
         cInfo += "[" + Str( n, 4 ) + "] = " + ValType( oError:Args[ n ] ) + ;
                   "   " + ValToChar( oError:Args[ n ] ) + hb_OsNewLine()
      next
   endif

return oError:Description + hb_OsNewLine() + cInfo,;
       "Script error at line: " + AllTrim( Str( ProcLine( 2 ) ) ) )

//----------------------------------------------------------------//

static function DoBreak( oError )

   ? GetErrorInfo( oError )

   BREAK

return nil

//----------------------------------------------------------------//

function ValToChar( u )

   local cType := ValType( u )
   local cResult
   
   do case
      case cType == "C"
           cResult = u
           
      case cType == "D"
           cResult = DToC( u )
           
      case cType == "L"
           cResult = If( u, ".T.", ".F." )
           
      case cType == "N"
           cResult = AllTrim( Str( u ) )
           
      case cType == "A"
           cResult = "{ ... }"
           
      otherwise
           cResult = "type not supported yet in function ValToChar()"
   endcase
   
return cResult   

//----------------------------------------------------------------//
