function read_puzzle(file)
    parse.(Int, split(readline(file), ""))
end

function part1(tape)
    chk = 0
    pos = 0
    # last one is file
    file_capacity = tape[1:2:end]
    space_capacity = tape[2:2:end]
    file_id = collect(0:length(file_capacity)-1)
    i = 1
    j = length(file_id)
    while true
        while file_capacity[i] > 0
            # println(file_id[i])
            chk += file_id[i] * pos
            pos += 1
            file_capacity[i] -= 1
        end
        while space_capacity[i] > 0
            while j > 0 && file_capacity[j] <= 0
                j -= 1
            end
            if j < i
                return chk
            end
            # println(file_id[j])
            chk += file_id[j] * pos
            pos += 1
            file_capacity[j] -= 1
            space_capacity[i] -= 1
        end
        i += 1
    end
    chk
end

function part2(tape)
    chk = 0
    pos = 0
    file_capacity = tape[1:2:end]
    space_capacity = tape[2:2:end]
    file_id = collect(0:length(file_capacity)-1)
    already_moved = falses(length(file_id))
    i = 1
    while i <= length(file_capacity)
        while file_capacity[i] > 0
            if already_moved[i] == true
                pos += file_capacity[i]
                # file_capacity[i] = 0
                break
            end
            chk += file_id[i] * pos
            pos += 1
            file_capacity[i] -= 1
        end
        while i <= length(space_capacity) && space_capacity[i] > 0
            # Try to move blocks up to i
            # if cannot move, skip to next file.
            j = length(file_id)
            while j > i && (already_moved[j] || file_capacity[j] > space_capacity[i])
                # println("\t$(file_id[j]) is not good")
                j -= 1
            end
            if j == i
                # consume all space
                pos += space_capacity[i]
                # space_capacity[i] = 0
                break
            end
            # if we are here we move j
            already_moved[j] = true
            for _ in 1:file_capacity[j]
                chk += file_id[j] * pos
                pos += 1
                space_capacity[i] -= 1
            end
        end
        i += 1
    end
    chk
end

tape = read_puzzle(ARGS[1])
@time part1(tape) |> println
@time part2(tape) |> println

using BenchmarkTools
@benchmark part1(tape)
@benchmark part2(tape)
