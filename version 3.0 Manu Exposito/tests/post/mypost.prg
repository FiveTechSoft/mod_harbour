procedure main()
	
	local cMthdType := ap_getMethod()

  if cMthdType == "POST"  
	  ? "ap_readPost: ", ap_readPost()
  else   
    ? "No se ha enviado mada con el metodo POST"
  endif

  ? 'Method: ', cMthdType
  ? 'Body: ', ap_getBody()   
  ? 'ap_readGet: ', ap_readGet()   
  ? 'Args: ', ap_getArgs()

return
