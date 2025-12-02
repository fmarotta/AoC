function compute(file)
    l = readline(file)
    part1 = 0
    part2 = 0
    for s in eachsplit(l, ",")
        start, finish = parse.(Int, split(s, "-"))
        for n in start:finish
            m1 = match(r"^(.*)\1$", string(n))
            m2 = match(r"^(.*)\1+$", string(n))
            if m1 !== nothing
                part1 += n
            end
            if m2 !== nothing
                part2 += n
            end
        end
    end
    println(part1)
    println(part2)
end

compute(ARGS[1])
