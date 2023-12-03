#!/usr/bin/env julia

const initx = 1
const line_size = 40

crt_x(clock) = mod(clock - 1, line_size)

open("input.txt", "r") do io
    x = initx
    clock = 0
    display = Vector{Char}(undef, line_size)
    for sloc in eachline(io)
        instruction = match(r"addx (.*)", sloc)
        if instruction == nothing
            # this must be a noop
            # begin next cycle
            clock += 1
            # CRT draws
            if abs(x - crt_x(clock)) > 1
                display[crt_x(clock) + 1] = '.'
            else
                display[crt_x(clock) + 1] = '#'
            end
            if crt_x(clock) == 39
                println(join(display, ""))
            end
            increment = 0
        else
            # this is an addx
            clock += 1
            # CRT draws
            if abs(x - crt_x(clock)) > 1
                display[crt_x(clock) + 1] = '.'
            else
                display[crt_x(clock) + 1] = '#'
            end
            if crt_x(clock) == 0
                println(join(display, ""))
            end
            clock += 1
            # CRT draws
            if abs(x - crt_x(clock)) > 1
                display[crt_x(clock) + 1] = '.'
            else
                display[crt_x(clock) + 1] = '#'
            end
            if crt_x(clock) == 0
                println(join(display, ""))
            end
            increment = parse(Int, instruction[1])
        end
        x += increment
        # we are at the end of the nth cycle
    end
end
