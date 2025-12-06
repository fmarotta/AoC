function read_puzzle(file)
    lines = readlines(file)
    return lines[1:end-1], split(lines[end])
end

function part1(numlines, ops)
    nums = map(numlines) do line
        parse.(Int, split(line))
    end
    part1 = 0
    for col in eachindex(nums[1])
        op = if ops[col] == "+"
            sum
        elseif ops[col] == "*"
            prod
        end
        part1 += op(nums[row][col] for row in eachindex(nums))
    end
    return part1
end

function part2(numlines, ops)
    # input is mapped to a matrix of characters "as is"
    nums = [numlines[i][j] for i in eachindex(numlines), j in eachindex(numlines[1])]
    col = 1
    part2 = 0
    for op in ops
        tot = if op == "+"
            0
        elseif op == "*"
            1
        end
        # characters are joined column by column
        while col <= size(nums, 2)
            r = 0
            for row in axes(nums, 1)
                if nums[row, col] != ' '
                    r = 10 * r + nums[row, col] - '0'
                end
            end
            col += 1
            if r != 0
                tot = if op == "+"
                    tot + r
                elseif op == "*"
                    tot * r
                end
            else
                break
            end
        end
        part2 += tot
    end
    return part2
end

numlines, ops = read_puzzle(ARGS[1])
part1(numlines, ops) |> println
part2(numlines, ops) |> println
