function Main()

  local n

  ?? '<body bgcolor="dodgerblue";>'

  ?? '<h2 style="color:white">Global Symbol table</h2>'

  for n = __DYNSCOUNT() to 1 step -1
     if __DYNSISFUN( n )
        ?? '<p style="color:springgreen;">' + __DYNSGETNAME( n ) + "</p>" + CRLF
     else
        ?? '<p style="color:yellow;">' + __DYNSGETNAME( n ) + "</p>" + CRLF
     endif
  next

  ? "</body>"

return nil
