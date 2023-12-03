#!/usr/bin/env julia

struct Sensor
    coord::NTuple{2, Int}
    closest_beacon::NTuple{2, Int}
    distance::Int
end

within_range(p, s::Sensor) = abs(p[1] - s.coord[1]) + abs(p[2] - s.coord[2]) <= s.distance

open("input.txt", "r") do io
    lines = readlines(io)
    sensors = map(lines) do l
        m = match(r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)", l)
        sensor_x, sensor_y, beacon_x, beacon_y = parse.(Int, m)
        distance = abs(sensor_x - beacon_x) + abs(sensor_y - beacon_y)
        Sensor((sensor_x, sensor_y), (beacon_x, beacon_y), distance)
    end

    limits = (0, 4_000_000)
    excluded = Set()
    for s in sensors
        println("Sensor coord: $(s.coord)")
        edge_span = s.distance + 1
        for h in -edge_span:edge_span
            if limits[1] <= s.coord[2] + h <= limits[2]
                for w in [-(edge_span - abs(h)), edge_span - abs(h)]
                    if limits[1] <= s.coord[1] + w <= limits[2]
                        # this point is at the edge
                        probe = s.coord .+ (w, h)
                        if probe in excluded
                            continue
                        end
                        flag = true
                        for s2 in sensors
                            if within_range(probe, s2)
                                flag = false
                                break
                            end
                        end
                        if flag
                            # we found it!
                            println(probe[1] * 4_000_000 + probe[2])
                            return probe[1] * 4_000_000 + probe[2]
                        end
                        push!(excluded, probe)
                    end
                end
            end
        end
    end
end