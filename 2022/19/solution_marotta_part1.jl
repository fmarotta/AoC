#!/usr/bin/env julia

# Resources:
# - Ore
# - Clay
# - Obsidian

# - Geode

function match_costs(sentence)
    costs = []
    for resource in ["ore", "clay", "obsidian", "geode"]
        cost = match(Regex("(\\d) $resource"), sentence)
        if cost == nothing
            push!(costs, 0)
        else
            push!(costs, parse(Int, cost[1]))
        end
    end
    return costs
end

function make_robots(choice, costs, resources)
    final = copy(resources)
    for (i, b) in enumerate(choice)
        if !b
            continue
        end
        final .-= costs[i, :]
    end
    return final
end

# say, we have a b c d resources, and the bot costs
# w x y z. We already have r s t u robots.
# if a b c d - w x y z .>= 0 we can do it immediately, else
# we have to solve the system
# t * r + b * s + c
# say, we have a b c d resources, and the bot costs
# w x y z. We already have r s t u robots.
# if a b c d - w x y z .>= 0 we can do it immediately, else
# we have to solve the system
# all(o*r o*s o*t o*u + a b c d - w x y z) >= 0
# so o >= max(w x y z - a b c d) / r s t u)
function time_to_wait(resources, robots, cost)
    res = resources[cost .> 0]
    bots = robots[cost .> 0]
    c = cost[cost .> 0]
    return max(1, ceil(maximum((c .- res) ./ bots)))
end

# resources: [ore amount, clay amount, obsidian amount, geode amount]
# robots: [ore robots amount, clay robots amount, obsiidan, geode]
simulate = function(resources, robots, time, costs)
    # println("We start with $resources resources and $robots robots")
    # println("We have $time minutes left")
    # we have to choose the action that results in the greatest
    # number of geodes
    if time <= 0
        return 0
    end

    # we try all possible choices for what we can do next
    max = 0
    for i in ["0000", "0001", "0010", "0100", "1000"]
        choice = parse.(Bool, collect(i))

        # calculate when we'll be able to implement this choice
        if i == "0000"
            minutes = 1
        else
            minutes = time_to_wait(resources, robots, vec(costs[choice, :]))
        end
        if minutes == Inf
            # we can't possibly make this robot because of a dependency
            continue
        end

        println("We want to make $i. We wait for $minutes minutes")

        # robots produce
        println(robots)
        println(Int(minutes) * robots)
        newresources = resources .+ (Int(minutes) * robots)
        println("Robots produce their resources, we now have $newresources")

        # println("time is $time, choice is $choice")
        final_resources = make_robots(choice, costs, newresources)
        if any(x -> x < 0, final_resources)
            # println("can't make this")
            continue
        end
        # if i != 0
        #     println("at time $time and choice $i")
        #     println("we decide to build robots")
        #     println("after making robots, we have $final_resources.")
        # end
        new = simulate(final_resources, robots .+ choice, time - minutes, costs)
        if new > max
            max = new
        end
        max += newresources[4]
    end
    # what we make in this turn + the maximum that we can get from
    # all possibilities
    return max
end

open("test.txt", "r") do io
    # costs[blueprint_id][ore..clay..obsidian..geode][
    cost_matrix = []
    for blueprint in eachline(io)
        # Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
        cost = zeros(Int, 4, 4)
        sentences = split(blueprint, ".")
        push!(cost_matrix, vcat([match_costs(s)' for s in sentences if s != ""]...))
    end
    println(cost_matrix)
    println(simulate([0, 0, 0, 0], [1, 0, 0, 0], 24, cost_matrix[1]))
end
