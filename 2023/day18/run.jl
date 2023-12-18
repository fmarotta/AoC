function read_puzzle(file)
    directions = []
    colors = []
    for l in eachline(file)
        direction, step, color = split(l)
        push!(directions, (direction, parse(Int, step)))
        push!(colors, replace(color, "(" => "", ")" => ""))
    end
    return directions, colors
end

function dirs2coords(directions)
    dir2vec = Dict(
        "U" => (0, -1),
        "R" => (1, 0),
        "D" => (0, 1),
        "L" => (-1, 0),
    )
    inclusive_coords = [(1, 1)]
    for (direction, step) in directions
        next_coord = inclusive_coords[end] .+ step .* dir2vec[direction]
        push!(inclusive_coords, next_coord)
    end
    coords = []
    for i in 1:length(directions)
        # from c[i] to c[i+1] we go dir[i]
        corner_type = directions[mod(i-2, end) + 1][1] * directions[i][1]
        if corner_type in ("UR", "RU")
            coord = inclusive_coords[i] .+ (-1, -1)
        elseif corner_type in ("RD", "DR")
            coord = inclusive_coords[i] .+ (0, -1)
        elseif corner_type in ("DL", "LD")
            coord = inclusive_coords[i] .+ (0, 0)
        elseif corner_type in ("LU", "UL")
            coord = inclusive_coords[i] .+ (-1, 0)
        end
        push!(coords, coord)
    end
    push!(coords, coords[begin])
    return coords
end

function parse_colors(colors)
    ord2dir = ["R", "D", "L", "U"]
    directions = []
    for color in colors
        step = parse(Int, "0x" * color[2:2+4])
        direction = ord2dir[color[end] - '0' + 1]
        push!(directions, (direction, step))
    end
    return directions
end

function shoelace(coords)
    A = 0
    for i in 1:length(coords)-1
        ci = coords[i]
        cii = coords[i+1]
        A += (ci[2] + cii[2]) * (ci[1] - cii[1])
    end
    return abs(A / 2)
end

directions1, colors = read_puzzle("input")
coords1 = dirs2coords(directions1)
println(Int(shoelace(coords1)))

directions2 = parse_colors(colors)
coords2 = dirs2coords(directions2)
println(Int(shoelace(coords2)))
