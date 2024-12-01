function read_puzzle(file)
    l1 = []
    l2 = []
    for l in readlines(file)
        n1, n2 = split(l)
        push!(l1, parse(Int, n1))
        push!(l2, parse(Int, n2))
    end
    l1, l2
end

function part1(l1, l2)
    return sum(abs.(sort(l1) .- sort(l2)))
end

function part2(l1, l2)
    s = 0
    for n1 in l1
        s += n1 * count(isequal(n1), l2)
    end
    return s
end

l1, l2 = read_puzzle(ARGS[1])
println(part1(l1, l2))
println(part2(l1, l2))
