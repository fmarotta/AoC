function read_matrix(file)
    l = readlines(file)
    [l[i][j] for i in eachindex(l), j in eachindex(l[1])]
end

function part1(m)
    s = falses(size(m, 2))
    ans = 0
    for r in axes(m, 1)
        for c in axes(m, 2)
            if m[r, c] == 'S'
                s[c] = true
            elseif m[r, c] == '^' && s[c] == true
                ans += 1
                s[c] = false
                s[c-1] = s[c+1] = true
            end
        end
    end
    return ans
end

function part2(m)
    cur = zeros(Int, size(m, 2))
    for r in axes(m, 2)
        next = copy(cur)
        for c in axes(m, 2)
            if m[r, c] == 'S'
                next[c] = 1
            elseif m[r, c] == '^' && cur[c] > 0
                next[c] = 0
                next[c-1] += cur[c]
                next[c+1] += cur[c]
            end
        end
        cur .= next
    end
    return sum(cur)
end

function part1_and_part2_together(m)
    cur = zeros(Int, size(m, 2))
    part1 = 0
    for r in axes(m, 2)
        next = copy(cur)
        for c in axes(m, 2)
            if m[r, c] == 'S'
                next[c] = 1
            elseif m[r, c] == '^' && cur[c] > 0
                part1 += 1
                next[c] = 0
                next[c-1] += cur[c]
                next[c+1] += cur[c]
            end
        end
        cur .= next
    end
    part2 = sum(cur)
    println(part1)
    println(part2)
end

m = read_matrix(ARGS[1])
# part1(m) |> println
# part2(m) |> println
part1_and_part2_together(m)
