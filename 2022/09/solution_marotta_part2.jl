#!/usr/bin/env julia

function constraint(head::Vector{Int}, tail::Vector{Int})
    pdiff = head .- tail
    if any(i -> abs(i) > 1, pdiff)
        return broadcast(sign, pdiff)
    end
    return [0, 0]
end

const movements = Dict(
    "L" => [-1, 0],
    "R" => [1, 0],
    "U" => [0, -1],
    "D" => [0, 1]
)

const nknots = 10

open("input.txt", "r") do io
    knots = [[0, 0] for i in 1:nknots]
    visited = Set([(knots[nknots][1], knots[nknots][2])])
    for move in eachline(io)
        direction, amount = split(move, " ")
        for i in 1:parse(Int, amount)
            knots[1] .+= movements[direction]
            for i in 2:nknots
                knots[i] .+= constraint(knots[i-1], knots[i])
            end
            push!(visited, (knots[nknots][1], knots[nknots][2]))
        end
    end
    println(length(visited))
end
