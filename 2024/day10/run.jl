function read_matrix(file)
    l = readlines(file)
    parse.(Int, [l[i][j] for i in eachindex(l), j in eachindex(l[1])])
end

const dirs = CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)])

function find_trails(m, cur)
    if m[cur] == 9
        return [cur]
    end
    res = []
    for dir in dirs
        if ! checkbounds(Bool, m, cur + dir) || m[cur + dir] - m[cur] != 1
            continue
        end
        append!(res, find_trails(m, cur + dir))
    end
    res
end

function compute(m)
    part1 = 0
    part2 = 0
    for k in CartesianIndices(m)
        if m[k] != 0
            continue
        end
        trails = find_trails(m, k)
        part1 += length(unique(trails))
        part2 += length(trails)
    end
    println(part1)
    println(part2)
end

m = read_matrix(ARGS[1])
compute(m)
