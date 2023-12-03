#!/usr/bin/env julia

function one_contains_other(a, b)
    a[1] >= b[1] && a[2] <= b[2] || b[1] >= a[1] && b[2] <= a[2]
end

open("input.txt", "r") do io
    contained_count = 0
    for assignment in eachline(io)
        first_elf, second_elf = split(assignment, ',')
        first_range = split(first_elf, '-')
        second_range = split(second_elf, '-')
        first_range_int = similar(first_range, Int)
        for i in 1:length(first_range)
            first_range_int[i] = parse(Int, first_range[i])
        end
        second_range_int = similar(second_range, Int)
        for i in 1:length(second_range)
            second_range_int[i] = parse(Int, second_range[i])
        end
        if one_contains_other(first_range_int, second_range_int)
            contained_count += 1
        end
    end
    println(contained_count)
end
