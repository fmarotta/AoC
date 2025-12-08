function read_puzzle(file)
    points = []
    for l in eachline(file)
        x, y, z = parse.(Int, split(l, ","))
        push!(points, (x, y, z))
    end
    return points
end

function compute(points, n = 1000)
    dist = []
    for i in eachindex(points), j in eachindex(points)
        if i >= j
            continue
        end
        d = sqrt(sum(@. (points[i] - points[j])^2))
        push!(dist, (d, i, j))
    end
    sort!(dist, lt = (x, y) -> x[1] < y[1])
    membership = collect(eachindex(points))
    pair = 1
    while true
        _, i, j = dist[pair]
        # connect points A and B
        membership[membership .== membership[i]] .= membership[j]
        # part 2 answer
        if length(unique(membership)) == 1
            println(points[i][1] * points[j][1])
            return
        end
        # part 1 answer
        if pair == n
            counts = zeros(Int, length(membership))
            for m in membership
                counts[m] += 1
            end
            println(prod(last(sort(counts), 3)))
        end
        pair += 1
    end
end

l = read_puzzle(ARGS[1])
compute(l)
