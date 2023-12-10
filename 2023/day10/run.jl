function read_puzzle(file)
    # place '.' all around the maze
    l = readlines(file)
    maze = [l[i][j] for i in 1:length(l), j in 1:length(l[1])]
    maze = vcat(
        permutedims(repeat(['.'], size(maze, 2))),
        maze,
        permutedims(repeat(['.'], size(maze, 2))),
    )
    maze = hcat(
        repeat(['.'], size(maze, 1)),
        maze,
        repeat(['.'], size(maze, 1)),
    )
    return maze
end

function replace_start!(maze)
    dirs = Dict(
        '|' => [(-1, 0), (1, 0)],
        '-' => [(0, -1), (0, 1)],
        'L' => [(-1, 0), (0, 1)],
        'J' => [(-1, 0), (0, -1)],
        '7' => [(1, 0), (0, -1)],
        'F' => [(1, 0), (0, 1)],
        '.' => [],
    )
    start = Tuple(findfirst(isequal('S'), maze))
    start_type = Set(['|', '-', 'L', 'J', '7', 'F'])
    for dir in [(-1, 0), (0, 1), (1, 0), (0, -1)]
        if ! ((.-dir) in dirs[maze[(start .+ dir)...]])
            # we cannot come back
            for (k, v) in dirs
                if dir in v
                    delete!(start_type, k)
                end
            end
        end
    end
    maze[start...] = collect(start_type)[1]
    return start
end

"""
| is a vertical pipe connecting north and south.
- is a horizontal pipe connecting east and west.
L is a 90-degree bend connecting north and east.
J is a 90-degree bend connecting north and west.
7 is a 90-degree bend connecting south and west.
F is a 90-degree bend connecting south and east.
. is ground; there is no pipe in this tile.
S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
"""
function compute(maze, start)
    loop = zeros(Bool, size(maze))
    dirs = Dict(
        '|' => [(-1, 0), (1, 0)],
        '-' => [(0, -1), (0, 1)],
        'L' => [(-1, 0), (0, 1)],
        'J' => [(-1, 0), (0, -1)],
        '7' => [(1, 0), (0, -1)],
        'F' => [(1, 0), (0, 1)],
        '.' => [],
    )
    current, distance = (start, 0)
    q = [(current, distance)]
    visited = [start]
    while length(q) > 0
        current, distance = popfirst!(q)
        loop[current...] = 1
        # println("visiting $current, at a distance of $distance")
        for delta in dirs[maze[current...]]
            next = current .+ delta
            if ! (next in visited)
                push!(q, (next, distance + 1))
                push!(visited, next)
            end
        end
    end
    return loop, distance
end

function expand_maze(maze)
    newrows = []
    for row in eachrow(maze)
        newrow = replace(row, '-' => '.', 'F' => '|', '7' => '|', 'J' => '.', 'L' => '.')
        push!(newrows, row)
        push!(newrows, newrow)
    end
    newmaze = vcat(permutedims.(newrows)...)
    newcols = []
    for col in eachcol(newmaze)
        newcol = replace(col, '|' => '.', 'F' => '-', 'L' => '-', 'J' => '.', '7' => '.')
        push!(newcols, col)
        push!(newcols, newcol)
    end
    newmaze = hcat(newcols...)
    return newmaze
end

function squeeze_maze(maze)
    return maze[1:2:end, 1:2:end]
end

function find_outside(loop)
    reach = zeros(Bool, size(loop))
    start = Tuple(findfirst(isequal(0), loop))
    q = [start]
    visited = [start]
    while length(q) > 0
        current = popfirst!(q)
        reach[current...] = true
        for dir in [(-1, 0), (0, 1), (1, 0), (0, -1)]
            next = current .+ dir
            if next in visited
                continue
            end
            try
                if loop[next...] == 0
                    push!(q, next)
                    push!(visited, next)
                end
            catch
                # out of bounds
            end
        end
    end
    return reach
end

maze = read_puzzle("input")

start = replace_start!(maze)
loop, distance = compute(maze, start)
println(distance)

maze[loop .== false] .= '.'
exp_maze = expand_maze(maze)
exp_start = @. (start - 1) * 2 + 1
exp_loop, _ = compute(exp_maze, exp_start)
inside = .!(find_outside(exp_loop) .|| exp_loop)
sq = squeeze_maze(inside)
println(sum(sq))
