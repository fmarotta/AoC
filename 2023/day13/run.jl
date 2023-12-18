function read_puzzle(file)
    patterns = []
    ps = split(read(file, String), "\n\n")
    for p in ps
        p = split(p, "\n")
        filter!((x) -> x != "", p)
        pm = [p[i][j] for i in 1:length(p), j in 1:length(p[1])]
        push!(patterns, pm)
    end
    patterns
end

function find_reflection(pattern, n_smudges = 0)
    n = size(pattern, 1)
    for r in 1:n-1
        # is there a reflection between row r and r+1?
        i = min(r, n-r)
        n_diffs = sum(pattern[r-i+1:r, :] .!= pattern[r+i:-1:r+1, :])
        if n_diffs == n_smudges
            return r
        end
    end
    return 0
end

function compute(patterns)
    res1 = 0
    res2 = 0
    for pattern in patterns
        r1 = 100 * find_reflection(pattern)
        if r1 == 0
            r1 = find_reflection(permutedims(pattern))
        end
        res1 += r1
        r2 = 100 * find_reflection(pattern, 1)
        if r2 == 0
            r2 = find_reflection(permutedims(pattern), 1)
        end
        res2 += r2
    end
    println(res1)
    println(res2)
end

l = read_puzzle("input")
compute(l)
