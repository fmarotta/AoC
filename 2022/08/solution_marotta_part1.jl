#!/usr/bin/env julia

visible_trees = open("input.txt", "r") do io
    lines = readlines(io)
    # Trying to generate a matrix with a comprehension.
    # The 'intuitive' approach would generate a vector of vectors, which
    # would have to be converted to a matrix with reduce(hcat, vec), but
    # I wanted to avoid that. Doing this is also 2x faster than the
    # reduce-hcat approach.
    tree_heights = [parse(Int8, l[i]) for l in lines, i in 1:length(lines[1])]
    visible_trees = 0
    for i = 1:size(tree_heights)[1], j = 1:size(tree_heights)[2]
        h = tree_heights[i, j]
        # extend north
        row = i - 1
        while row > 0 && tree_heights[row, j] < h
            row -= 1
        end
        if row == 0
            visible_trees += 1
            continue
        end
        # extend south
        row = i + 1
        while row <= size(tree_heights)[1] && tree_heights[row, j] < h
            row += 1
        end
        if row == size(tree_heights)[1] + 1
            visible_trees += 1
            continue
        end
        # extend east
        col = j - 1
        while col > 0 && tree_heights[i, col] < h
            col -= 1
        end
        if col == 0
            visible_trees += 1
            continue
        end
        # extend west
        col = j + 1
        while col <= size(tree_heights)[2] && tree_heights[i, col] < h
            col += 1
        end
        if col == size(tree_heights)[2] + 1
            visible_trees += 1
            continue
        end
    end
    visible_trees
end
println(visible_trees)
