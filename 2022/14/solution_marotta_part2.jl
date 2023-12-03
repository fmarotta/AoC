#!/usr/bin/env julia

struct Point
    x::Int
    y::Int
end

# simulating each sand unit is too slow, we have to compute the "area" of the pyramid. Let's just hope that no rock is on the sides...

move(p::Point, dir) = Point(((p.x, p.y) .+ dir)...)

const sand_source = Point(500, 0)

open("input.txt", "r") do io
    rocks = Set{Point}()
    cavities = Set{Point}()
    for rock_path in eachline(io)
        corners = split(rock_path, " -> ")
        i = 1
        p1 = parse.(Int, split(corners[i], ","))
        while i < length(corners)
            i += 1
            p2 = parse.(Int, split(corners[i], ","))
            # interpolate
            # for each horizontal line of length 3 or more, we add a reverse pyramid because sand can't go there.
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

    lowest_rock = max([p.y for p in rocks]...)
    floor = lowest_rock + 2
    println(floor)

    coord2index(l, h) = (h + 1, l - sand_source.x + floor + 1)
    sand_matrix = falses(floor, 2 * floor + 1)
    sand_matrix[coord2index(sand_source.x, sand_source.y)...] = true
    res = 1
    for h in 1:floor-1
        print("$h\t")
        for l in (500 - (floor - 1)):(500 + (floor - 1))
            # if this point is a rock, continue
            # if this point has sand on top right, top, or top left, it becomes sand
            point = Point(l, h)
            if point in rocks
                print("#")
                continue
            end
            symbol = "."
            for dir in [(1, -1), (0, -1), (-1, -1)]
                probe = move(point, dir)
                if sand_matrix[coord2index(probe.x, probe.y)...]
                    sand_matrix[coord2index(point.x, point.y)...] = true
                    symbol = "o"
                    res += 1
                    break
                end
            end
            print(symbol)
        end
        println()
    end
    println(res)
end

