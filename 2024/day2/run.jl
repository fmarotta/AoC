function is_valid(report)
    diffs = report[2:end] .- report[1:end-1]
    if ! (all(sign.(diffs) .== 1) || all(sign.(diffs) .== -1))
        return false
    end
    if ! all(1 .<= abs.(diffs) .<= 3)
        return false
    end
    return true
end

function compute(file)
    part1 = 0
    part2 = 0
    for line in eachline(file)
        report = parse.(Int, split(line))
        if is_valid(report)
            part1 += 1
            part2 += 1
            continue
        end
        for i in eachindex(report)
            abridged_report = vcat(report[1:i-1], report[i+1:end])
            if is_valid(abridged_report)
                part2 += 1
                break
            end
        end
    end
    println(part1)
    println(part2)
end

compute(ARGS[1])
