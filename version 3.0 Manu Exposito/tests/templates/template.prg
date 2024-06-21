procedure main()

	TEMPLATE	
        <br>					
        <?prg 
            local cHtml := ''
			
            cHtml += 'Date Today: ' + dtoc( date() )
            cHtml += '<br>'
            cHtml += 'Time now: ' + time()
		
            return cHtml
        ?>		
        <br>					
	ENDTEXT 
	
	? 'Bye'

return  
