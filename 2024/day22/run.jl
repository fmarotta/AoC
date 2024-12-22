function read_puzzle(file)
    parse.(Int, readlines(file))
end

function evolve(sn)
    n = sn << 6
    sn = xor(n, sn)
    sn = sn % 16777216
    n = sn >> 5
    sn = xor(n, sn)
    sn = sn % 16777216
    n = sn << 11
    sn = xor(n, sn)
    sn = sn % 16777216
    sn
end

function evolve!(sn, prices::Vector, changes::Vector)
    prev = sn % 10
    for i in eachindex(prices)
        sn = evolve(sn)
        prices[i] = sn % 10
        changes[i] = sn % 10 - prev
        prev = sn % 10
    end
    return sn
end

function compute(inp)
    sequences = Dict()
    prices = zeros(Int, 2000)
    changes = zeros(Int, 2000)
    part1 = 0
    for sn in inp
        sn = evolve!(sn, prices, changes)
        part1 += sn
        seen = Set()
        for j in 1:2000-3
            if changes[j:j+3] in seen
                continue
            end
            push!(seen, changes[j:j+3])
            sequences[changes[j:j+3]] = get(sequences, changes[j:j+3], 0) + prices[j+3]
        end
    end
    println(part1)
    println(maximum(values(sequences)))
    return
end

l = read_puzzle(ARGS[1])
compute(l)
