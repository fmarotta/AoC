function read_puzzle(file)
    l = readlines(file)
    [l[i][j] for i in 1:length(l), j in 1:length(l[1])]
end

function energise!(pos, direction, mirrors, mat = zeros(Int, size(mirrors)), visited = Set())
    if (pos, direction) in visited
        return sum(mat .> 0)
    end
    if pos[1] < 1 || pos[1] > size(mat, 1)
        return sum(mat .> 0)
    end
    if pos[2] < 1 || pos[2] > size(mat, 2)
        return sum(mat .> 0)
    end
    mat[pos...] += 1
    push!(visited, (pos, direction))
    symbol = mirrors[pos...]
    if symbol == '.' || (symbol == '-' && direction[1] == 0) || (symbol == '|' && direction[2] == 0)
        return energise!(pos .+ direction, direction, mirrors, mat, visited)
    elseif symbol == '-'
        newdir1 = (0, 1)
        newdir2 = (0, -1)
        energise!(pos .+ newdir1, newdir1, mirrors, mat, visited)
        energise!(pos .+ newdir2, newdir2, mirrors, mat, visited)
    elseif symbol == '|'
        newdir1 = (1, 0)
        newdir2 = (-1, 0)
        energise!(pos .+ newdir1, newdir1, mirrors, mat, visited)
        energise!(pos .+ newdir2, newdir2, mirrors, mat, visited)
    elseif symbol == '/'
        newdir = (-direction[2], -direction[1])
        energise!(pos .+ newdir, newdir, mirrors, mat, visited)
    elseif symbol == '\\'
        newdir = (direction[2], direction[1])
        energise!(pos .+ newdir, newdir, mirrors, mat, visited)
    end
    return sum(mat .> 0)
end

mirrors = read_puzzle("input")
println(energise!((1, 1), (0, 1), mirrors))

res = 0
for i in 1:size(mirrors, 1), j in [1, size(mirrors, 2)]
    r = energise!((i, j), j == 1 ? (0, 1) : (0, -1), mirrors)
    if r > res
        global res = r
    end
end
for i in [1, size(mirrors, 1)], j in 1:size(mirrors, 2)
    r = energise!((i, j), i == 1 ? (1, 0) : (-1, 0), mirrors)
    if r > res
        global res = r
    end
end
println(res)
