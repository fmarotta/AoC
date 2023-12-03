#!/usr/bin/env julia

"""
say that name is drzm.
yells[drzm] = hmdt - zczc
yells[hmdt] = 32
yells[zczc] = 2
"""
function resolve(name, yells, resolutions)
    if !(name in keys(resolutions))
        strings = split(yells[name])[[begin, end]]
        variables = Meta.parse.(strings)
        operation = Meta.parse(yells[name])
        # println(variables)
        # println(yells[name])
        ex = quote
            $(variables[1]) = resolve($(strings[1]), $yells, $resolutions)
            $(variables[2]) = resolve($(strings[2]), $yells, $resolutions)
            $(operation)
        end
        # println(ex)
        # println(eval(ex))
        resolutions[name] = eval(ex)
    end
    return resolutions[name]
end

function invert_expression(lhs, rhs, pivot)
    # println(lhs, " = ", rhs)
    words = split(rhs)
    if pivot == 1
        other = 3
    else
        other = 1
    end
    op = words[2]
    newlhs = words[pivot]
    if lhs == "root"
        newrhs = words[other]
    else
        if op == "+"
            newrhs = "$lhs - $(words[other])"
        elseif op == "*"
            newrhs = "$lhs / $(words[other])"
        elseif op == "-"
            if pivot == 1
                newrhs = "$lhs + $(words[other])"
            else
                newrhs = "$(words[other]) - $lhs"
            end
        elseif op == "/"
            if pivot == 1
                newrhs = "$lhs * $(words[other])"
            else
                newrhs = "$(words[other]) / $lhs"
            end
        end
    end
    return newlhs, newrhs
end

function resolve_inverse!(name, yells, resolutions)
    # say we want to resolve ptdq: humn - dvpt for humn.
    # we'll replace this with humn: ptdq + dvpt.
    if !(name in keys(resolutions))
        for k in keys(yells)
            words = split(yells[k])
            if length(words) != 3
                continue
            end
            # println(words)
            if words[1] == name
                pivot = 1
            elseif words[3] == name
                pivot = 3
            else
                continue
            end
            println("resolving $name from $k = $(yells[k])")
            lhs, rhs = invert_expression(k, yells[k], pivot)
            println("expression inverted")
            delete!(yells, k)
            # resolve the new rhs
            newwords = split(rhs)
            println(newwords)
            if length(newwords) == 1
                println("doing nothing")
                # we've resolved humn up to root, we're done
                # break
            else
                println("resolving newhrs 1")
                println(newwords)
                resolve_inverse!(newwords[1], yells, resolutions)
                println("resolving newhrs 3")
                println(newwords)
                resolve_inverse!(newwords[3], yells, resolutions)
            end
            # add the current resolution to the yells
            # do it afterwards to avoid infinite loopback resolutions
            yells[lhs] = rhs
            println("breaking")
            break
        end
    end
end

# root must check that pppw == sjmn
# cczh / lfqf == drzm * dbpl
# (sllz + lgvd) / 4 == (hmdt - zczc) * 5
# (4 + (ljgn * ptdq)) / 4 == (32 - 2) * 5
# (4 + (2 * (humn - 3))) / 4 == (32 - 2) * 5


# ptdq = humn - dvpt
# human = ptdq + dvpt
# human = (lgvd / ljgn) + 3
# human = ((cczh - sllz) / 2) + 3
# human = (((pppw * lfqf) - 4) / 2) + 3
# human = (((sjmn * 4) - 4) / 2) + 3

# so... humn: 5 disappears; root: becomes 0 = pppw - sjmn;
# we have to invert the operations.

open("input.txt") do io
    yells = Dict()
    resolutions = Dict()
    for l in eachline(io)
        w = split(l, ": ")
        if (m = match(r"\d+", w[2])) != nothing
            resolutions[w[1]] = parse(Int, w[2])
        else
            yells[w[1]] = w[2]
        end
    end
    # println(yells)
    # println(resolutions)
    delete!(resolutions, "humn")
    resolve_inverse!("humn", yells, resolutions)
    # println(yells)
    # println(resolutions)

    println(Int(resolve("humn", yells, resolutions)))
end
