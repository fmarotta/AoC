function read_puzzle(file)
    l = readlines(file)
    [l[i][j] for i in 1:length(l), j in 1:length(l[1])]
end

function neighbours((coord), M)
    neighs = []
    for d in [(-1, 0), (0, 1), (1, 0), (0, -1)]
        probe = coord .+ d
        if all((1, 1) .<= probe .<= size(M)) && M[probe...] != '#'
            push!(neighs, probe)
        end
    end
    return neighs
end

function bfs(M, start)
    dist = [Inf for _ in 1:size(M, 1), _ in 1:size(M, 2)]
    dist[start...] = 0
    q = [start]
    while length(q) > 0
        cur = popfirst!(q)
        for neigh in neighbours(cur, M)
            alt = dist[cur...] + 1
            if alt < dist[neigh...]
                dist[neigh...] = alt
                push!(q, neigh)
            end
        end
    end
    return dist
end

same_evenness(a, b) = Int(a) & 1 == Int(b) & 1

# function compute(M, start)
#     visitable = [Set() for _ in 1:size(M, 1), _ in 1:size(M, 2)]
#     push!(visitable[start...], 0)
#     step = 0
#     while any(length.(visitable[M .!= '#']) .== 0)
#         step += 1
#         for r in 1:size(M, 1), c in 1:size(M, 2)
#             if M[r, c] == '#'
#                 continue
#             end
#             for neigh in neighbours((r, c), M)
#                 if step - 1 in visitable[neigh...]
#                     push!(visitable[r, c], step)
#                 end
#             end
#         end
#     end
#     printm(collect.(visitable); width = 4)
#     res = 0
#     for v in visitable
#         if 64 in v
#             res += 1
#         end
#     end
#     return res
# end

function part1(M)
    start = findfirst(isequal('S'), M)
    dist = bfs(M, Tuple(start))
    sum(dist .<= 64 .&& dist .% 2 .== 0)
end

"""
The distance from S to coord (r, c) of tile (x, y) is equal to:
the distance from S to coord (r, c) of tile (sign(x), sign(y)) + (abs(x) + abs(y) - abs(sign(x)) - abs(sign(y))) * grid_side

#####|#####|#####
#####|#####|#####
#####|#####|#####
#####|#####|#####
#####|#####|#####
-----+-----+-----
#####|#####|#####
#####|#####|#####
#####|#####|#####
#####|#####|#####
#####|#####|#####
-----+-----+-----
#####|#####|#####
#####|#####|#####
#####|#####|#####
#####|#####|#####
#####|#####|#####

"""
function part2(M, S = 26501365)
    n = size(M, 1)
    M2 = hcat(replace(M, 'S' => '.'), M, replace(M, 'S' => '.'))
    M3 = vcat(replace(M2, 'S' => '.'), M2, replace(M2, 'S' => '.'))
    start = findfirst(isequal('S'), M3)
    dist = bfs(M3, Tuple(start))
    tiles = [dist[r*n+1:(r+1)*n, c*n+1:(c+1)*n] for r in 0:2, c in 0:2]

    how_many_tiles = zeros(size(M))
    for dx in (-1, 0, 1), dy in (-1, 0, 1)
        if dx == 0 && dy == 0
            res = tiles[2, 2] .<= S .&& same_evenness.(tiles[2, 2], S)
            how_many_tiles .+= res
        elseif dx == 0 || dy == 0
            max_n_tiles = floor.((-tiles[2-dy, 2+dx] .+ S .+ n * (abs(dx) + abs(dy))) / n)
            max_n_tiles[max_n_tiles .< 1] .= 0
            se = floor.(max_n_tiles .* (tiles[2, 2] .<= S .&& same_evenness.(tiles[2, 2], S)) ./ 2)
            de = floor.((max_n_tiles .+ 1) .* (tiles[2, 2] .<= S .&& .!same_evenness.(tiles[2, 2], S)) ./ 2)
            res = se .+ de
            how_many_tiles .+= res
        else
            max_n_tiles = floor.((-tiles[2-dy, 2+dx] .+ S .+ n * (abs(dx) + abs(dy))) / n)
            max_n_tiles[max_n_tiles .< 2] .= 0
            se = zeros(size(M))
            de = zeros(size(M))
            for i in 1:size(M, 1), j in 1:size(M, 2)
                if tiles[2, 2][i, j] <= S && same_evenness(tiles[2, 2][i, j], S)
                    se[i, j] = sum(1:2:max_n_tiles[i, j]-1)
                elseif tiles[2, 2][i, j] <= S && ! same_evenness(tiles[2, 2][i, j], S)
                    de[i, j] = sum(2:2:max_n_tiles[i, j]-1)
                end
            end
            res = se .+ de
            how_many_tiles .+= res
        end
    end

    return Int(sum(how_many_tiles))
end

M = read_puzzle("input")
println(part1(M))
println(part2(M))
