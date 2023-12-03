#!/usr/bin/env julia

function blow_wind(m)
    valley = deepcopy(m)
    for r in 1:size(valley)[1], c in 1:size(valley)[2]
        push!(valley[r, c], '*')
    end
    nr = size(valley)[1]
    nc = size(valley)[2]
    for r in 1:nr, c in 1:nc
        s = popfirst!(valley[r, c])
        while s != '*'
            if s == '<'
                push!(valley[r, mod((c - 1) - 1, nc) + 1], s)
            elseif s == '>'
                push!(valley[r, mod((c - 1) + 1, nc) + 1], s)
            elseif s == '^'
                push!(valley[mod((r - 1) - 1, nr) + 1, c], s)
            elseif s == 'v'
                push!(valley[mod((r - 1) + 1, nr) + 1, c], s)
            end
            s = popfirst!(valley[r, c])
        end
    end
    return valley
end

function neighbours(valley, r, c, i)
    candidates = [
        [r - 1, c],
        [r + 1, c],
        [r, c - 1],
        [r, c + 1],
        [r, c],
    ]
    neighbours = []
    for probe in candidates
        # if off bounds, continue
        if any(probe .<= [0, 0]) || any(probe .> size(valley[(i+1-1) % length(valley) + 1]))
            continue
        end
        if available(valley, probe[1], probe[2], i + 1)
            push!(neighbours, (probe..., i + 1))
        end
    end
    return neighbours
end

available(valley, r, c, i) = length(valley[(i - 1) % length(valley) + 1][r, c]) == 0

function traverse_blizzard(valley, start, finish, time = 0)
    # bfs: I'm at coordinates (r, c, i); what are the neighbours?
    # the neighbours are the open slots at time i+1.
    visited = Set()
    q = []
    # add the first available spot to the q
    i = time + 1
    while true
        while !available(valley, start[1], start[2], i)
            i += 1
        end
        push!(q, (start[1], start[2], i))
        push!(visited, (start[1], start[2], i))
        while length(q) > 0
            cur = popfirst!(q)
            # println(cur .- (0, 0, 1))
            if cur[1] == finish[1] && cur[2] == finish[2]
                # println(cur[3])
                return cur[3]
            end
            for neighbour in neighbours(valley, cur...)
                if neighbour in visited
                    continue
                end
                push!(q, neighbour)
                push!(visited, neighbour)
            end
        end
        # we haven't reached the end, we must wait longer before
        # braving the blizzard...
        i += 1
    end
end

open("test.txt") do io
    lines = readlines(io)
    # println(lines)
    m = [lines[r][c] == '.' ? Char[] : [lines[r][c]] for r in 2:length(lines)-1, c in 2:length(lines[1])-1]
    nr, nc = size(m)
    # println("$nr\t$nc")
    valley = Vector{Matrix{Vector{Char}}}(undef, lcm(nr, nc))
    valley[1] = m
    for i in 2:lcm(nr, nc)
        valley[i] = blow_wind(valley[i-1])
    end
    # println(length(valley))
    # for (i, m) in enumerate(valley)
    # # i, m = (250, valley[250])
    #     if i > 2
    #         break
    #     end
    #     println()
    #     println(i-1)
    #     for r in eachrow(m)
    #         println(r)
    #     end
    # end

    forward1 = traverse_blizzard(valley, (1, 1), (nr, nc), 0)
    println(forward1)
    reverse = traverse_blizzard(valley, (nr, nc), (1, 1), forward1 + 1)
    println(reverse)
    forward2 = traverse_blizzard(valley, (1, 1), (nr, nc), reverse + 1)
    println(forward2)
end

