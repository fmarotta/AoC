function read_puzzle(file)
    ops = Dict()
    for l in eachline(file)
        rhs, lhs = eachsplit(l, ": ")
        ops[parse(Int, rhs)] = parse.(Int, eachsplit(lhs))
    end
    ops
end

function eval_op(rhs, lhs, res)
    if rhs < res
        return 0
    end
    if length(lhs) == 0
        if rhs == res
            return rhs
        else
            return 0
        end
    end
    res_plus = eval_op(rhs, lhs[2:end], res + lhs[1])
    res_times = eval_op(rhs, lhs[2:end], res * lhs[1])
    # For part1, remove res_concat
    res_concat = eval_op(rhs, lhs[2:end], res * 10^ndigits(lhs[1]) + lhs[1])
    return max(res_plus, res_times, res_concat)
end

function compute(ops)
    tot = 0
    for (rhs, lhs) in ops
        tot += eval_op(rhs, lhs[2:end], lhs[1])
    end
    tot
end

ops = read_puzzle(ARGS[1])
compute(ops) |> println
