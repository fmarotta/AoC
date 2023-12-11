function read_puzzle(file)
    empty_rows = []
    empty_cols = []
    l = readlines(file)
    space = [l[i][j] for i in 1:length(l), j in 1:length(l[1])]
    for (i, r) in enumerate(eachrow(space))
        if ! any(isequal('#'), r)
            push!(empty_rows, i)
        end
    end
    for (i, r) in enumerate(eachcol(space))
        if ! any(isequal('#'), r)
            push!(empty_cols, i)
        end
    end
    return space, empty_rows, empty_cols
end

function compute(space, empty_rows, empty_cols; expansion_rate = 1)
    res = 0
    # get coords of each galaxy
    galaxies = findall(isequal('#'), space)
    for i in 1:length(galaxies)-1
        g1 = galaxies[i]
        for j in i+1:length(galaxies)
            g2 = galaxies[j]
            crossed_empty_rows = findall((x) -> x in min(g2[1], g1[1]):max(g2[1], g1[1]), empty_rows)
            drows = abs(g2[1] - g1[1]) + length(crossed_empty_rows) * (expansion_rate - 1)
            crossed_empty_cols = findall((x) -> x in min(g2[2], g1[2]):max(g2[2], g1[2]), empty_cols)
            dcols = abs(g2[2] - g1[2]) + length(crossed_empty_cols) * (expansion_rate - 1)
            res += drows + dcols
        end
    end
    return Int(res)
end

l, er, ec = read_puzzle("input")
println(compute(l, er, ec; expansion_rate = 2))
println(compute(l, er, ec; expansion_rate = 1e6))
