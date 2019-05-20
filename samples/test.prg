#xcommand ? <cText> => AP_RPuts( <cText> )

#define CRLF hb_OsNewLine()

function Test()

   ? "Harbour power" + "<br><br>" + CRLF + CRLF
   
   ? Version()

return nil
