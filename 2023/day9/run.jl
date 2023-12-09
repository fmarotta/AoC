function read_puzzle(file)
    return [parse.(Int, split(l)) for l in readlines(file)]
end

function predict_next(seq)
    if all(0 .== seq)
        return seq
    end
    child = predict_next(seq[2:end] - seq[1:end-1])
    push!(seq, seq[end] + child[end])
    return seq
end

function compute(l; part = 1)
    res = 0
    for seq in l
        if 2 == part
            res -= predict_next(reverse(-seq))[end]
        else
            res += predict_next(seq)[end]
        end
    end
    return res
end

l = read_puzzle("input")
println(compute(l; part = 1))
println(compute(l; part = 2))
