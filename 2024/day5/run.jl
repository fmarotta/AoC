function read_puzzle(file)
    l = read(file, String)
    rules, lines = split(l, "\n\n")
    partial_order = Set()
    for rule in split(rules, "\n")
        n1, n2 = split(rule, "|")
        push!(partial_order, (n1, n2))
    end
    return split(lines, "\n"), partial_order
end

function reorder(nums, less_rules)
    # bubble sort ftw!
    ordered_nums = copy(nums)
    valid = false
    while valid == false
        valid = true
        for i in 1:length(ordered_nums)-1
            if !((ordered_nums[i], ordered_nums[i+1]) in less_rules)
                ordered_nums[i], ordered_nums[i+1] = ordered_nums[i+1], ordered_nums[i]
                valid = false
                break
            end
        end
    end
    ordered_nums
end

function compute(lines, less_rules)
    part1 = 0
    part2= 0
    for line in lines
        if line == ""
            continue
        end
        nums = split(line, ",")
        valid = true
        for i in 1:length(nums)-1
            if !((nums[i], nums[i+1]) in less_rules)
                valid = false
                break
            end
        end
        if valid == true
            part1 += parse(Int, nums[div(length(nums), 2) + 1])
        else
            ordered_nums = reorder(nums, less_rules)
            part2 += parse(Int, ordered_nums[div(length(ordered_nums), 2) + 1])
        end
    end
    println(part1)
    println(part2)
end

lines, less_rules = read_puzzle(ARGS[1])
compute(lines, less_rules)
