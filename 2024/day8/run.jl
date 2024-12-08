function read_matrix(file)
    l = readlines(file)
    [l[i][j] for i in eachindex(l), j in eachindex(l[1])]
end

function find_antennas(m)
    antennas = []
    for i in CartesianIndices(m)
        if m[i] != '.'
            push!(antennas, Tuple(i))
        end
    end
    antennas
end

function find_antinodes(antennas, m)
    part1 = Set()
    part2 = Set()
    for a1 in antennas
        for a2 in antennas
            if a1 == a2
                continue
            end
            if m[a1...] != m[a2...]
                continue
            end
            cur = a2
            delta = a2 .- a1
            if checkbounds(Bool, m, (cur .+ delta)...)
                push!(part1, cur .+ delta)
            end
            while checkbounds(Bool, m, cur...)
                push!(part2, cur)
                cur = cur .+ delta
            end
        end
    end
    length.((part1, part2))
end

m = read_matrix(ARGS[1])
antennas = find_antennas(m)
find_antinodes(antennas, m) |> println
