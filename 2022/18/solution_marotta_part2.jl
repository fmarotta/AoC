#!/usr/bin/env julia

function are_adjacent(cube1, cube2)
    return sum(cube1 .- cube2) == 1
end

cubes = open("input.txt", "r") do io
    coords = []
    for l in eachline(io)
        cube = parse.(Int, split(l, ","))
        push!(coords, cube)
    end
    println(coords)
    span_x = (minimum([cube[1] for cube in coords]), maximum([cube[1] for cube in coords]))
    span_y = (minimum([cube[2] for cube in coords]), maximum([cube[2] for cube in coords]))
    span_z = (minimum([cube[3] for cube in coords]), maximum([cube[3] for cube in coords]))
    println(span_x)
    println(span_y)
    println(span_z)

    cubes = falses(span_x[2] - span_x[1] + 3, span_y[2] - span_y[1] + 3, span_z[2] - span_z[1] + 3)
    for cube in coords
        cubes[cube[1] - span_x[1] + 2, cube[2] - span_y[1] + 2, cube[3] - span_z[1] + 2] = true
    end

    return cubes
end

for z in 1:size(cubes)[3]
    # plane = cubes[:, :, z]
    println("plane $z")
    println()
    for r in 1:size(cubes)[1]
        print("$r\t")
        println(cubes[r, :, z])
    end
end

directions = [
    [-1, 0, 0],
    [1, 0, 0],
    [0, -1, 0],
    [0, 1, 0],
    [0, 0, -1],
    [0, 0, 1],
]

# we start from a point that we know to be on the edge, and just try to move
# as far as possible; at each position, we detect wether we are on an edge and count it.
# We should visit each vapor-accessible position only once.
function traverse()
    edge_count = 0
    visited = falses(size(cubes)...)
    function dfs(start, cubes, visited)
        # check if we are off the bounds
        if any(start .<= 0) || any(start .> size(cubes))
            return
        end
        # check if we have already visited this place
        if visited[start[1], start[2], start[3]]
            return
        end
        # check if it's a cube (vapor can't get here)
        if cubes[start[1], start[2], start[3]]
            return
        end
        println("checking out $start")
        # visit this
        visited[start[1], start[2], start[3]] = true
        # check if it's an edge
        for dir in directions
            probe = start .+ dir
            if any(probe .<= 0) || any(probe .> size(cubes))
                continue
            end
            if cubes[probe[1], probe[2], probe[3]]
                edge_count += 1
            end
        end
        # visit the neighbours
        for dir in directions
            next = start .+ dir
            dfs(next, cubes, visited)
        end
        return
    end
    dfs([1, 1, 1], cubes, visited)
    return edge_count
end

println(traverse())
