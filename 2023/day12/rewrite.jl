function read_puzzle(file)
    rows = []
    for l in eachline(file)
        springs, groups = split(l)
        groups = parse.(Int, split(groups, ","))
        push!(rows, (springs, groups))
    end
    return rows
end

function count_arrangements(springs, groups)
    # println(springs, ", ", groups)
    if length(springs) == 0
        if sum(groups) == 0
            return 1
        else
            return 0
        end
    end
    if sum(groups) == 0
        if count('#', springs) > 0
            return 0
        else
            return 1
        end
    end
    if startswith(springs, '.')
        return count_arrangements(springs[2:end], groups)
    elseif startswith(springs, '#')
        g = copy(groups)
        while g[1] > 0
            if length(springs) == 0 || springs[1] == '.'
                return 0
            end
            g[1] -= 1
            springs = springs[2:end]
        end
        if length(springs) == 0
            return count_arrangements(springs, g[2:end])
        elseif springs[1] == '#'
            return 0
        else
            return count_arrangements(springs[2:end], g[2:end])
        end
    elseif startswith(springs, '?')
        sp1 = replace(springs, '?' => '.', count = 1)
        sp2 = replace(springs, '?' => '#', count = 1)
        return count_arrangements(sp1, groups) + count_arrangements(sp2, groups)
    end
end

function compute(rows)
    res1 = 0
    res2 = 0
    for (springs, groups) in rows
        res1 += count_arrangements(
            springs,
            groups
        )
        res2 += count_arrangements(
            join(repeat([springs], 5), "?"),
            repeat(groups, 5)
        )
    end
    println(res1)
    println(res2)
end

rows = read_puzzle("test")
# println(rows)
compute(rows)
