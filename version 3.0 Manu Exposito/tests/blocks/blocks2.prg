procedure main()

    local cValue := "Hello world"
    local cTime := time()

    BLOCKS PARAMS cValue, cTime
      I can freely write here any text but also I can use my local vars:
      {{cValue}} at {{ cTime }}
      so it seems to work fine ;-)
    ENDTEXT

return