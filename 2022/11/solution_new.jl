#!/usr/bin/env julia

const n_monkeys = 8

mutable struct Monkey
    bag::Vector{Vector{Int}}
    worry::Function
    decision::NTuple{3, Int}
    inspection_count::Int
end

function decide_recipient(m::Monkey, i::Int)
    if m.bag[1][i] % m.decision[1] == 0
        return m.decision[2]
    else
        return m.decision[3]
    end
end

monkeys = open("input.txt", "r") do io
    monkeys = Monkey[]
    while true
        _ = readline(io)
        starting_items = match(r"  Starting items: (.*)", readline(io))
        operation = match(r"  Operation: new = (.*)", readline(io))
        test = match(r"  Test: divisible by (.*)", readline(io))
        if_true = match(r"    If true: throw to monkey (.*)", readline(io))
        if_false = match(r"    If false: throw to monkey (.*)", readline(io))
        _ = readline(io)

        bag = [[i for _ in 1:n_monkeys] for i in parse.(Int, split(starting_items[1], ", "))]
        # this works, but not in the way I want...
        function worry(old, dividend)
            terms = split(replace(operation[1], "old" => "$old"))
            opr1 = Expr(:call, :%, Meta.parse(terms[1]), dividend)
            opr2 = Expr(:call, :%, Meta.parse(terms[3]), dividend)
            # opr1 = Meta.parse(terms[1])
            # opr2 = Meta.parse(terms[3])
            return Expr(:call, Symbol(terms[2]), opr1, opr2)
        end
        decision = parse.(Int, (test[1], if_true[1], if_false[1]))
        push!(monkeys, Monkey(bag, worry, decision, 0))

        if eof(io)
            break
        end
    end
    monkeys
end

dividends = [m.decision[1] for m in monkeys]
for round in 1:10000
    println(round)
    for (i, monkey) in enumerate(monkeys)
        while length(monkey.bag) > 0
            monkey.inspection_count += 1
            # apply worry
            monkey.bag[1] = eval.(monkey.worry.(monkey.bag[1], dividends))
            # apply test
            throw_to = decide_recipient(monkey, i)
            # throw item
            push!(monkeys[throw_to + 1].bag, popat!(monkey.bag, 1))
        end
    end
end

println(prod(big.(sort([m.inspection_count for m in monkeys], rev = true)[1:2])))

