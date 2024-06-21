/*	
   La persistencia esta por enciama de la aplicacion.
   Esto quiere decir que si no se le pone un NAMESPACE los valores
   persistidos se comparten. (OJO con la seguridad)
*/	

procedure main()

   if ap_getPersistent( "APP_A", "var" ) != NIL
      ap_setPersistent( "APP_A", "var", ap_getPersistent( "APP_A", "var" ) + 1 )
   else
      ap_setPersistent( "APP_A", "var", 0 )
   endif
   
   if ap_getPersistent( "APP_B", "var" ) != NIL
      ap_setPersistent( "APP_B", "var", ap_getPersistent( "APP_B", "var" ) - 1 )
   else
      ap_setPersistent( "APP_B", "var", 1000 )
   endif   
   
   ? 'ap_getPersistent( , "var" ): ', ap_getPersistent( , "var" )
   ? "<hr>"

   ? 'ap_getPersistent( "APP_A", "var" ): ', ap_getPersistent( "APP_A", "var" ) 
   ? 'ap_getPersistent( "APP_B", "var" ): ', ap_getPersistent( "APP_B", "var" ) 
   
   ? "<hr>"

return
