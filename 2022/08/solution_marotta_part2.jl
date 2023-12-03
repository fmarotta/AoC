#!/usr/bin/env julia

max_scenic_score = open("input.txt", "r") do io
    lines = readlines(io)
    tree_heights = [parse(Int8, l[i]) for l in lines, i in 1:length(lines[1])]
    max_score = 0
    for i = 1:size(tree_heights)[1], j = 1:size(tree_heights)[2]
        h = tree_heights[i, j]
        visible_trees = zeros(Int, 4)
        # extend north
        row = i - 1
        while row > 0
            visible_trees[1] += 1
            if tree_heights[row, j] >= h
                break
            end
            row -= 1
        end
        # extend south
        row = i + 1
        while row <= size(tree_heights)[1]
            visible_trees[2] += 1
            if tree_heights[row, j] >= h
                break
            end
            row += 1
        end
        # extend east
        col = j - 1
        while col > 0
            visible_trees[3] += 1
            if tree_heights[i, col] >= h
                break
            end
            col -= 1
        end
        # extend west
        col = j + 1
        while col <= size(tree_heights)[2]
            visible_trees[4] += 1
            if tree_heights[i, col] >= h
                break
            end
            col += 1
        end
        # check the score
        scenic_score = prod(visible_trees)
        if scenic_score > max_score
            max_score = scenic_score
        end
    end
    max_score
end
println(max_scenic_score)
