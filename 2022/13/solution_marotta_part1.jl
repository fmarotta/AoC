#!/usr/bin/env julia

function compare(a::Int, b::Vector; level=0)
    println(repeat(" ", level * 2), "- Compare $a vs $b")
    println(repeat(" ", (level + 1) * 2), "- Mixed types; convert left to [$a] and retry comparison")
    return compare([a], b, level=level + 1)
end

function compare(a::Vector, b::Int; level=0)
    println(repeat(" ", level * 2), "- Compare $a vs $b")
    println(repeat(" ", (level + 1) * 2), "- Mixed types; convert right to [$b] and retry comparison")
    return compare(a, [b], level=level + 1)
end

function compare(a::Int, b::Int; level=0)
    println(repeat(" ", level * 2), "- Compare $a vs $b")
    if a == b
        return missing
    else
        if a < b
            println(repeat(" ", (level + 1) * 2), "- Left side is smaller, so inputs are in the right order")
        else
            println(repeat(" ", (level + 1) * 2), "- Right side is smaller, so inputs are NOT in the right order")
        end
        return a < b
    end
end

function compare(a::Vector, b::Vector; level=0)
    println(repeat(" ", level * 2), "- Compare $a vs $b")
    level += 1
    for i in 1:length(a)
        if length(b) < i
            println(repeat(" ", level * 2), "- Right side ran out of items, so inputs are NOT in the right order")
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
        println(repeat(" ", level * 2), "- Left side ran out of items, so inputs are in the right order")
        return true
    end
end

function parse_packet(l)
    eval(Meta.parse("p = " * l))
    return p
end

open("test.txt", "r") do io
    stream = read(io, String)
    pairs = split(stream, "\n\n")
    packets = []
    for pair in pairs
        left, right = split(pair, "\n")
        push!(packets, (parse_packet(left), parse_packet(right)))
    end

    sum = 0
    for (i, (left, right)) in enumerate(packets)
        println("\n== Pair $i ==")
        outcome = compare(left, right)
        if outcome
            println("yes")
            sum += i
        else
            println("nope")
        end
    end
    println(sum)
end
