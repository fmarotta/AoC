function get_calibration_numbers_part1(file)
    numbers = []
    for l in eachline(file)
        digit = ""
        for c in l
            if isdigit(c)
                digit *= c
            end
        end
        push!(numbers, parse(Int, digit[1:1] * digit[end:end]))
    end
    return numbers
end

function get_calibration_numbers_part2(file)
    numbers = []
    spells = [
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine",
    ]
    for l in eachline(file)
        pos = 1
        digits = ""
        while pos <= length(l)
            found_spell = false
            for (i, spell) in enumerate(spells)
                if length(l) >= pos + length(spell) - 1 && l[pos:pos+length(spell)-1] == spell
                    digits *= "$(i),"
                    found_spell = true
                    # first mistake: numbers CAN overlap...
                    # pos += length(r)
                    break
                end
            end
            if found_spell == false && isdigit(l[pos])
                digits *= "$(l[pos]),"
                # pos += 1
            end
            pos += 1
        end
        digits = split(digits, ",")
        # second mistake: if there's only one digit, it's repeated!
        # if length(digits) == 2
        #     firstlast = firstlast[1] * first
        # else
            firstlast = digits[1] * digits[end-1]
        # end
        push!(numbers, parse(Int, firstlast))
    end
    return numbers
end

p1 = get_calibration_numbers_part1("input")
println(sum(p1))

p2 = get_calibration_numbers_part2("input")
println(sum(p2))
