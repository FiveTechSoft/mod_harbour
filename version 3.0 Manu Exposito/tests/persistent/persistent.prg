procedure test()

   if ap_getPersistent( , "var" ) != NIL
      ap_setPersistent( , "var", ap_getPersistent( , "var" ) + 1 )
   else
      ap_setPersistent( , "var", 1 )
   endif

   ? 'ap_getPersistent( , "var" ) value: ', ap_getPersistent( , "var" ) 

return 
