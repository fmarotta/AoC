#!/usr/bin/env julia

"""
say that name is drzm.
yells[drzm] = hmdt - zczc
yells[hmdt] = 32
yells[zczc] = 2
"""
function resolve(name, yells, resolutions)
    if !(name in keys(resolutions))
        strings = split(yells[name])[[begin, end]]
        variables = Meta.parse.(strings)
        operation = Meta.parse(yells[name])
        # println(variables)
        # println(yells[name])
        ex = quote
            $(variables[1]) = resolve($(strings[1]), $yells, $resolutions)
            $(variables[2]) = resolve($(strings[2]), $yells, $resolutions)
            $(operation)
        end
        # println(ex)
        # println(eval(ex))
        resolutions[name] = eval(ex)
    end
    return resolutions[name]
end

open("input.txt") do io
    yells = Dict()
    resolutions = Dict()
    for l in eachline(io)
        w = split(l, ": ")
        if (m = match(r"\d+", w[2])) != nothing
            resolutions[w[1]] = parse(Int, w[2])
        else
            yells[w[1]] = w[2]
        end
    end
    # println(yells)
    # println(resolutions)

    println(Int(resolve("root", yells, resolutions)))
end
