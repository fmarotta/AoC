using DataStructures: PriorityQueue, dequeue!, peek

function pm(m, sep = " ")
    println.(join.(eachrow(m), sep))
    nothing
end

function read_matrix(file)
    l = readlines(file)
    [l[i][j] for i in eachindex(l), j in eachindex(l[1])]
end

const dirs = CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)])

function compress(m, initial_state, final_position)
    graph = Dict()
    Q = [initial_state]
    while length(Q) > 0
        start, startdir = popfirst!(Q)
        cur = start
        curdir = startdir
        score = 0
        walked = [cur]
        open = filter(x -> x != -curdir && m[cur + x] != '#', dirs)
        while cur != final_position && length(open) == 1
            score += 1 + 1000 * (open[1] != curdir)
            cur += open[1]
            curdir = open[1]
            push!(walked, cur)
            open = filter(x -> x != -curdir && m[cur + x] != '#', dirs)
        end
        if !((start, startdir) in keys(graph))
            graph[start, startdir] = Set()
        end
        if !((cur, curdir) in keys(graph))
            graph[cur, curdir] = Set()
        end
        # println("linking to $cur, $curdir, $score")
        push!(graph[start, startdir], (cur, curdir, score, walked))
        for opendir in open
            # println("turning to $(cur + opendir), $opendir, $(1 + 1000 * (curdir != opendir))")
            push!(graph[cur, curdir], (cur + opendir, opendir, 1 + 1000 * (curdir != opendir), [cur]))
            if !((cur + opendir, opendir) in keys(graph))
                push!(Q, (cur + opendir, opendir))
            end
        end
    end
    graph
end

function dijkstra(graph, start, targets)
    open = Set(k for k in keys(graph))
    dist = PriorityQueue(k => Inf for k in keys(graph))
    dist[start] = 0
    prev = Dict{Any, Any}(start => nothing)
    while length(open) > 0
        cur, curdist = peek(dist)
        if cur in targets
            return curdist, dist, prev, cur
        end
        dequeue!(dist)
        pop!(open, cur)
        for (next, nextdir, score, _) in graph[cur]
            if !((next, nextdir) in open)
                continue
            end
            if dist[next, nextdir] > score + curdist
                dist[next, nextdir] = score + curdist
                prev[next, nextdir] = cur
            end
        end
    end
    return Inf, dist, prev, nothing
end

function extract_path(prev, target, graph)
    path = []
    while prev[target] !== nothing
        for (pos, dir, _, w) in graph[prev[target]]
            if (pos, dir) == target
                append!(path, w)
            end
        end
        target = prev[target]
    end
    path
end

m = read_matrix(ARGS[1])
openenddirs = filter(x -> m[findfirst(==('E'), m) + x] != '#', dirs)
S = (findfirst(==('S'), m), CartesianIndex(0, 1))
E = [(findfirst(==('E'), m), -dir) for dir in openenddirs]
graph = compress(m, S, findfirst(==('E'), m))
maxdist, _, _, _ = dijkstra(graph, S, E)
maxdist = Int(maxdist)
println(maxdist)

visited = Set{Any}()
for (i, k) in pairs(collect(keys(graph)))
    println("iter $i out of $(length(keys(graph)))")
    fin1, _, prev1, t1 = dijkstra(graph, S, [k])
    if fin1 > maxdist
        continue
    end
    fin2, _, prev2, t2 = dijkstra(graph, k, E)
    if fin1 + fin2 == maxdist
        path1 = extract_path(prev1, t1, graph)
        path2 = extract_path(prev2, t2, graph)
        union!(visited, path1)
        union!(visited, path2)
    end
end
println(length(visited))
