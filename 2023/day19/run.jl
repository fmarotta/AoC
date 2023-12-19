function read_puzzle(file)
    l = readlines(file)
    s = findfirst(isequal(""), l)
    workflows = Dict("A" => ["A"], "R" => ["R"])
    parts = []
    for workflow in l[1:s-1]
        name, rule = match(r"(.*)\{(.*)\}", workflow)
        instructions = split(rule, ",")
        workflows[name] = instructions
    end
    for part in l[s+1:end]
        x, m, a, s = parse.(Int, match(r"\{x=(.*),m=(.*),a=(.*),s=(.*)\}", part))
        push!(parts, (x = x, m = m, a = a, s = s))
    end
    return workflows, parts
end

function process(part, rules, workflows)
    for rule in rules
        if occursin(':', rule)
            test, outcome = split(rule, ":")
            category, sign, number = test[1], test[2], parse(Int, test[3:end])
            if sign == '>' && part[Symbol(category)] > number
                return process(part, workflows[outcome], workflows)
            elseif sign == '<' && part[Symbol(category)] < number
                return process(part, workflows[outcome], workflows)
            end
        elseif rule == "A"
            return true
        elseif rule == "R"
            return false
        else
            return process(part, workflows[rule], workflows)
        end
    end
end

function split_range!(part_range, category, sign, number)
    part_range_ok = copy(part_range)
    if sign == '>'
        part_range_ok[category] = number+1:part_range_ok[category][end]
        part_range[category] = part_range[category][begin]:number
    elseif sign == '<'
        part_range_ok[category] = part_range_ok[category][begin]:number-1
        part_range[category] = number:part_range[category][end]
    end
    return part_range_ok
end

function count_combos(part_range, rules, workflows)
    if any(length.(values(part_range)) .== 0)
        return 0
    end
    accepted_count = 0
    for rule in rules
        if occursin(':', rule)
            test, outcome = split(rule, ":")
            category, sign, number = test[1], test[2], parse(Int, test[3:end])
            part_range_ok = split_range!(part_range, category, sign, number)
            accepted_count += count_combos(part_range_ok, workflows[outcome], workflows)
        elseif rule == "A"
            accepted_count += prod(length.(values(part_range)))
        elseif rule == "R"
            accepted_count += 0
        else
            accepted_count += count_combos(part_range, workflows[rule], workflows)
        end
    end
    return accepted_count
end

function part1(workflows, parts)
    res = 0
    for part in parts
        outcome = process(part, workflows["in"], workflows)
        if outcome == true
            res += sum(part)
        end
    end
    return res
end

function part2(workflows)
    return count_combos(
        Dict(c => 1:4000 for c in ['x', 'm', 'a', 's']),
        workflows["in"],
        workflows
    )
end

workflows, parts = read_puzzle("input")
println(part1(workflows, parts))
println(part2(workflows))

