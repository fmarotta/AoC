function read_puzzle(file)
    parse.(Int, split(readline(file)))
end

function count_offspring(num, turns, memo = Dict())
    if turns <= 0
        return 1
    end
    if !((num, turns) in keys(memo))
        memo[(num, turns)] = if num == 0
            count_offspring(1, turns - 1, memo)
        elseif ndigits(num) & 1 == 0
            d = digits(num)
            numhead = evalpoly(10, d[1:end÷2])
            numtail = evalpoly(10, d[end÷2+1:end])
            count_offspring(numhead, turns - 1, memo) + count_offspring(numtail, turns - 1, memo)
        else
            count_offspring(num * 2024, turns - 1, memo)
        end
    end
    return memo[(num, turns)]
end

l = read_puzzle(ARGS[1])
count_offspring.(l, 25) |> sum |> println
count_offspring.(l, 75) |> sum |> println
