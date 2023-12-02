function read_puzzle(file)
    games = []
    for l in eachline(file)
        game = split(l, ": ")[2]
        sets = []
        for set in split(game, "; ")
            r = g = b = 0
            for color in split(set, ", ")
                if occursin("red", color)
                    r = parse(Int, split(color, " ")[1])
                elseif occursin("green", color)
                    g = parse(Int, split(color, " ")[1])
                elseif occursin("blue", color)
                    b = parse(Int, split(color, " ")[1])
                end
            end
            push!(sets, (r, g, b))
        end
        push!(games, sets)
    end
    return games
end

function part1(games, constraint)
    tot = 0
    for (i, game) in enumerate(games)
        possible = true
        for set in game
            if !all(x -> x >= 0, constraint .- set)
                possible = false
                break
            end
        end
        if possible == true
            tot += i
        end
    end
    return tot
end

function part2(games)
    tot = 0
    for game in games
        r = g = b = 0
        for set in game
            r = max(r, set[1])
            g = max(g, set[2])
            b = max(b, set[3])
        end
        power = r * g * b
        tot += power
    end
    return tot
end

games = read_puzzle("input")
constraint = (12, 13, 14)

sum_of_possible = part1(games, constraint)
println(sum_of_possible)

sum_of_power = part2(games)
println(sum_of_power)
