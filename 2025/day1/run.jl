function compute(file)
    dial = 50
    part1 = 0 # times that the dial points to zero AFTER a rotation
    part2 = 0 # times that the dial points to zero DURING a rotation
    for l in eachline(file)
        prev = dial
        dir = l[1]
        n = parse(Int, l[2:end])
        if dir == 'L'
            dial -= n
        else
            dial += n
        end
        incr, dial = fldmod(dial, 100)
        if dial == 0
            part1 += 1
        end
        if incr > 0 && dial == 0
            incr -= 1
        elseif incr < 0 && prev == 0
            incr += 1
        end
        part2 += abs(incr)
    end
    println(part1)
    println(part2 + part1)
end

compute(ARGS[1])
