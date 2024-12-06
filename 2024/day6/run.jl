function read_matrix(file)
    l = readlines(file)
    [l[i][j] for i in eachindex(l), j in eachindex(l[1])]
end

function get_next_obstacle(m, cur, dir)
    while checkbounds(Bool, m, cur + dir)
        if m[cur + dir] == '#'
            return true, cur
        end
        cur = cur + dir
    end
    return false, cur
end

function will_loop(m)
    cur = findfirst(==('^'), m)
    dir = CartesianIndex(-1, 0)
    visited = Set()
    inside = true
    while inside == true
        if !((cur, dir) in visited)
            push!(visited, (cur, dir))
        else
            return true
        end
        inside, cur = get_next_obstacle(m, cur, dir)
        dir = turn_right(dir)
    end
    return false
end

turn_right(dir) = CartesianIndex(([0 1; -1 0] * [dir[1], dir[2]])...)

function part1(m)
    cur = findfirst(==('^'), m)
    dir = CartesianIndex(-1, 0)
    visited = zeros(Bool, size(m))
    visited[cur] = true
    inside = true
    while inside == true
        inside, next = get_next_obstacle(m, cur, dir)
        while cur != next
            cur = cur + dir
            visited[cur] = true
        end
        dir = turn_right(dir)
    end
    return sum(visited)
end

function part2(m)
    total = 0
    for pos in CartesianIndices(m)
        if m[pos] != '.'
            continue
        end
        m2 = copy(m)
        m2[pos] = '#'
        if will_loop(m2) == true
            total += 1
        end
    end
    return total
end

m = read_matrix(ARGS[1])
part1(m) |> println
part2(m) |> println
