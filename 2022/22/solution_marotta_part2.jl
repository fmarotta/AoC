#!/usr/bin/env julia

"""
How many ways are there to fold a cube?
There are 12 edges, we have to cut some of them.
In order to be able to open the cube, we need to cut 3 adjacent edges.
We should be careful to not isolate any faces.
how many edges should I cut?


let's try to see it differently. there are 8 vertices.
each vertex connects 3 faces.

let's try another way.
one face is already on the plane.
the other faces can go up, down, left, or right to it.
but the faces are not independent.
either we put zero up and three down, or one up and two down, or two up and one down, or three up and no down.

wait a minute.
we need to find a path that can optionally branch.
we start at one face and we can branch up to three times.

cube:

1 -> 2, 3, 4, 5
2 -> 1, 3, 4, 6
3 -> 1, 2, 5, 6
4 -> 1, 2, 3, 6

we actually don't need to do that.
each face communicates with 4 other faces (all except the opposite one).
we only need to define the wrapping rules.

if two faces are adjacent, we just continue like in the 2d case.
if two faces are on a diagonal with one "missing face", the communication
is an "L" and we need to change the direction.
Specifically, we need to rotate towards the other face.
The communication will also be in the direction of the other face.
For instance, from 3 to 1, the communication occurs while going up,
the exit side is north, the entry side is west,
and we need to rotate clockwise because 1 is to the left of 3.

1. identify and label the faces.
    we'll split the matrix into a grid, then label the actual
    faces from 1 to 6, the rest from 7 to 12.

2. establish the connection rules.
    first, identify the neighbouring faces.
    for each face, try to go first up down left right;
    the connection rules are very simple.
    then, try to go diagonally one square (i.e. up then left, up then right, down then left, down then right)
    establish the connection rules.
    then, try to do the knight's jump.
    finally, try to wrap around to the other side.
    we must do it in this order.
    
the connection rule should say what happens when we overflow from one face
and we're going in a certain direction.
So the mapping should take a face and a direction.
it should specify the rule to compute the square where we land, as well as
the (optional) change in direction.
"""

directions = [
    [0, 1],  # right
    [1, 0],  # down
    [0, -1],  # left
    [-1, 0],  # up
]

function direction_score(dir)
    score = 0
    while directions[score + 1] != dir
        score += 1
    end
    return score
end

function rotate(direction, angle)
    pseudodir = [direction[2], -direction[1]]
    res = [cos(angle) -sin(angle); sin(angle) cos(angle)] * pseudodir
    return [-res[2], res[1]]
end

R(direction) = round.(Int, rotate(direction, -pi/2))
L(direction) = round.(Int, rotate(direction, pi/2))

""" nextprobe

Takes care of wrapping around the faces and returns the position
of the next probe while going in a given direction. It needs to
know the sector of each cell.
"""
function nextprobe(cur, direction, matrix, side)
    # assume that cur is always valid (i.e. > -1)
    probe = cur .+ direction
    if floor.((cur .- 1) ./ side) == floor.((probe .- 1) ./ side)
        # we are still on the same face
        return probe
    end
    # we are going off the face, so we need to apply some logic.
    # if we are going up, we should check our 
    return probe
end

""" uptowall

Checks if we've hit a wall. It just needs to know the positions of
the walls.
"""
function uptowall(coord, direction, value, matrix, wrapping_rules)
    # assume cur is always a valid coord (i.e. a 1)
    cur = copy(coord)
    while value > 0
        value -= 1
        probe = nextprobe(cur, direction, matrix, wrapping_rules)
        if matrix[probe...] == 0
            break
        else
            cur = probe
        end
    end
    return cur
end

open("test.txt") do io
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
    board_matrix = -ones(Int, nrows, ncols)
    walls = Set{Vector{Int}}()
    for (r, l) in enumerate(board)
        for (c, type) in enumerate(l)
            if type == '.'
                board_matrix[r, c] = 1
            elseif type == '#'
                board_matrix[r, c] = 1
                push!(walls, [r, c])
            end
        end
    end

    # make the grid
    # rules: in every unfolding there is at least one row or column
    # with just one face. we exploit this to find the side of the cube.
    side = size(board_matrix)[1]
    for r in 1:size(board_matrix)[1]
        nonempty = length(filter(x -> x > 0, board_matrix[r, :]))
        if nonempty < side
            side = nonempty
        end
    end
    for c in 1:size(board_matrix)[2]
        nonempty = length(filter(x -> x > 0, board_matrix[:, c]))
        if nonempty < side
            side = nonempty
        end
    end
    println("we have a cube of side $side")

    # we label each square of the grid
    i = 1
    j = 7
    for r in 1:side:size(board_matrix)[1], c in 1:side:size(board_matrix)[2]
        if board_matrix[r, c] > 0
            board_matrix[r:r+side-1, c:c+side-1] *= i
            i += 1
        else
            board_matrix[r:r+side-1, c:c+side-1] *= j
            j += 1
        end
    end
    for r in eachrow(board_matrix)
        println(r)
    end

    # find the starting point
    coord = [1, 1]
    while board_matrix[coord...] < 0
        coord += [0, 1]
    end
    # `in` doesn't work!
    while !(coord ∉ walls)
        coord += [0, 1]
    end
    dir = [-1, 0]
    println("we start at $coord going $dir")

    # idea: we do a dfs, moving towards the first available
    probe = nextprobe(coord, dir, board_matrix, side)

    return

    # now we find the rules
    wrapping_rules = Vector(undef, 6)
    for face in 1:6
        println(face)
        wrapping_rules[face] = Dict()
        # first, what are the neighbours?
        grid_coord = reverse_grid[face]
        face_bounds = [
            [(grid_coord[1] - 1) * side + 1, (grid_coord[2] - 1) * side + 1],
            [grid_coord[1] * side, grid_coord[2] * side]
        ]
        for adj in [[-1, 0], [0, 1], [1, 0], [0, -1]]
            probe = grid_coord .+ adj
            probe .= mod.(probe .- 1, size(grid)) .+ 1
            if grid[probe...] > 6
                continue
            end
            # now, what are the rules?
            dir = adj
            wrapping_rules[face][dir] = WrappingRules(
                grid[probe...],
                p -> p .+ dir,
                dir
            )
        end
        for diag in [[-1, -1], [-1, 1], [1, -1], [1, 1]]
            probe = grid_coord .+ diag
            probe .= mod.(probe .- 1, size(grid)) .+ 1
            if grid[probe...] > 6
                continue
            end
            if diag == [-1, -1]
                dir = [-1, 0]
                wrapping_rules[face][dir] = WrappingRules(
                    grid[probe...],
                    p -> [
                        p[1] - (p[2] - face_bounds[1][2] + 1), 
                        face_bounds[1][2] - 1
                    ],
                    L(dir)
                )
            elseif diag == [-1, 1]
                dir = [-1, 0]
                wrapping_rules[face][dir] = WrappingRules(
                    grid[probe...],
                    p -> [
                        p[1] - (face_bounds[2][2] - p[2] + 1), 
                        face_bounds[2][2] + 1
                    ],
                    R(dir)
                )
            elseif diag == [1, -1]
                dir = [0, -1]
                wrapping_rules[face][dir] = WrappingRules(
                    grid[probe...],
                    p -> [
                        face_bounds[2][1] + 1,
                        p[2] - (face_bounds[2][1] - p[1] + 1)
                    ],
                    L(dir)
                )
            elseif diag == [1, 1]
                dir = [0, 1]
                wrapping_rules[face][dir] = WrappingRules(
                    grid[probe...],
                    p -> [
                        face_bounds[2][1] + 1,
                        p[2] + (face_bounds[2][1] - p[1] + 1)
                    ],
                    R(dir)
                )
            end
        end
        for knight in [[-2, -1], [-2, 1], [-1, -2], [1, -2], [2, -1], [2, 1], [-1, 2], [1, 2]]
            probe = grid_coord .+ knight
            probe .= mod.(probe .- 1, size(grid)) .+ 1
            if grid[probe...] > 6
                continue
            end
            if knight == [-2, -1]
                dir = [0, 1]
                wrapping_rules[face][dir] = WrappingRules(
                    grid[probe...],
                    p -> [
                        p[1] - side - (p[1] - face_bounds[1][1] + 1),
                        face_bounds[1][2] - 1
                    ],
                    L(L(dir))  # flip
                )
            elseif knight == [-2, 1]
                dir = [0, -1]
                wrapping_rules[face][dir] = WrappingRules(
                    grid[probe...],
                    p -> [
                        p[1] - side - (p[1] - face_bounds[1][1] + 1),
                        face_bounds[2][2] + 1
                    ],
                    L(L(dir))  # flip
                )
            elseif knight == [-1, 2]
                dir = [-1, 0]
                wrapping_rules[face][dir] = WrappingRules(
                    grid[probe...],
                    p -> [
                        p[2] + side + (face_bounds[2][2] - p[2] + 1),
                        p[1] - side
                    ],
                    L(L(dir))  # flip
                )
            elseif knight == [1, 2]
                dir = [1, 0]
                wrapping_rules[face][dir] = WrappingRules(
                    grid[probe...],
                    p -> [
                        p[2] + side + (face_bounds[2][2] - p[2] + 1),
                        p[1] + side
                    ],
                    L(L(dir))  # flip
                )
            elseif knight == [2, 1]
                dir = [0, 1]
                wrapping_rules[face][dir] = WrappingRules(
                    grid[probe...],
                    p -> [
                        p[1] + side + (face_bounds[2][1] - p[1] + 1),
                        p[2] + side
                    ],
                    L(L(dir))  # flip
                )
            elseif knight == [2, -1]
                dir = [0, -1]
                wrapping_rules[face][dir] = WrappingRules(
                    grid[probe...],
                    p -> [
                        p[1] + side + (face_bounds[2][1] - p[1] + 1),
                        p[2] - side
                    ],
                    L(L(dir))  # flip
                )
            elseif knight == [1, -2]
                dir = [-1, 0]
                wrapping_rules[face][dir] = WrappingRules(
                    grid[probe...],
                    p -> [
                        p[1] + side,
                        p[2] - side - (p[2] - face_bounds[1][2] + 1)
                    ],
                    L(L(dir))  # flip
                )
            elseif knight == [-1, -2]
                dir = [1, 0]
                wrapping_rules[face][dir] = WrappingRules(
                    grid[probe...],
                    p -> [
                        p[1] - side,
                        p[2] - side - (p[2] - face_bounds[1][2] + 1)
                    ],
                    L(L(dir))  # flip
                )
            end
        end
    end
    println(wrapping_rules)

    # now we finally apply the instructions
    for instruction in eachmatch(r"[RL]\d+", instructions)
        println("processing $instruction")
        rotation = instruction.match[1]
        movement = parse(Int, instruction.match[2:end])
        if rotation == 'R'
            dir = R(dir)
        elseif rotation == 'L'
            dir = L(dir)
        end
        println("we're currently in $coord facing $dir for $movement units")
        println(wrapping_rules[4][[0, 1]])
        coord = uptowall(coord, dir, movement, board_matrix, wrapping_rules)
        println(coord)
    end
    final_score = 1000 * coord[1] + 4 * coord[2] + direction_score(dir)
    println(final_score)
end
