procedure main1()

    local nNum := 1

    while .t.
        if nNum % 100000 == 0
            ?? nNum
        end if

        nNum := laFuncion( nNum )
    end

return

function laFuncion( n )

    n := n + 1

return n