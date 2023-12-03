#!/usr/bin/env julia

function are_adjacent(cube1, cube2)
    return sum(cube1 .- cube2) == 1
end

open("input.txt", "r") do io
    cubes = Dict()
    coords = []
    for l in eachline(io)
        cube = parse.(Int, split(l, ","))
        push!(coords, cube)
        if !(cube[1] in keys(cubes))
            cubes[cube[1]] = Dict()
        end
        if !(cube[2] in keys(cubes[cube[1]]))
            cubes[cube[1]][cube[2]] = Dict()
        end
        cubes[cube[1]][cube[2]][cube[3]] = true
        # push!(cubes, parse.(Int, split(l, ",")))
    end
    println(cubes)
    println(coords)

    function getcube(x, y, z)
        res = false
        try
            res = cubes[x][y][z]
            res = true
        catch
            # println("no cube here")
        end
        return res
    end

    directions = [
        [-1, 0, 0],
        [1, 0, 0],
        [0, -1, 0],
        [0, 1, 0],
        [0, 0, -1],
        [0, 0, 1],
    ]

    # idea: I start from one cube, move in all 6 possible directions,
    # and see if there is another cube. It's essentially a bfs.
    open_sides = 0
    for cur in coords
        println("considering cur $cur")
        # push!(visited, cur)
        for dir in directions
            adjcoord = cur .+ dir
            println("considering $adjcoord")
            if !getcube(adjcoord...)
                open_sides += 1
            end
        end
    end
    println(open_sides)
end
