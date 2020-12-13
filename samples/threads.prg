function Main()

   local pThreadId

   if hb_mtvm()
      ? "mod_harbour supports multi thread"
      pThreadId = hb_threadStart( @test() )
      hb_threadWait( pThreadId )
      hb_threadQuitRequest( pThreadId )
   else
      ? "This mod_harbour version is not the official one"
   endif 
   
   ? "done"

return nil

function Test()

   ? "inside the thread"
   
return nil
