#!/usr/bin/env julia

const initx = 1
const n_cycles = Dict("addx" => 2, "noop" => 1)

open("input.txt", "r") do io
    x = initx
    clock = 0
    checkpoint = 20
    res = 0
    for sloc in eachline(io)
        instruction = match(r"addx (.*)", sloc)
        if instruction == nothing
            # this must be a noop
            clock += 1
            increment = 0
        else
            # this is an addx
            clock += 2
            increment = parse(Int, instruction[1])
        end
        if clock >= checkpoint
            res += checkpoint * x
            checkpoint += 40
        end
        if checkpoint > 220
            break
        end
        x += increment
        # we are at the end of the nth cycle
    end
    println(res)
end
