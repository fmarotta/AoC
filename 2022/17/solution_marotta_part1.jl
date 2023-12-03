#!/usr/bin/env julia

shapes = [
    [true true true true],
    [false true false; true true true; false true false],
    [false false true; false false true; true true true],
    trues(4, 1),  # otherwise it creates a vector instead of a matrix
    [true true; true true],
]

winds = map(collect(readline("input.txt"))) do w
    if w == '>'
        return 1
    else
        return -1
    end
end
println(shapes)
println(winds)

function can_move(shape, coord, cave)
    rows = coord[2]:coord[2] + (size(shape)[1] - 1)
    cols = coord[1]:coord[1] + (size(shape)[2] - 1)
    return !any(@. shape && cave[rows, cols])
end

function simulate()
    cave = [
        true false false false false false false false true;
        true false false false false false false false true;
        true false false false false false false false true;
        true true true true true true true true true;
    ]
    highest_rock = size(cave)[1]
    wind_index = 1
    for rock in 1:2022
        rock_shape = shapes[((rock - 1) % length(shapes)) + 1]
        # add more rows to the cave.
        cave = vcat(repeat([true false false false false false false false true], size(rock_shape)[1]), cave)
        highest_rock += size(rock_shape)[1]
        println("starting rock $rock")
        # for r in 1:size(cave)[1]
        #     print("$r\t")
        #     println(cave[r, :])
        # end
        # println()
        rock_coord = [4, 1]
        resting = false
        while !resting
            # apply wind
            wind_push = [winds[wind_index], 0]
            if can_move(rock_shape, rock_coord .+ wind_push, cave)
                # println("pushing right")
                rock_coord = rock_coord .+ wind_push
            end
            wind_index = (wind_index % length(winds)) + 1
            # apply gravity
            fall = [0, 1]
            if can_move(rock_shape, rock_coord .+ fall, cave)
                # println("falling down")
                rock_coord = rock_coord .+ fall
            else
                resting = true
                rows = rock_coord[2]:rock_coord[2] + (size(rock_shape)[1] - 1)
                cols = rock_coord[1]:rock_coord[1] + (size(rock_shape)[2] - 1)
                @. cave[rows, cols] = cave[rows, cols] || rock_shape
                # final rock coordinate: rock_coord[2]
                height_increment = highest_rock - rock_coord[2]
                if height_increment <= 0
                    # remove all the inserted rows from the cave
                    cave = cave[size(rock_shape)[1]+1:end, :]
                    highest_rock -= size(rock_shape)[1]
                    # highest_rock doesn't change
                elseif height_increment < size(rock_shape)[1]
                    cave = cave[size(rock_shape)[1] - height_increment + 1:end, :]
                    highest_rock -= height_increment
                    highest_rock -= (size(rock_shape)[1] - height_increment)
                else
                    highest_rock -= size(rock_shape)[1]
                end
        # for r in 1:size(cave)[1]
        #     print("$r\t")
        #     println(cave[r, :])
        # end
        # println()
        # println("highest: $highest_rock")
        # println()
        # println()
            end
        end 
    end
    return size(cave)[1] - 4
end

println(simulate())
