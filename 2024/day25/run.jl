function read_puzzle(file)
    s = read(file, String)|> strip
    keys = []
    locks = []
    for l in split.(eachsplit(s, "\n\n"), "\n")
        m = [l[i][j] != '.' for i in eachindex(l), j in eachindex(l[1])]
        if l[1][1] == '.'
            push!(keys, m)
        else
            push!(locks, m)
        end
    end
    keys, locks
end

function compute(keys, locks)
    res = 0
    for k in keys
        for l in locks
            if any(k .&& l)
                continue
            end
            res += 1
        end
    end
    res
end

keys, locks = read_puzzle(ARGS[1])
compute(keys, locks) |> println
