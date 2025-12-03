"""
Find maximum joltage in A[1:bound] by combining n elements
"""
function find_max_joltage(A, bound, n, memo = Dict())
    if n == 0 || bound - n < 0
        return 0
    end
    if !((bound, n) in keys(memo))
        memo[(bound, n)] = find_max_joltage(A, bound-1, n, memo)
        for i in 1:bound
            pick = A[i] + 10 * find_max_joltage(A, i-1, n-1, memo)
            if pick > memo[(bound, n)]
                memo[(bound, n)] = pick
            end
        end
    end
    return memo[(bound, n)]
end

function compute(file)
    part1 = 0
    part2 = 0
    for l in eachline(file)
        jolts = parse.(Int, split(l, ""))
        part1 += find_max_joltage(jolts, length(jolts), 2)
        part2 += find_max_joltage(jolts, length(jolts), 12)
    end
    println(part1)
    println(part2)
end

compute(ARGS[1])
