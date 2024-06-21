procedure main()

    local cDate 	:= DToC( date() + 10 )

    BLOCKS PARAMS cDate
        Exemple var from parameter: {{ cDate }}	  
        <br>
        Exemple param before compilation: {% date() %}	  
    ENDTEXT

return 