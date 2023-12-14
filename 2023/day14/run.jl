function read_puzzle(file)
    l = readlines(file)
    return [l[i][j] for i in 1:length(l), j in 1:length(l[1])]
end

function tilt_north(g)
    grid = copy(g)
    for c in 1:size(grid, 2)
        col = grid[:, c]
        balls = findall(isequal('O'), col)
        new_balls = map(balls) do ball_pos
            block = findlast(isequal('#'), col[1:ball_pos-1])
            if block !== nothing
                min_pos = block + 1
            else
                min_pos = 1
            end
            return min_pos + count(isequal('O'), col[min_pos:ball_pos-1])
        end
        grid[balls, c] .= '.'
        grid[new_balls, c] .= 'O'
    end
    return grid
end

function compute_load(grid)
    score = 0
    for c in eachcol(grid)
        score += sum(size(grid, 2) .- findall(isequal('O'), c) .+ 1)
    end
    return score
end

function rotate_cw(m)
    hcat(reverse(eachrow(m))...)
end

function part2(g)
    grid = copy(g)
    explored_grids = Dict()
    cycle = 0
    while ! (grid in keys(explored_grids))
        explored_grids[grid] = cycle
        cycle += 1
        for _ in 1:4
            grid = rotate_cw(tilt_north(grid))
        end
    end
    init = explored_grids[grid]
    period = cycle - init
    # println("starting from $init, the configurations repeat every $period steps.")
    # println("we the grid whose value is ($init + (1e9 - $init mod $period))")
    for (k, v) in explored_grids
        if v == init + mod(1e9 - init, period)
            return k
        end
    end
end

grid = read_puzzle("input")
println(compute_load(tilt_north(grid)))

g2 = part2(grid)
println(compute_load(g2))
