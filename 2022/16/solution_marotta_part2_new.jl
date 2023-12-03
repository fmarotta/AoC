#!/usr/bin/env julia

open("input.txt", "r") do io
    adjlist = Dict()
    rates = Dict()
    for l in eachline(io)
        words = split(l)
        valve = words[2]
        flow = parse(Int, replace(split(words[5], "=")[2], ";" => ""))
        rates[valve] = flow
        neighbours = split(join(words[10:end], ""), ",")
        adjlist[valve] = neighbours
    end

    dist = Dict()
    for valve in keys(adjlist)
        visited = Set()
        dist[valve] = Dict()
        dist[valve][valve] = 1
        q = [valve]
        while length(q) > 0
            cur = popfirst!(q)
            push!(visited, cur)
            for neighbour in adjlist[cur]
                if ! (neighbour in keys(dist[valve])) || dist[valve][neighbour] > dist[valve][cur] + 1
                    dist[valve][neighbour] = dist[valve][cur] + 1
                end
                if !(neighbour in visited)
                    push!(q, neighbour)
                end
            end
        end
    end
    println(dist)

    openable_valves = [k for k in keys(rates) if rates[k] > 0]
    println("there are $(length(openable_valves)) openable valves.")

    a = 0
    path = []
    function get_max_score(cur, time, valves)
        a += 1
        if time <= 0
            # we can't open this
            return 0
        end
        # println("visiting $cur")
        newvalves = [v for v in valves if v != cur]

        # the total pressure is given by the pressure released now
        # plus the pressure released if we follow each path
        maxpressure = 0
        for i in newvalves
            # we decide to open i, what happens?
            newpressure = get_max_score(i, time - dist[cur][i], newvalves)
            if newpressure > maxpressure
                maxpressure = newpressure
            end
        end
        # println(maxpressure)
        return rates[cur] * time + maxpressure
    end

    cur_me = "AA"
    time_me = 26
    cur_elephant = "AA"
    time_elephant = 26
    # maxscore = get_max_score("AA", 30, openable_valves)
    # println(maxscore)
    # println("we checked $a possibilities")
    
    # split the openable valves between elephant and me
    maxscore = 0
    for s in 0:2^length(openable_valves)-1
        partition = parse.(Bool, collect(bitstring(s)[end - length(openable_valves) + 1:end]))
        my_valves = openable_valves[partition]
        elephant_valves = openable_valves[.!partition]
        if s % 1000 == 0
            println(s)
            println("I'm checking $(length(my_valves))")
            println("Elephant's checking $(length(elephant_valves))")
        end
        this_score = get_max_score("AA", 26, my_valves) + get_max_score("AA", 26, elephant_valves)
        if this_score > maxscore
            maxscore = this_score
        end
    end
    println(maxscore)


    # score = 0
    # alternate_decision = function(cur_me, cur_elephant, time_me, time_elephant, opened=[])
    #     who = nothing
    #     next = nothing
    #     max_score = 0
    #     if length(opened) >= length(openable_valves)
    #         return
    #     end
    #     for i in openable_valves
    #         max_score_me = get_max_score(i, time_me - dist[cur_me][i], copy(opened))
    #         println("if I open $i, the max score is $max_score_me")
    #         if max_score_me > max_score
    #             who = "me"
    #             next = i
    #             max_score = max_score_me
    #         end
    #
    #         max_score_elephant = get_max_score(i, time_elephant - dist[cur_elephant][i], copy(opened))
    #         println("if the friggin elephant opens $i, the max score is $max_score_elephant")
    #         if max_score_elephant > max_score
    #             who = "elephant"
    #             next = i
    #             max_score = max_score_elephant
    #         end
    #     end
    #     println("$who should open $next")
    #     if who == "me"
    #         time_me = time_me - dist[cur_me][next]
    #         cur_me = next
    #         score += rates[cur_me] * time_me
    #     elseif who == "elephant"
    #         time_elephant = time_elephant - dist[cur_elephant][next]
    #         cur_elephant = next
    #         score += rates[cur_elephant] * time_elephant
    #     end
    #     alternate_decision(cur_me, cur_elephant, time_me, time_elephant, vcat(opened, next))
    # end

    # alternate_decision(cur_me, cur_elephant, time_me, time_elephant)

    # maxscore = get_max_score("AA", 30, [])
    # println(maxscore)
    # println("we checked $a possibilities")
    # println("the best path is $path")
end
