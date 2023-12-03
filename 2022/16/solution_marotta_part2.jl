#!/usr/bin/env julia

"""
What can happen?
I open A, ele opens B
    I open C, ele opens D
        I open E, ele opens F
            I open G, ele opens H  # at this point there are I, J, and nothing left
                I open I, ele opens J
                    Nothing more to open, compute score
                I open I, ele opens nothing  # J and nothing left
                    I open J, ele opens nothing
                        Nothing more to open, compute score
                I open J, ele opens I
                    Nothing more to open, compute score
                I open J, ele opens nothing
                    I open I, ele opens nothing
                        Nothing more to open, compute score
                I open nothing, ele opens I
                    I open nothing, ele opens J
                        Nothing more to open, compute score
                I open nothing, ele opens J
                    I open nothing, ele opens I
                        Nothing more to open, compute score
                I open I, ele opens nothing
            I open G, ele opens I
            I open G, ele opens J
        I open E, ele opens G
        I open E, ele opens H
        I open E, ele opens I
        I open E, ele opens J
    I open C, ele opens E
    I open C, ele opens F
    I open C, ele opens G
    I open C, ele opens H
    I open C, ele opens I
    I open C, ele opens J
    I open D, ele opens E
    I open D, ele opens F
    I open D, ele opens G
    I open D, ele opens H
    I open D, ele opens I
    I open D, ele opens J
I open A, ele opens C
I open A, ele opens D
I open A, ele opens E
I open A, ele opens F
I open A, ele opens G
I open A, ele opens H
I open A, ele opens I
I open A, ele opens J
I open A, ele opens Nothing
I open B, ele opens C
I open B, ele opens D
I open B, ele opens E
I open B, ele opens F
I open B, ele opens G
I open B, ele opens H
I open B, ele opens I
I open B, ele opens J
"""

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
    for cur in keys(adjlist)
        q = []
        visited = Set()
        dist[cur] = Dict()
        dist[cur][cur] = 1
        probe = cur
        push!(q, probe)
        while length(q) > 0
            probe = popfirst!(q)
            push!(visited, probe)
            for i in adjlist[probe]
                if i in visited
                    continue
                end
                push!(q, i)
                if ! (i in keys(dist[cur]))
                    dist[cur][i] = dist[cur][probe] + 1
                elseif dist[cur][probe] + 1 < dist[cur][i]
                    dist[cur][i] = dist[cur][probe] + 1
                end
            end
        end
    end
    println(dist)
    valves = Set([k for k in keys(rates) if rates[k] > 0])
    println(valves)

    cur = "AA"

    function get_max_pressure()
        # at each turn, we follow the available options for
        # me and the elephant.
    end

    # open_human = []
    # open_elephant = []
    # explore = function(open_human, open_elephant)
    #     for human_valve in setdiff(valves, union(open_human, open_elephant))
    #         new_open_human = union(open_human, [human_valve])
    #         for elephant_valve in setdiff(valves, union(open_human, open_elephant))
    #             println("human opens $human_valve, elephant opens $elephant_valve")
    #             new_open_elephant = union(open_elephant, [elephant_valve])
    #             explore(new_open_human, new_open_elephant)
    #         end
    #     end
    # end
    # explore(Set(), Set())
    # return

    function get_max_score(cur_me, cur_elephant, time_me, time_elephant, pressure = 0, opened=[])
        # println(cur_me, cur_elephant, time_me, time_elephant)
        if length(opened) == length(keys(adjlist))
            # we've already opened everything
            return pressure
        end
        println(length(opened))
        if length(opened) == length(keys(adjlist)) - 1
            #everything except one is open. it doesn't make
            # sense to check all combinations, just one can take it
            println("maybe")
        end
        if time_me <= 0 && time_elephant <= 0
            # we can't open this
            return pressure
        elseif time_me <= 0
            time_me = 0
        elseif time_elephant <= 0
            time_elephant = 0
        end
        if cur_me in opened && cur_elephant in opened
            # println("we previously already opened $i)")
            return pressure
        elseif cur_me in opened
            time_me = 0
        elseif cur_elephant in opened
            time_elephant = 0
        end
        # println("visiting $cur")
        push!(opened, cur_me, cur_elephant)
        dist_me = dist[cur_me]
        dist_elephant = dist[cur_elephant]

        # the total pressure is given by the pressure released now
        # plus the pressure released if we follow each path
        newpressure = pressure + rates[cur_me] * time_me + rates[cur_elephant] * time_elephant
        maxpressure = newpressure
        for i_me in worthy
            # we decide to open i, what happens?
            newtime_me = time_me - dist_me[i_me]
            for i_elephant in worthy
                if i_elephant == i_me
                    continue
                end
                newtime_elephant = time_elephant - dist_elephant[i_elephant]
                nextpressure = get_max_score(i_me, i_elephant, newtime_me, newtime_elephant, newpressure, copy(opened))
                if nextpressure > maxpressure
                    maxpressure = nextpressure
                end
            end
        end
        # println(maxpressure)
        return maxpressure
    end

    maxscore = get_max_score(cur, cur, 26, 26, 0, [])
    println(maxscore)


end
