function read_puzzle(file)
    adj = Dict()
    for l in eachline(file)
        dev, outs = split(l, ": ")
        adj[dev] = split(outs)
    end
    return adj
end

function count_paths(l, start, stop, memo = Dict())
    if stop == start
        return 1
    end
    if !(stop in keys(memo))
        memo[stop] = 0
        for (k, v) in l
            if stop in v
                memo[stop] += count_paths(l, start, k, memo)
            end
        end
    end
    return memo[stop]
end

l = read_puzzle(ARGS[1])
@show part1 = count_paths(l, "you", "out")
@show part2 = prod([
    count_paths(l, "svr", "dac"),
    count_paths(l, "dac", "fft"),
    count_paths(l, "fft", "out"),
]) + prod([
    count_paths(l, "svr", "fft"),
    count_paths(l, "fft", "dac"),
    count_paths(l, "dac", "out"),
])
