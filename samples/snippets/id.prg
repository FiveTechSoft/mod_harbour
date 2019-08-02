// Code examples to be shared on the web

function Main()

   local cArgs := AP_Args()

   if ! File( hb_GetEnv( "PRGPATH" ) + "/snippets.dbf" )
      DbCreate( hb_GetEnv( "PRGPATH" ) + "/snippets.dbf",;
                { { "ID",          "C", 20, 0 },;
                  { "DESCRIPTION", "C", 50, 0 },;
                  { "CODE",        "M", 10, 0 } } )
   endif

   USE ( hb_GetEnv( "PRGPATH" ) + "/snippets" ) SHARED NEW

   LOCATE FOR cArgs $ Field->ID

   if Found()
      ? "Yes"
   else
      ?? hb_GetEnv( "DOCUMENT_ROOT" )
   endif

   USE

return nil                  