function read_puzzle(file)
    winning = []
    mine = []
    for l in eachline(file)
        numbers = split(l, ": ")[2]
        win, min = split.(strip.(split(numbers, " | ")), r" +")
        push!(winning, win)
        push!(mine, min)
    end
    return winning, mine
end

function part1(winning, mine)
    tot = 0
    for i in 1:length(winning)
        n_right = 0
        for w in winning[i]
            for m in mine[i]
                if w == m
                    n_right += 1
                end
            end
        end
        tot += 1 << (n_right - 1)
    end
    return tot
end

function part2(winning, mine)
    instances = zeros(Int, length(winning))
    for i in 1:length(winning)
        instances[i] += 1
        n_right = 0
        for w in winning[i]
            for m in mine[i]
                if w == m
                    n_right += 1
                end
            end
        end
        instances[i+1:i+n_right] .+= instances[i]
    end
    return sum(instances)
end

winning, mine = read_puzzle("input")
total_score = part1(winning, mine)
println(total_score)
total_cards = part2(winning, mine)
println(total_cards)
