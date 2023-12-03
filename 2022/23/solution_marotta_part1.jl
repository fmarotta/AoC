#!/usr/bin/env julia

open("input.txt") do io
    lines = readlines(io)
    elves = Set()
    for r in 1:length(lines), c in 1:length(lines[1])
        if lines[r][c] == '#'
            push!(elves, Complex(r, c))
        end
    end
    println("== Initial State ==")
    println(elves)
    println()
    # start simulating
    # first move those who go north
    directions = [-1, +1, -1im, +1im]
    for round in 1:10
        proposals = Dict()
        reverse_proposals = Dict()
        for elf in elves
            ball = [
                -1 - 1im, -1 + 0im, -1 + 1im,
                1 - 1im, 1 + 0im, 1 + 1im,
                -1 - 1im, 0 - 1im, 1 - 1im,
                -1 + 1im, 0 + 1im, 1 + 1im,
            ]
            for dir in directions
                # println("direction: $dir")
                if dir == -1
                    top = [-1 - 1im, -1 + 0im, -1 + 1im]
                elseif dir == +1
                    top = [1 - 1im, 1 + 0im, 1 + 1im]
                elseif dir == -1im
                    top = [-1 - 1im, 0 - 1im, 1 - 1im]
                elseif dir == 1im
                    top = [-1 + 1im, 0 + 1im, 1 + 1im]
                end
                # println("elf: $elf")
                # println("top row: $(elf .+ top)")
                if !any(x -> x in elves, elf .+ ball)
                    # no need to move
                    continue
                end
                if any(x -> x in elves, elf .+ top)
                    # can't move north, there are elves there
                    continue
                end
                if elf + dir in keys(reverse_proposals)
                    if reverse_proposals[elf + dir] in keys(proposals)
                        pop!(proposals, reverse_proposals[elf + dir])
                    end
                else
                    proposals[elf] = elf + dir
                    reverse_proposals[elf + dir] = elf
                end
                break
            end
        end

        for elf in keys(proposals)
            pop!(elves, elf)
            push!(elves, proposals[elf])
            println("an elf moves from $elf to $(proposals[elf])")
        end
        println("== End of Round $round ==")
        println(elves)
        println()
        push!(directions, popfirst!(directions))
    end
    min_re = minimum(real.(elves))
    max_re = maximum(real.(elves))
    min_im = minimum(imag.(elves))
    max_im = maximum(imag.(elves))
    empty_places = (max_re - min_re + 1) * (max_im - min_im + 1) - length(elves)
    println(empty_places)

    # ordered_elves = sort(collect(elves), lt = (a, b) -> isless(real(a), real(b)))
    # println([i - Complex(min_re, min_im) + 1 + 1im for i in ordered_elves])
end