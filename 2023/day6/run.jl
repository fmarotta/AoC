function read_puzzle(file)
    open(file, "r") do io
        times = parse.(Int, split(readline(io))[2:end])
        distances = parse.(Int, split(readline(io))[2:end])
    return times, distances
    end
end

function solve_quadratic(t, d)
    # distance = holding_time * (duration - holding_time)
    return (
        (t - sqrt(t^2 - 4d)) / 2,
        (t + sqrt(t^2 - 4d)) / 2
    )
end

rfloor(x) = floor(x) == x ? x - 1 : floor(x)
rceil(x) = ceil(x) == x ? x + 1 : ceil(x)

function compute(times, distances)
    res = 1
    for i in 1:length(times)
        time = times[i]
        distance = distances[i]
        # We have to solve x * (t - x) > d
        # x^2 - t x + d < 0
        x1, x2 = solve_quadratic(time, distance)
        res *= (rfloor(x2) - rceil(x1) + 1)
    end
    return Int(res)
end

times, distances = read_puzzle("input")
println(compute(times, distances))
println(compute(
    parse(Int, join(times, "")),
    parse(Int, join(distances, ""))
))
