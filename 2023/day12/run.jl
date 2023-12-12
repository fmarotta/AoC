function read_puzzle(file)
    parts, nums = [], []
    for l in eachline(file)
        part, num = split(l)
        push!(parts, part)
        push!(nums, parse.(Int, split(num, ",")))
    end
    return parts, nums
end

function check_part(part, blocks, memo = Dict())
    if (part, blocks) in keys(memo)
        return memo[(part, blocks)]
    end
    if count('#', part) > sum(blocks)
        memo[(part, blocks)] = 0
        return 0
    end
    if length(part) == 0
        if sum(blocks) == 0
            memo[(part, blocks)] = 1
            return 1
        else
            memo[(part, blocks)] = 0
            return 0
        end
    end
    if sum(blocks) == 0
        if occursin('#', part)
            memo[(part, blocks)] = 0
            return 0
        else
            memo[(part, blocks)] = 1
            return 1
        end
    end
    if blocks[1] == 0
        if part[1] == '#'
            memo[(part, blocks)] = 0
            return 0
        else
            result = check_part(part[2:end], blocks[2:end], memo)
            memo[(part, blocks)] = result
            return result
        end
    end
    if startswith(part, '.')
        part = replace(part, r"^\." => "")
        result = check_part(part, blocks, memo)
        memo[(part, blocks)] = result
        return result
    elseif startswith(part, '#')
        bb = copy(blocks)
        while (startswith(part, '#') || startswith(part, '?')) && bb[1] > 0
            part = part[2:end]
            bb[1] -= 1
        end
        if bb[1] > 0 && startswith(part, '.')
            memo[(part, blocks)] = 0
            return 0
        end
        result = check_part(part, bb, memo)
        memo[(part, join(bb))] = result
        return result
    elseif startswith(part, '?')
        p1 = check_part(part[2:end], blocks, memo)
        memo[(part[2:end], blocks)] = p1
        bb = copy(blocks)
        while (startswith(part, '#') || startswith(part, '?')) && bb[1] > 0
            part = part[2:end]
            bb[1] -= 1
        end
        if bb[1] > 0 && startswith(part, '.')
            return p1
        end
        p2 = check_part(part, bb, memo)
        memo[(part, join(bb))] = p2
        return p1 + p2
    end
end

function compute(parts, nums)
    res1 = 0
    res2 = 0
    for i in 1:length(parts)
        part = parts[i]
        blocks = nums[i]
        r = check_part(part, blocks)
        res1 += r
        part = join(repeat([part], 5), "?")
        blocks = repeat(blocks, 5)
        r = check_part(part, blocks)
        res2 += r
    end
    println(res1)
    println(res2)
end

parts, nums = read_puzzle("input")
compute(parts, nums)
