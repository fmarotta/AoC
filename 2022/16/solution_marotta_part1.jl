#!/usr/bin/env julia

open("input.txt", "r") do io
    # each time we move to the max, which is -curr distance + its rate
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

    a = 0
    function get_max_score(cur, time=30, opened=[])
        a += 1
        if time <= 0
            # we can't open this
            return 0
        end
        if cur in opened
            # println("we previously already opened $i)")
            return 0
        end
        # println("visiting $cur")
        push!(opened, cur)

        # the total pressure is given by the pressure released now
        # plus the pressure released if we follow each path
        newpressure = rates[cur] * time
        maxpressure = newpressure
        for i in openable_valves
            # we decide to open i, what happens?
            newtime = time - dist[cur][i]
            nextpressure = newpressure + get_max_score(i, newtime, copy(opened))
            if nextpressure > maxpressure
                maxpressure = nextpressure
            end
        end
        # println(maxpressure)
        return maxpressure
    end

    maxscore = get_max_score("AA", 30, [])
    println(maxscore)
    println("we checked $a possibilities")
end
