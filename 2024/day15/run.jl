const dirs = CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)])
const mov2dir = Dict('^' => dirs[1], '>' => dirs[2], 'v' => dirs[3], '<' => dirs[4])

function read_puzzle(file)
    s = read(file, String)
    room, moves = eachsplit(s, "\n\n")
    l = split(room, "\n")
    m = [l[i][j] for i in eachindex(l), j in eachindex(l[1])]
    moves = replace(moves, "\n" => "")
    start = findfirst(==('@'), m)
    m[start] = '.'
    return m, start, moves
end

function get_front(m, cur, dir)
    if m[cur + dir] in ('.', '#')
        Set([cur + dir])
    elseif m[cur + dir] == '['
        union(
            Set([cur + dir, cur + dir + dirs[2]]),
            get_front(m, cur + dir, dir),
            get_front(m, cur + dir + dirs[2], dir),
        )
    elseif m[cur + dir] == ']'
        union(
            Set([cur + dir, cur + dir + dirs[4]]),
            get_front(m, cur + dir, dir),
            get_front(m, cur + dir + dirs[4], dir),
        )
    end
end

function compute(m, cur, moves)
    for mov in moves
        dir = mov2dir[mov]
        next = cur + dir
        if m[next] == '.'
            cur = next
            continue
        elseif m[next] == '#'
            continue
        elseif m[next] == 'O' || mov in ('>', '<') && m[next] in ('[', ']')
            nn = next + dir
            while !(m[nn] in ('.', '#'))
                nn = nn + dir
            end
            if m[nn] == '#'
                continue
            elseif m[nn] == '.'
                while nn != next
                    m[nn] = m[nn - dir]
                    nn = nn - dir
                end
                m[next] = '.'
                cur = next
                continue
            end
        elseif m[next] in ('[', ']')
            front = collect(get_front(m, cur, dir))
            if any(==('#'), m[front])
                continue
            end
            updates = map(filter(x -> m[x] != '.', front)) do x
                (x + dir, m[x])
            end
            m[front] .= '.'
            for (coord, type) in updates
                m[coord] = type
            end
            cur = next
            continue
        end
    end
    tot = 0
    for col in 2:size(m, 2)-1, row in 2:size(m, 1)-1
        if m[row, col] in ('O', '[')
            tot += 100*(row-1) + (col-1)
        end
    end
    tot
end

function expand(m)
    newcols = []
    for col = eachcol(m)
        push!(newcols, replace(col, 'O' => '['))
        push!(newcols, replace(col, 'O' => ']'))
    end
    reduce(hcat, newcols)
end

m, start, moves = read_puzzle(ARGS[1])
compute(copy(m), start, moves) |> println
compute(expand(m), CartesianIndex(start[1], 2start[2]-1), moves) |> println
