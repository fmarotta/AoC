#!/usr/bin/env julia

struct Point
    x::Int
    y::Int
end

move(p::Point, dir) = Point(((p.x, p.y) .+ dir)...)

simulate_rock = function(rocks, sands, spawn_point, lowest_rock)
    # spawn sand unit
    sand = spawn_point
    println("spawning at $sand")
    # try to go down/left/right
    rest = false
    while !rest
        rest = true
        for dir in [(0, 1), (-1, 1), (1, 1)]
            probe = move(sand, dir)
            print("Trying to move to $probe, ")
            if probe in union(rocks, sands)
                println("but something is already there")
                continue
            else
                println("which is free...")
                sand = probe
                rest = false
                break
            end
        end
        # exit condition: unit of sand doesn't come to rest
        if sand.y >= lowest_rock
            break
        end
    end
    # rest is true if the rock found a place to stay, false if it'll fall down forever
    if rest
        # return the resting point
        return sand
    else
        return nothing
    end
    return rest
end

const sand_source = Point(500, 0)

open("input.txt", "r") do io
    rocks = Set{Point}()
    for rock_path in eachline(io)
        corners = split(rock_path, " -> ")
        i = 1
        p1 = parse.(Int, split(corners[i], ","))
        while i < length(corners)
            i += 1
            p2 = parse.(Int, split(corners[i], ","))
            # interpolate
            if p1[1] == p2[1]
                for y in p1[2]:sign(p2[2] - p1[2]):p2[2]
                    push!(rocks, Point(p1[1], y))
                end
            elseif p1[2] == p2[2]
                for x in p1[1]:sign(p2[1] - p1[1]):p2[1]
                    push!(rocks, Point(x, p1[2]))
                end
            else
                throw("Eric is making our life unnecessarily difficult!")
            end
            p1 = p2
        end
    end

    println(rocks)
    lowest_rock = max([p.y for p in rocks]...)

    sands = Set{Point}()
    rested_units = 0
    while true
        rest_point = simulate_rock(rocks, sands, sand_source, lowest_rock)
        if rest_point == nothing
            # we reached the end
            break
        else
            push!(sands, rest_point)
        end
        rested_units += 1
    end
    println(rested_units)
end


