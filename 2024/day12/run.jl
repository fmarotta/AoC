function read_matrix(file)
    l = readlines(file)
    [l[i][j] for i in eachindex(l), j in eachindex(l[1])]
end

const dirs = CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)])

function perimeter(m, k)
    perim = 0
    for d in dirs
        if get(m, k + d, ' ') != m[k]
            perim += 1
        end
    end
    perim
end

function corners(m, k)
    corn = 0
    for (d1, d2) in zip(dirs[[1, 1, 3, 3]], dirs[[2, 4, 2, 4]])
        c1 = get(m, k + d1, ' ')
        c2 = get(m, k + d2, ' ')
        c3 = get(m, k + d1 + d2, ' ')
        if m[k] != c1 && m[k] != c2 || m[k] == c1 == c2 != c3
            corn += 1
        end
    end
    corn
end

function compute(m)
    part1 = part2 = 0
    visited = falses(size(m))
    for k in CartesianIndices(m)
        if visited[k] == true
            continue
        end
        visited[k] = true
        Q = [k]
        a = 0
        p = 0
        c = 0
        while length(Q) > 0
            cur = popfirst!(Q)
            a += 1
            p += perimeter(m, cur)
            c += corners(m, cur)
            for dir in dirs
                if get(m, cur + dir, ' ') == m[cur] && visited[cur + dir] == false
                    visited[cur + dir] = true
                    push!(Q, cur + dir)
                end
            end
        end
        # @show m[k], a, p, c
        part1 += a * p
        part2 += a * c
    end
    println(part1)
    println(part2)
end

m = read_matrix(ARGS[1])
compute(m)
