procedure main()

    local cValue := "Hello world"
    local cTime := time()
	local cHtml := ''

    BLOCKS TO cHtml PARAMS cValue, cTime
      I can freely write here any text but also I can use my local vars:
      {{cValue}} at {{ cTime }}
      so it seems to work fine ;-)
	  <br>
    ENDTEXT
	
	cHtml += '<h3>Test of line...</h3><hr>'
		
    BLOCKS TO cHtml 
		Lorem Ipsum is simply dummy text of the printing 
		and typesetting industry. Lorem Ipsum has been the 
		industrys standard dummy text ever since the 1500s, 
		when an unknown printer took a galley of type and 
		scrambled it to make a type specimen book. It has 
		survived not only five centuries, but also the leap 
		into electronic typesetting, remaining essentially 
		unchanged. It was popularised in the 1960s with the 
		release of Letraset sheets containing Lorem Ipsum 
		passages, and more recently with desktop publishing 
		software like Aldus PageMaker including versions of 
		Lorem Ipsum.
    ENDTEXT	
	
	?? cHtml	

return 