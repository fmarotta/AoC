function read_matrix(file)
    l = readlines(file)
    [l[i][j] for i in eachindex(l), j in eachindex(l[1])]
end

const dirs = CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)])

function extract_path(prev, target)
    path = []
    while target !== nothing
        pushfirst!(path, target)
        target = prev[target]
    end
    path
end

function compute(m)
    S = findfirst(==('S'), m)
    E = findfirst(==('E'), m)
    Q = [S]
    dist = fill(Inf, size(m))
    dist[S] = 0
    prev::Matrix{Union{CartesianIndex, Nothing}} = fill(nothing, size(m))
    while length(Q) > 0
        cur = popfirst!(Q)
        if cur == E
            return E, dist, prev
        end
        for dir in dirs
            if m[cur + dir] == '#'
                continue
            end
            if dist[cur] + 1 < dist[cur + dir]
                dist[cur + dir] = dist[cur] + 1
                prev[cur + dir] = cur
                push!(Q, cur + dir)
            end
        end
    end
    return E, dist, prev
end

function cheat(path, dist)
    cheats1 = Set()
    cheats2 = Set()
    for i in 1:length(path)-1
        for j in i+1:length(path)
            p1, p2 = path[i], path[j]
            manhattan = let d = p2 - p1
                abs(d[1]) + abs(d[2])
            end
            time_saved = dist[p2] - dist[p1] - manhattan
            if time_saved < 100
                continue
            end
            if manhattan == 2
                push!(cheats1, (p1, p2))
            end
            if manhattan <= 20
                push!(cheats2, (p1, p2))
            end
        end
    end
    println(length(cheats1))
    println(length(cheats2))
end

m = read_matrix(ARGS[1])
target, dist, prev = compute(m)
path = extract_path(prev, target)
cheat(path, dist)
