function read_puzzle(file)
    s = strip(read(file, String))
    i, g = split(s, "\n\n")
    inputs = Dict()
    for input in split(i, "\n")
        iv, ib = split(input, ": ")
        inputs[iv] = parse(Bool, ib)
    end
    gates = Dict()
    for gate in split(g, "\n")
        g1, op, g2, _, port = split(gate)
        gates[port] = (g1, op, g2)
    end
    inputs, gates
end

pad(n, width = 2, char = '0') = char^(width-ndigits(n)) * string(n)

function get(port, inputs, gates, path = [])
    if port in keys(inputs)
        return inputs[port]
    end
    g1, op, g2 = gates[port]
    push!(path, "$port = $g1 $op $g2")
    if op == "AND"
        get(g1, inputs, gates, path) & get(g2, inputs, gates, path)
    elseif op == "OR"
        get(g1, inputs, gates, path) | get(g2, inputs, gates, path)
    elseif op == "XOR"
        xor(get(g1, inputs, gates, path), get(g2, inputs, gates, path))
    else
        @assert false
    end
end

function find_port(target_gate, gates, target_op = "XOR")
    for (port, (g1, op, g2)) in gates
        if op == target_op && (g1 == target_gate || g2 == target_gate)
            println(port => (g1, op, g2))
        end
    end
end

function part1(inputs, gates)
    res = 0
    outputs = filter(x -> startswith(x, "z"), keys(gates))
    for output in outputs
        num = parse(Int, replace(output, "z" => ""))
        res += get(output, inputs, gates) << num
    end
    res
end

function part2(inputs, gates)
    # need to go bit by bit?
    """
    table:
    x1   y1   out1 rem1
    0    0    0    0
    0    1    1    0
    1    0    1    0
    1    1    0    1

    x2   y2   rem1 out2 rem2 tmp2 tmp3 carryofsecond
    0    0    0    0    0    0    0    0
    0    0    1    1    0    1    0    1
    0    1    0    1    0    0    0    0
    0    1    1    0    1    1    0    1
    1    0    0    1    0    1    0    1
    1    0    1    0    1    0    1    0
    1    1    0    0    1    1    0    1
    1    1    1    1    1    0    1    0

    half adder
    out1 = xor(x1, y1)
    rem1 = and(x1, y1)

    full adder
    tmp2 = xor(rem1, x2)
    out2 = xor(tmp2, y2)
    rem2 = tmp2 && y2 || rem1 && x2

    wiki says the most common impl is
    rem2 = x2 && y2 || rem1 && (x2 xor y2)

    hhhm?
    out2 = (x2 xor y2) xor rem1
    """
    n = length(inputs) ÷ 2
    fake_inputs = Dict(
        p * pad(num) => false for p in ("x", "y"), num in 0:n-1
    )
    # 8, 14, 18, 23
    path = []
    safe = Set()
    for num in 1:n-1
        error = false
        for bx in (false, true), by in (false, true), carry in (false, true)
            fake_inputs["x"*pad(num)] = bx
            fake_inputs["y"*pad(num)] = by
            fake_inputs["x"*pad(num-1)] = carry
            fake_inputs["y"*pad(num-1)] = carry
            empty!(path)
            out = get("z"*pad(num), fake_inputs, gates, path)
            if out != xor(xor(bx, by), carry)
                error = true
                println("Error at gate ", num)
                # println.(path)
                println.(setdiff(path, safe))
                # println.(sort(collect(setdiff(all_gates, safe))))
                return
            end
            fake_inputs["x"*pad(num)] = false
            fake_inputs["y"*pad(num)] = false
            fake_inputs["x"*pad(num-1)] = false
            fake_inputs["y"*pad(num-1)] = false
        end
        if error == false
            empty!(path)
            out = get("z"*pad(num), inputs, gates, path)
            union!(safe, path)
        end
    end
    return nothing
end

inputs, gates = read_puzzle(ARGS[1])
part1(inputs, gates) |> println

# NOTE: this is NOT a general solution, manual tinkering is necessary!

# part2(inputs, gates)
# find_port("mcr", gates) |> println
gates["z08"], gates["mvb"] = gates["mvb"], gates["z08"]
# part2(inputs, gates)
# find_port("x14", gates) |> println
gates["rds"], gates["jss"] = gates["jss"], gates["rds"]
# part2(inputs, gates)
# find_port("x18", gates) |> println
# find_port("fmm", gates) |> println
gates["z18"], gates["wss"] = gates["wss"], gates["z18"]
# part2(inputs, gates)
# find_port("qmd", gates) |> println
gates["z23"], gates["bmn"] = gates["bmn"], gates["z23"]
# part2(inputs, gates)

println("bmn,jss,mvb,rds,wss,z08,z18,z23")