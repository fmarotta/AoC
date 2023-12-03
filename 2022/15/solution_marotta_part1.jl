#!/usr/bin/env julia

struct Sensor
    coord::NTuple{2, Int}
    closest_beacon::NTuple{2, Int}
    distance::Int
end

open("input.txt", "r") do io
    lines = readlines(io)
    sensors = map(lines) do l
        m = match(r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)", l)
        sensor_x, sensor_y, beacon_x, beacon_y = parse.(Int, m)
        distance = abs(sensor_x - beacon_x) + abs(sensor_y - beacon_y)
        Sensor((sensor_x, sensor_y), (beacon_x, beacon_y), distance)
    end

    target_y = 2_000_000
    no_beacon_positions = Set()
    for sensor in sensors
        println("Sensor coord: $(sensor.coord)")
        # let's see if this sensor intersects the y=10 line...
        if sensor.coord[2] - sensor.distance <= target_y <= sensor.coord[2] + sensor.distance
            # let's see how many x's are spanned by this sensor
            span = sensor.distance - abs(sensor.coord[2] - target_y)
            for i in (sensor.coord[1]-span):(sensor.coord[1]+span)
                push!(no_beacon_positions, (i, target_y))
            end
        end
    end
    # remove sensors and beacons
    for sensor in sensors
        if sensor.coord in no_beacon_positions
            pop!(no_beacon_positions, sensor.coord)
        end
        if sensor.closest_beacon in no_beacon_positions
            pop!(no_beacon_positions, sensor.closest_beacon)
        end
    end

    println(length(no_beacon_positions))
end