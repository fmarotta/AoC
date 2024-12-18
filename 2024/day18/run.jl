using DataStructures: PriorityQueue, dequeue!, peek

const dirs = CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)])

function read_puzzle(file)
    coords = []
    for l in eachline(file)
        col, row = parse.(Int, eachsplit(l, ","))
        push!(coords, CartesianIndex(row+1, col+1))
    end
    coords
end

function part1(coords, size = (71, 71))
    open = setdiff(Set(CartesianIndices(size)), Set(coords))
    dist = PriorityQueue(k => Inf for k in open)
    dist[CartesianIndex(1, 1)] = 0
    while length(open) > 0
        cur, curdist = peek(dist)
        if cur == CartesianIndex(size)
            return curdist
        end
        pop!(open, cur)
        dequeue!(dist, cur)
        for dir in dirs
            next = cur + dir
            if !(next in open)
                continue
            end
            if curdist + 1 < dist[next]
                dist[next] = curdist + 1
            end
        end
    end
    return Inf
end

function part2(coords)
    for i in 1025:length(coords)
        d = part1(coords[1:i])
        if d == Inf
            return join(reverse(Tuple(coords[i]).-1), ",")
        end
    end
end

coords = read_puzzle(ARGS[1])
part1(coords[1:1024]) |> println
part2(coords) |> println
