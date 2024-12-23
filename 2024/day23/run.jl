function read_puzzle(file)
    l = split.(readlines(file), "-")
    nodes = unique(vcat(getindex.(l, 1), getindex.(l, 2)))
    edges = Set(Set.(l))
    adjlist = Dict()
    for n1 in nodes
        if !(n1 in keys(adjlist))
            adjlist[n1] = Set([n1])
        end
        for n2 in nodes
            if Set([n1, n2]) in edges
                push!(adjlist[n1], n2)
            end
        end
    end
    return nodes, edges, adjlist
end

function triplets(nodes, edges)
    triplets = Set()
    for e in edges, n in nodes
        if n in e
            continue
        end
        if (Set([collect(e)[1], n]) in edges) && (Set([collect(e)[2], n]) in edges)
            push!(triplets, union(e, [n]))
        end
    end
    triplets
end

function cliques(triplets, adjlist)
    cliques = Set()
    while true
        for triplet in triplets
            for n in intersect([adjlist[x] for x in triplet]...)
                push!(cliques, union(triplet, [n]))
            end
        end
        if cliques == triplets
            break
        end
        triplets = cliques
    end
    cliques
end

function compute(nodes, edges, adjlist)
    trips = triplets(nodes, edges)
    cliqs = cliques(trips, adjlist)
    part1 = 0
    for trip in trips
        if any(startswith.(trip, 't'))
            part1 += 1
        end
    end
    println(part1)
    maxlength = 0
    maxclique = Set()
    for cliq in cliqs
        if length(cliq) > maxlength
            maxclique = cliq
            maxlength = length(cliq)
        end
    end
    join(sort(collect(maxclique)), ",") |> println
end

nodes, edges, adjlist = read_puzzle(ARGS[1])
compute(nodes, edges, adjlist)
