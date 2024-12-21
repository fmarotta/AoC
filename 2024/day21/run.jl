function read_puzzle(file)
    [[c for c in s] for s in readlines(file)]
end

"manhattan distance"
function d_manh(x, y)
    d = y - x
    abs(d[1]) + abs(d[2])
end

const dirs = zip(['^', '>', 'v', '<'], CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)]))
const numpad = ['7' '8' '9'; '4' '5' '6'; '1' '2' '3'; ' ' '0' 'A']
const dirpad = [' ' '^' 'A'; '<' 'v' '>']

function decode_pad(pad, code, pos = findfirst(==('A'), pad), path = [])
    if code == []
        return [copy(path)]
    end
    target = findfirst(==(code[1]), pad)
    if pos == target
        push!(path, 'A')
        res = decode_pad(pad, code[2:end], pos, path)
        pop!(path)
        return res
    end
    res = []
    for (dirsymbol, dir) in dirs
        if get(pad, pos + dir, ' ') == ' '
            continue
        end
        if d_manh(pos + dir, target) > d_manh(pos, target)
            continue
        end
        push!(path, dirsymbol)
        append!(res, decode_pad(pad, code, pos + dir, path))
        pop!(path)
    end
    res
end

function count_keypress(level, code; memo = Dict())
    if level == 0
        return length(code)
    end
    if (level, code) in keys(memo)
        return memo[level, code]
    end
    totlen = 0
    start = findfirst(==('A'), dirpad)
    for key in code
        # give me all possible ways to reach that target.
        minlen = Inf
        for path in decode_pad(dirpad, [key], start)
            ml = count_keypress(level - 1, path; memo)
            if ml < minlen
                minlen = ml
            end
        end
        start = findfirst(==(key), dirpad)
        totlen += minlen
    end
    memo[level, code] = totlen
    return totlen
end

function compute(codes)
    part1 = 0
    part2 = 0
    for code in codes
        prevpaths = decode_pad(numpad, code)
        minlen1 = minimum(count_keypress(2, path) for path in prevpaths)
        minlen2 = minimum(count_keypress(25, path) for path in prevpaths)
        num = reduce(filter(isdigit, code), init = 0) do a, b
            a * 10 + (b - '0')
        end
        part1 += num * minlen1
        part2 += num * minlen2
    end
    println(part1)
    println(part2)
end

read_puzzle(ARGS[1]) |> compute
