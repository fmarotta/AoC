@enum pulse low high

function read_puzzle(file)
    modules = Dict()
    conjunctions = []
    for l in eachline(file)
        name, targets = split(l, " -> ")
        if name == "broadcaster"
            type = "broadcaster"
            state = 0
            modules[name] = [type, state, split(targets, ", ")]
        elseif name[1] == '%'
            type = "flipflop"
            state = 0  # 0 off, 1 on
            modules[name[2:end]] = [type, state, split(targets, ", ")]
        elseif name[1] == '&'
            type = "conjunction"
            state = Dict()
            modules[name[2:end]] = [type, state, split(targets, ", ")]
            push!(conjunctions, name[2:end])
        end
    end
    for (name, m) in modules
        for conj in conjunctions
            if conj in m[3]
                modules[conj][2][name] = low
            end
        end
    end
    return modules
end

function push_button!(modules; watching = nothing)
    q = [(low, "button", "broadcaster")]
    processed = Dict(low => 0, high => 0)
    while length(q) > 0
        value, source, name = popfirst!(q)
        processed[value] += 1
        if watching !== nothing && source in keys(watching) && value == low
            watching[source] = true
        end
        if ! (name in keys(modules))
            continue
        end
        # update the state and send the pulses
        type, state, targets = modules[name]
        new_value = low
        if type == "broadcaster"
            # ignore the state, just send low to everyone
            for target in targets
                push!(q, (new_value, name, target))
            end
        elseif type == "flipflop"
            if value == low
                if state == 1
                    modules[name][2] = 0
                    new_value = low
                elseif state == 0
                    modules[name][2] = 1
                    new_value = high
                end
                for target in targets
                    push!(q, (new_value, name, target))
                end
            end
        elseif type == "conjunction"
            modules[name][2][source] = value
            if all(isequal(high), values(modules[name][2]))
                new_value = low
            else
                new_value = high
            end
            for target in targets
                push!(q, (new_value, name, target))
            end
        end
    end
    return processed[low], processed[high]
end

function is_state_default(modules)
    for (name, m) in modules
        type, state, _ = m
        if type == "flipflop" && state != 0
            return false
        elseif type == "conjunction" && any(isequal(high), state)
            base_state = false
            return false
        end
    end
    return true
end

function part1(modules)
    low = high = 0
    i = 1
    while i <= 1e3
        l, h = push_button!(modules)
        low += l
        high += h
        if is_state_default(modules)
            period = i
            can_skip = div(1e3, period)
            low *= can_skip
            high *= can_skip
            i += can_skip * period
        else
            i += 1
        end
    end
    return low * high
end

function part2(modules)
    # Inspection of the input revealed that:
    # * vr sends a low to rx when all(dk, fm, pq, fg) send high.
    # * dk sends high when sf sends low.
    # * fm sends high when tx sends low.
    # * pq sends high when fs sends low.
    # * fg sends high when ls sends low.
    #
    # I assume that the last four nodes will send "low" periodically.
    periods = Dict(
        "sf" => 0,
        "tx" => 0,
        "fs" => 0,
        "ls" => 0,
    )
    for i in 1:1e4
        watching = Dict(k => false for k in keys(periods))
        push_button!(modules; watching = watching)
        for (k, v) in watching
            if v == true && periods[k] == 0
                periods[k] = i
            end
        end
    end
    return lcm(values(periods)...)
end

modules = read_puzzle("input")
println(part1(modules))

modules = read_puzzle("input")
println(part2(modules))
