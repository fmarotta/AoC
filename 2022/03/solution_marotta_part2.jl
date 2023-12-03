#!/usr/bin/env julia

function char2index(c::Char)
    if 'A' <= c <= 'Z'
        return c - 'A' + 1 + 26
    elseif 'a' <= c <= 'z'
        return c - 'a' + 1
    else
        prinln("wrong input bro")
        return -1
    end
end

open("input.txt") do io
    priorities = 0
    elf_n = 0
    group_item_count = zeros(Int, 52)
    for rucksack = eachline(io)
        rucksack = chomp(rucksack)
        item_count = zeros(Int, 52)
        for item in rucksack
            index = char2index(item)
            if item_count[index] == 0
                item_count[index] = 1
            end
        end
        group_item_count .+= item_count
        if elf_n % 3 == 2
            for i in 1:length(group_item_count)
                if group_item_count[i] == 3
                    priorities += i
                    break
                end
            end
            group_item_count = zeros(Int, 52)
        end
        elf_n += 1
    end
    println(priorities)
end
