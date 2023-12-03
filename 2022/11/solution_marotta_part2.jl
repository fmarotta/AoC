#!/usr/bin/env julia

# one worry follows the following fate.
# 79 is the initial value.
# it gets multiplied by 19, resulting in 1501.
# then, we take mod 23, which is 6.
# we pass this to monkey 3.
# it is increased by 3 to 1504
# then, we take mod 17, which is 8
# So I had to do (79 * 19) + 3 mod 8, which is equal to (79*19 mod 8 + 3 mod 8) mod 8
# which is equal to ((79 mod 8 * 19 mod 8) mod 8 + 3 mod 8) mod 8
# which is equal to (79 mod 8 * 19 mod 8 + 3 mod 8) mod 8
#
# attack plan: store a list of operations and a list of operands. apply mod to each operand. do the operations. take the mod.
# operations should store what? an Expr. nested or not? nah, linear, so we can iterate over it.

mutable struct Monkey
    bag::Vector{Expr}
    operation::AbstractString
    test::NTuple{3, Int}
    inspection_count::Int
end

addtobag! = function(m::Monkey, old::Expr)
    # we have to store f(old)
    # for example, this monkey's operation is old * 19.
    # the old item is already Expr(:call, :+, :old, 3)
    # so we need to do push!(bag, Expr(:call, :*, 19, old))
    expr = Meta.parse(replace(m.operation, "old" => "($old)"))
    push!(m.bag, expr) 
end

decide = function(m::Monkey)
    ex = m.bag[1]
    s = replace(string(ex), r"(\d+)" => s"mod(\1, @)")
    s = replace(s, "@" => m.test[1])
    a = eval(Meta.parse(s))
    if a % m.test[1] == 0
        return m.test[2]
    else
        return m.test[3]
    end
end

monkeys = open("test.txt", "r") do io
    monkeys::Vector{Monkey} = []
    while true
        _ = readline(io)  # discard the monkey number
        items = match(r"  Starting items: (.*)", readline(io))
        operation = match(r"  Operation: new = (.*)", readline(io))
        dividend = match(r"  Test: divisible by (.*)", readline(io))
        if_true= match(r"    If true: throw to monkey (.*)", readline(io))
        if_false= match(r"    If false: throw to monkey (.*)", readline(io))
        test = (
            parse(Int, dividend[1]),
            parse(Int, if_true[1]),
            parse(Int, if_false[1])
        )
        initial_items = parse.(Int, split(items[1], ", "))
        bag = [Meta.parse(replace(operation[1], "old" => "($old)")) for old in initial_items]
        push!(monkeys, Monkey(bag, operation[1], test, 0))
        if eof(io)
            break
        else
            _ = readline(io)  # discard the empty line
        end
    end
    monkeys
end

for round in 1:1000
    if round % 1000 == 0
        println("== After round $round ==")
    end
    for monkey in monkeys
        if round % 1000 == 0
            println("New monkey")
        end
        while length(monkey.bag) > 0
            monkey.inspection_count += 1
            if round % 1000 == 0
                println("  Monkey inspects an item with a worry level of $(monkey.bag[1]).")
            end
            # apply test
            throw_to = decide(monkey)
            if round % 1000 == 0
                println("    Monkey will throw to $(throw_to)")
            end
            # throw item
            addtobag!(monkeys[throw_to + 1], popat!(monkey.bag, 1))
        end
    end
end

println([m.inspection_count for m in monkeys])
# println(prod(sort([m.inspection_count for m in monkeys], rev = true)[1:2]))
