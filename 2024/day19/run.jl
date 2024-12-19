function read_puzzle(file)
    s = strip(read(file, String))
    p, d = split(s, "\n\n")
    patterns = split(p, ", ")
    designs = split(d, "\n")
    return patterns, designs
end

function compose(p, d, memo = Dict())
    if d == ""
        return 1
    end
    if d in keys(memo)
        return memo[d]
    end
    memo[d] = 0
    for pp in p
        if !startswith(d, pp)
            continue
        end
        memo[d] += compose(p, d[length(pp)+1:end], memo)
    end
    return memo[d]
end

function compute(patterns, designs)
    part1 = 0
    part2 = 0
    for design in designs
        c = compose(patterns, design)
        part1 += c > 0
        part2 += c
    end
    println(part1)
    println(part2)
end

p, d = read_puzzle(ARGS[1])
compute(p, d)
