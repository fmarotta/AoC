#!/usr/bin/env julia

"""
dirertions = [
    [0, 1],  # right
    [0, -1],  # left
    [1, 0],  # down
    [-1, 0],  # up
]
"""

function direction_score(dir)
    scores = Dict(
        [0, 1] => 0,
        [1, 0] => 1,
        [0, -1] => 2,
        [-1, 0] => 3
    )
    return scores[dir]
end

function rotate(direction, angle)
    pseudodir = [direction[2], -direction[1]]
    res = [cos(angle) -sin(angle); sin(angle) cos(angle)] * pseudodir
    return [-res[2], res[1]]
end

R(direction) = round.(Int, rotate(direction, -pi/2))
L(direction) = round.(Int, rotate(direction, pi/2))

function nextvalidpoint(coord, direction, matrix)
    # assume cur is always a valid coord (i.e. a 1)
    # println("finding next valid point from $coord")
    cur = copy(coord)
    while matrix[cur...] == 0
        cur .+= direction
        if cur[1] <= 0
            cur = nextvalidpoint([size(matrix)[1], cur[2]], direction, matrix)
        elseif cur[1] > size(matrix)[1]
            cur = nextvalidpoint([1, cur[2]], direction, matrix)
        end
        if cur[2] <= 0
            cur = nextvalidpoint([cur[1], size(matrix)[2]], direction, matrix)
        elseif cur[2] > size(matrix)[2]
            cur = nextvalidpoint([cur[1], 1], direction, matrix)
        end
    end
    return cur
end

function nextprobe(cur, direction, matrix)
    probe = cur .+ direction
    if probe[1] <= 0
        probe = nextvalidpoint([size(matrix)[1], probe[2]], direction, matrix)
    elseif probe[1] > size(matrix)[1]
        probe = nextvalidpoint([1, probe[2]], direction, matrix)
    end
    if probe[2] <= 0
        probe = nextvalidpoint([probe[1], size(matrix)[2]], direction, matrix)
    elseif probe[2] > size(matrix)[2]
        probe = nextvalidpoint([probe[1], 1], direction, matrix)
    end
    if matrix[probe...] == 0
        # println("matrix$(probe) is zero, moving on...")
        probe = nextprobe(probe, direction, matrix)
    end
    return probe
end

function uptowall(coord, direction, value, matrix)
    # assume cur is always a valid coord (i.e. a 1)
    cur = copy(coord)
    while value > 0
        value -= 1
        probe = nextprobe(cur, direction, matrix)
        if matrix[probe...] == 2
            break
        else
            cur = probe
        end
    end
    return cur
end

open("input.txt") do io
    in = readlines(io)
    board, instructions = in[begin:end-2], in[end]
    instructions = "R" * instructions
    println(board)
    println(instructions)
    nrows = length(board)
    ncols = 0
    for l in board
        c = length(l)
        if c > ncols
            ncols = c
        end
    end
    board_matrix = zeros(Int, nrows, ncols)
    for (r, l) in enumerate(board)
        for (c, type) in enumerate(l)
            if type == '.'
                board_matrix[r, c] = 1
            elseif type == '#'
                board_matrix[r, c] = 2
            end
        end
        println(board_matrix[r, :])
    end
    coord = nextvalidpoint([1, 1], [0, 1], board_matrix)
    dir = [-1, 0]
    println("we start at $coord")
    for instruction in eachmatch(r"[RL]\d+", instructions)
        # println("processing $instruction")
        rotation = instruction.match[1]
        movement = parse(Int, instruction.match[2:end])
        if rotation == 'R'
            dir = R(dir)
        elseif rotation == 'L'
            dir = L(dir)
        end
        # println("we're facing $dir for $movement units")
        coord = uptowall(coord, dir, movement, board_matrix)
        println(coord)
    end
    final_score = 1000 * coord[1] + 4 * coord[2] + direction_score(dir)
    println(final_score)
end
