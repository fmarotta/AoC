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

open("input.txt", "r") do io
    head = [0, 0]
    tail = [0, 0]
    visited = Set{}([(tail[1], tail[2])])
    for move in eachline(io)
        direction, amount = split(move, " ")
        for i in 1:parse(Int, amount)
            head .+= movements[direction]
            tail .+= constraint(head, tail)
            push!(visited, (tail[1], tail[2]))
        end
    end
    println(length(visited))
end
