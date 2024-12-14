"Print a matrix"
function pm(m, sep = " ")
    println.(join.(eachrow(m), sep))
    nothing
end

const dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]

function read_puzzle(file)
    p = []
    v = []
    for l in eachline(file)
        px, py, vx, vy = match(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)", l)
        push!(p, [parse(Int, px), parse(Int, py)])
        push!(v, (parse(Int, vx), parse(Int, vy)))
    end
    p, v
end

function count_quadrants(p, room)
    quads = zeros(Int, 4)
    for robot in p
        if robot[1] < room[1] ÷ 2 && robot[2] < room[2] ÷ 2
            quads[1] += 1
        elseif robot[1] > room[1] ÷ 2 && robot[2] > room[2] ÷ 2
            quads[2] += 1
        elseif robot[1] < room[1] ÷ 2 && robot[2] > room[2] ÷ 2
            quads[3] += 1
        elseif robot[1] > room[1] ÷ 2 && robot[2] < room[2] ÷ 2
            quads[4] += 1
        end
    end
    prod(quads)
end

function components(p, room)
    occupied = Set(Tuple.(p))
    Q = [(1, 1)]
    visited = Set(Q)
    while length(Q) > 0
        cur = popfirst!(Q)
        for dir in dirs
            if all(0 .<= cur .+ dir .< room) && !(cur .+ dir in visited) && !(cur .+ dir in occupied)
                push!(visited, cur .+ dir)
                push!(Q, cur .+ dir)
            end
        end
    end
    outside = length(visited)
    inside = prod(room) - length(occupied) - length(visited)
    if min(inside, outside) > 50
        m = fill('.', room)
        for robot in p
            m[(robot.+1)...] = '#'
        end
        pm(permutedims(m), "")
        return true
    end
    return false
end

function simulate!(p, v)
    room = (101, 103)
    for t in 1:prod(room)
        for robot in eachindex(p)
            @. p[robot] += v[robot]
            @. p[robot] = mod(p[robot], room)
        end
        if t == 100
            p1 = count_quadrants(p, room)
            println("Part 1: $p1")
        end
        if components(p, room)
            print("Is this a Christmas tree? [y/N]")
            if startswith(readline(), "y")
                println("Part 2: $t")
                break
            end
        end
    end
end

p, v = read_puzzle(ARGS[1])
simulate!(p, v)
