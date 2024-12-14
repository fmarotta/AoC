function read_puzzle(file)
    f = strip(read(file, String))
    machines = []
    for m in eachsplit(f, "\n\n")
        a, b, p = eachsplit(m, "\n")
        ax, ay = parse.(Int, match(r"X\+(\d+), Y\+(\d+)", a))
        bx, by = parse.(Int, match(r"X\+(\d+), Y\+(\d+)", b))
        px, py = parse.(Int, match(r"X=(\d+), Y=(\d+)", p))
        push!(machines, ((ax, ay), (bx, by), (px, py)))
    end
    machines
end

function compute(inp)
    res = 0
    for ((ax, ay), (bx, by), (px, py)) in inp
        B = (py * ax - px * ay) ÷ (by * ax - bx * ay)
        A = (px - bx * B) ÷ ax
        if A * ax + B * bx == px && A * ay + B * by == py
            res += 3A + B
        end
    end
    res
end

p1 = read_puzzle(ARGS[1])
p2 = map(x -> (x[1], x[2], x[3] .+ 10000000000000), p1)
compute(p1) |> println
compute(p2) |> println
