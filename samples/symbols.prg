function Main()

  local n

  for n = __DYNSCOUNT() to 1 step -1
     ? __DYNSGETNAME( n )
  next

return nil
