#!/usr/bin/env julia

solution = let elf_calories = 0, max_elf_calories = 0
    for i = eachline()
        if (i == "")
            if (elf_calories > max_elf_calories)
                max_elf_calories = elf_calories
            end
            elf_calories = 0
        else
            elf_calories += parse(Int, i)
        end
    end
    max_elf_calories
end

println(solution)
