#xcommand ? <cText> => AP_RPuts( <cText> )

#define CRLF hb_OsNewLine()

function Test()

   ? "Harbour power" + CRLF + CRLF
   
   ? Version()

return nil
