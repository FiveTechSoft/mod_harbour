// Use the postman utility to send different body values

procedure main()

   local cBody := ap_getBody()

   if Empty( cBody )
      ? "Use the postman utility to send different body values"
   else   
      ? cBody
   endif   
   
return    
