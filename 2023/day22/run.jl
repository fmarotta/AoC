function read_puzzle(file)
    bricks = []
    for l in eachline(file)
        p1, p2 = split.(split(l, "~"), ",")
        q1 = parse.(Int, p1)
        q2 = parse.(Int, p2)
        push!(bricks, [q1[c]:q2[c] for c in 1:3])
    end
    # a < b means that b can fall on top of a
    sort!(bricks, lt = (a, b) -> (minimum(a[3]) < minimum(b[3])))
    return bricks
end

function fall!(bricks)
    supporters = [[] for _ in bricks]
    for (b, brick) in enumerate(bricks)
        max_z = 0
        for other in bricks[1:b-1]
            if minimum(brick[3]) <= maximum(other[3])
                continue
            end
            # b can fall on top of o
            if length(intersect(brick[1], other[1])) > 0 && length(intersect(brick[2], other[2])) > 0
                # println("$b falls on top of $other")
                if maximum(other[3]) > max_z
                    max_z = maximum(other[3])
                end
            end
        end
        h = brick[3][end] - brick[3][1]
        bricks[b] = [brick[1], brick[2], max_z+1:max_z+1+h]
        for (o, other) in enumerate(bricks[1:b-1])
            if minimum(bricks[b][3]) == maximum(other[3]) + 1
                if length(intersect(bricks[b][1], other[1])) > 0 && length(intersect(bricks[b][2], other[2])) > 0
                    # println("brick $b : $brick is supported by $o : $other")
                    push!(supporters[b], o)
                end
            end
        end
    end
    return supporters
end

function disintegrate(targets, tree)
    next_targets = Set()
    for (b, supporters) in enumerate(tree)
        if length(intersect(supporters, targets)) == length(supporters) && length(supporters) > 0
            if ! (b in targets)
                push!(next_targets, b)
            end
        end
    end
    if length(next_targets) == 0
        return 0
    end
    return length(next_targets) + disintegrate(union(targets, next_targets), tree)
end

function part1(tree)
    necessary = Set()
    for supporters in tree
        if length(supporters) == 1
            push!(necessary, supporters[1])
        end
    end
    return length(tree) - length(necessary)
end

function part2(tree)
    falling = 0
    for b in 1:length(tree)
        falling += disintegrate(Set([b]), tree)
    end
    return falling
end

bricks = read_puzzle("input")
supporters = fall!(bricks)
println(part1(supporters))
println(part2(supporters))
