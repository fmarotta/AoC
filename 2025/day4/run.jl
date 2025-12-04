function read_matrix(file)
    l = readlines(file)
    [l[i][j] for i in eachindex(l), j in eachindex(l[1])]
end
const drs = CartesianIndex.(((-1, 0), (0, 0), (1, 0)))
const dcs = CartesianIndex.(((0, -1), (0, 0), (0, 1)))

function remove_rolls!(m)
    res = 0
    ncycles = 0
    to_remove = []
    while true
        ncycles += 1
        for cur in CartesianIndices(m)
            if m[cur] != '@'
                continue
            end
            n_adj_rolls = 0
            for dr in drs, dc in dcs
                adj = cur + dr + dc
                if !checkbounds(Bool, m, adj)
                    continue
                end
                if m[adj] == '@'
                    n_adj_rolls += 1
                end
            end
            if n_adj_rolls <= 4
                res += 1
                push!(to_remove, cur)
            end
        end
        if ncycles == 1
            # part 1 result
            println(res)
        end
        if length(to_remove) == 0
            # part 2 result
            println(res)
            break
        end
        for i in to_remove
            m[i] = 'x'
        end
        empty!(to_remove)
    end
end

m = read_matrix(ARGS[1])
remove_rolls!(m)
