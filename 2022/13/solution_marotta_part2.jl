#!/usr/bin/env julia

function compare(a::Int, b::Vector; level=0)
    # println(repeat(" ", level * 2), "- Compare $a vs $b")
    # println(repeat(" ", (level + 1) * 2), "- Mixed types; convert left to [$a] and retry comparison")
    return compare([a], b, level=level + 1)
end

function compare(a::Vector, b::Int; level=0)
    # println(repeat(" ", level * 2), "- Compare $a vs $b")
    # println(repeat(" ", (level + 1) * 2), "- Mixed types; convert right to [$b] and retry comparison")
    return compare(a, [b], level=level + 1)
end

function compare(a::Int, b::Int; level=0)
    # println(repeat(" ", level * 2), "- Compare $a vs $b")
    if a == b
        return missing
    else
        if a < b
    #         println(repeat(" ", (level + 1) * 2), "- Left side is smaller, so inputs are in the right order")
        else
    #         println(repeat(" ", (level + 1) * 2), "- Right side is smaller, so inputs are NOT in the right order")
        end
        return a < b
    end
end

function compare(a::Vector, b::Vector; level=0)
    # println(repeat(" ", level * 2), "- Compare $a vs $b")
    level += 1
    for i in 1:length(a)
        if length(b) < i
    #         println(repeat(" ", level * 2), "- Right side ran out of items, so inputs are NOT in the right order")
            return false
        end
        if (res = compare(a[i], b[i], level=level)) !== missing
            return res
        end
    end
    # if we are here, either b is longer than a or it's the same size.
    if length(b) == length(a)
        return missing
    else
    #     println(repeat(" ", level * 2), "- Left side ran out of items, so inputs are in the right order")
        return true
    end
end

function parse_packet(l)
    eval(Meta.parse("p = " * l))
    return p
end


function qsort!(A, lo=1, hi=length(A))
    if lo >= hi
        return
    end
    # println("Qsorting A from $lo to $hi")
    pivot = hi
    j = lo
    for i in lo:hi
        # println("Comparing $(A[i]) vs $(A[pivot])")
        if i == pivot
            outcome = true
        else
            outcome = compare(A[i], A[pivot])
        end
        # println(outcome)
        if outcome
            A[j], A[i] = A[i], A[j]
            j += 1
        end
    end
    qsort!(A, lo, j - 2)
    qsort!(A, j, hi)
end

open("input.txt", "r") do io
    stream = read(io, String)
    lines = split(stream, "\n")
    filter!(x -> x != "", lines)
    push!(lines, "[[2]]", "[[6]]")
    packets = parse_packet.(lines)
    qsort!(packets)
    indices = zeros(Int, 2)
    for (i, p) in enumerate(packets)
        if compare(p, [[2]]) === missing
            indices[1] = i
        elseif compare(p, [[6]]) === missing
            indices[2] = i
        end
    end
    println(prod(indices))
end
