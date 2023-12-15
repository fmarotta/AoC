function read_puzzle(file)
    split(readline(file), ",")
end

function get_hash(s)
    value = 0
    for ch in s
        value = mod((value + Int(ch)) * 17, 256)
    end
    return value
end

function focusing_power(boxes)
    p = 0
    for (i, b) in enumerate(boxes)
        p += sum(i * j * v for (j, (_, v)) in enumerate(b); init=0)
    end
    return p
end

function part1(seq)
    res = 0
    for s in seq
        res += get_hash(s)
    end
    return res
end

function part2(seq)
    boxes = [[] for _ in 1:256]
    for s in seq
        sep = findfirst((x) -> x in ('=', '-'), s)
        label = s[1:sep-1]
        box = get_hash(label)
        pos = findfirst(x -> x[1] == label, boxes[begin+box])
        op = s[sep]
        # println("$s, $sep, $label, $box, $op")
        if op == '-'
            if pos !== nothing
                popat!(boxes[begin+box], pos)
            end
        elseif op == '='
            lens = [label, parse(Int, s[sep+1:end])]
            if pos === nothing
                push!(boxes[begin+box], lens)
            else
                boxes[begin+box][pos] = lens
            end
        else
            @error "buuuu"
        end
    end
    return focusing_power(boxes)
end

seq = read_puzzle("input")
println(part1(seq))
println(part2(seq))
