// saving publics and privates to disk and restoring them

function Main()

   private c := "Hello world"
   
   SAVE TO ( hb_DirTemp() + "test.mem" )

   c := nil
   
   RESTORE FROM ( hb_DirTemp() + "test.mem" )
   
   ? c

return nil
