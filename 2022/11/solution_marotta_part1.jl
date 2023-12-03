#!/usr/bin/env julia

mutable struct Monkey
    bag::Vector{Int}
    operation::AbstractString
    decide_next::Function
    inspection_count::Int
end

function worry!(m::Monkey, i::Int)
    old = m.bag[i]
    op = Meta.parse(replace(m.operation, "old" => "$old"))
    eval(op)
    m.bag[i] = new
end

monkeys = open("input.txt", "r") do io
    monkeys = []
    while true
        _ = readline(io)  # discard the monkey number
        items = match(r"  Starting items: (.*)", readline(io))
        operation = match(r"  Operation: (.*)", readline(io))
        test = match(r"  Test: divisible by (.*)", readline(io))
        if_true= match(r"    If true: throw to monkey (.*)", readline(io))
        if_false= match(r"    If false: throw to monkey (.*)", readline(io))
        bag = parse.(Int, split(items.captures[1], ", "))
        make_decision = function(dividend, if_true, if_false)
            dividend = parse(Int, dividend)
            if_true = parse(Int, if_true)
            if_false = parse(Int, if_false)
            return function(i)
                if i % dividend == 0
                    return if_true
                else
                    return if_false
                end
            end
        end
        push!(monkeys, Monkey(bag, operation.captures[1], make_decision(test[1], if_true[1], if_false[1]), 0))
        if eof(io)
            break
        else
            _ = readline(io)  # discard the empty line
        end
    end
    monkeys
end

for round in 1:20
    for monkey in monkeys
        println("New monkey")
        while length(monkey.bag) > 0
            monkey.inspection_count += 1
            println("  Monkey inspects an item with a worry level of $(monkey.bag[1]).")
            # apply operation
            worry!(monkey, 1)
            println("    Worry level is now $(monkey.bag[1]).")
            # apply boredom
            monkey.bag[1] = floor(monkey.bag[1] / 3)
            println("    Monkey gets bored, worry level is now $(monkey.bag[1]).")
            # apply test
            throw_to = monkey.decide_next(monkey.bag[1])
            println("    Monkey will throw to $(throw_to)")
            # throw item
            push!(monkeys[throw_to + 1].bag, popat!(monkey.bag, 1))
            println("done")
        end
    end
end

println(prod(sort([m.inspection_count for m in monkeys], rev = true)[1:2]))
