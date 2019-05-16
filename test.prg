// Please copy this file to c:\Apache24\htdocs\
// From your web browser go to localhost/test.prg

#xcommand ? <cText> => AP_RPuts( <cText> )

#define CRLF hb_OsNewLine()

function Test()

   ? "Harbour power" + CRLF + CRLF
   
   ? Version()

return nil
