#!/usr/bin/env julia

const n_top_elves = 3

mutable struct DynamicVector{T<:Number}
    v::Vector{T}
    occupied::Int
    DynamicVector{T}(v, _) where {T<:Number} = new(v, 0)
end
DynamicVector{T}() where {T<:Number} = DynamicVector{T}(zeros(T, 8), 0)

function append!(a::DynamicVector{T}, value::T) where {T<:Number}
    if a.occupied == length(a.v)
        new = zeros(T, length(a.v) * 2)
        copyto!(
            new, CartesianIndices(1:length(a.v)),
            a.v, CartesianIndices(1:length(a.v))
        )
        a.v = new
    end
    a.v[a.occupied + 1] = value
    a.occupied += 1
    return nothing
end

function toStaticVector(a::DynamicVector{T}) where {T<:Number}
    return copy(a.v)
end


open("input.txt", "r") do io
    elves = DynamicVector{Int}()
    elf_calories = 0
    for i = eachline(io)
        if i == ""
            append!(elves, elf_calories)
            elf_calories = 0
        else
            elf_calories += parse(Int, i)
        end
    end
    top_n = sort(toStaticVector(elves), rev=true)[1:n_top_elves]
    sum_top_n = 0
    for elf = top_n
        sum_top_n += elf
    end
    println(sum_top_n)
end
 