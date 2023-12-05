using DataStructures: OrderedDict

function read_puzzle(file)
    open(file, "r") do io
        seeds = parse.(Int, split(split(readline(io), ": ")[2]))
        maps = OrderedDict()
        for map in eachsplit(read(io, String), "\n\n")
            name = ""
            for line in eachsplit(map, "\n")
                if "" == line
                    continue
                elseif occursin(':', line)
                    name = split(line)[1]
                    maps[name] = []
                else
                    dest_start, source_start, len = parse.(Int, split(line))
                    push!(maps[name], (dest_start:dest_start+len-1, source_start:source_start+len-1))
                end
            end
        end
        return seeds, maps
    end
end

function part1(seeds, maps)
    for map in values(maps)
        mapped_seeds = copy(seeds)
        for (i, seed) in enumerate(seeds)
            for (dest, source) in map
                if seed in source
                    mapped_seeds[i] = seed + dest[begin] - source[begin]
                    break
                end
            end
        end
        seeds = mapped_seeds
    end
    return minimum(seeds)
end

function part2(pre_seeds, maps)
    seeds = broadcast(:, pre_seeds[1:2:end], pre_seeds[1:2:end] .+ pre_seeds[2:2:end] .- 1)
    for (map_name, map) in maps
        mapped_seeds = []
        while length(seeds) > 0
            seed = popfirst!(seeds)
            was_seed_mapped = false
            for (dest, source) in map
                matching = intersect(seed, source)
                if 0 == length(matching)
                    continue
                end
                mapped_seed = matching .+ (dest[begin] - source[begin])
                push!(mapped_seeds, mapped_seed)
                if length(mapped_seed) != length(seed)
                    if seed[begin] < source[begin]
                        residual = seed[begin]:source[begin]-1
                        push!(seeds, residual)
                    end
                    if seed[end] > source[end]
                        residual = source[end]+1:seed[end]
                        push!(seeds, residual)
                    end
                end
                was_seed_mapped = true
                break
            end
            if false == was_seed_mapped
                push!(mapped_seeds, seed)
            end
        end
        seeds = mapped_seeds
    end
    return minimum([x[begin] for x in seeds])
end


seeds, maps = read_puzzle("input")
println(part1(seeds, maps))
println(part2(seeds, maps))
