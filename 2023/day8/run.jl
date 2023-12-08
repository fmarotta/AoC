function read_puzzle(file)
    directions, connections = split(read(file, String), "\n\n")
    directions = split(directions, "")
    directions = replace(directions, "L" => 1, "R" => 2)
    network = Dict()
    for line in split(connections, "\n")
        if line == ""
            continue
        end
        m = match(r"(.*) = \((.*), (.*)\)", line)
        network[m[1]] = (m[2], m[3])
    end
    return directions, network
end

function count_moves_part1(directions, network, start = "AAA", targets = ["ZZZ"])
    moves = 0
    current = start
    while ! (current in targets)
        moves += 1
        current = network[current][directions[
            ((moves - 1) % length(directions)) + 1]
        ]
    end
    return moves
end

function count_moves_part2(directions, network)
    starts = filter(endswith("A"), keys(network))
    targets = filter(endswith("Z"), keys(network))
    periods = [count_moves_part1(directions, network, c, targets) for c in starts]
    return lcm(periods)
end

directions, network = read_puzzle("input")
println(count_moves_part1(directions, network))
println(count_moves_part2(directions, network))
