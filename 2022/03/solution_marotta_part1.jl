#!/usr/bin/env julia

function char2index(c::Char)
    if 'A' <= c <= 'Z'
        return c - 'A' + 1 + 26
    elseif 'a' <= c <= 'z'
        return c - 'a' + 1
    else
        prinln("wrong input bro")
        return nothing
    end
end

open("input.txt") do io
    priorities = 0
    for rucksack = eachline(io)
        rucksack = chomp(rucksack)
        first_compartment = rucksack[begin:Int(length(rucksack) / 2)]
        second_compartment = rucksack[(Int(length(rucksack) / 2) + 1):end]
        item_count = zeros(Bool, 52)
        for item in first_compartment
            index = char2index(item)
            if !item_count[index]
                item_count[index] = true
            end
        end
        for item in second_compartment
            index = char2index(item)
            if item_count[index]
                priorities += index
                break
            end
        end
    end
    println(priorities)
end
