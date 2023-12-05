# function read_puzzle(file)
#     seeds = []
#     open(file, "r") do io
#         seeds = parse.(Int, split(split(readline(io), ": ")[2]))
#         maps = split(read(io, String), "\n\n")
#         for map in maps
#             mapped_seeds = copy(seeds)
#             for (i, seed) in enumerate(seeds)
#                 for line in split(map, "\n")
#                     if line == ""
#                         continue
#                     elseif occursin(':', line)
#                         name = split(line)[1]
#                         println("\n", name)
#                     else
#                         # try to map each seed to this category
#                         dest_start, source_start, len = parse.(Int, split(line))
#                         if source_start <= seed <= source_start + len
#                             mapped_seeds[i] = dest_start + seed - source_start
#                             println("mapping $seed to $(mapped_seeds[i])")
#                             break
#                         end
#                     end
#                 end
#             end
#             println("mapping $seeds to $mapped_seeds")
#             seeds = mapped_seeds
#         end
#         println("mapped  $seeds")
#     end
#     println( minimum(seeds))
# end

function read_puzzle(file)
    open(file, "r") do io
        pre_seeds = parse.(Int, split(split(readline(io), ": ")[2]))
        seeds = []
        for (i, pre_seed) in enumerate(pre_seeds)
            if i & 1 == 0
                continue
            end
            push!(seeds, pre_seed:pre_seed+pre_seeds[i+1]-1)
        end
        # println(seeds)
        maps = split(read(io, String), "\n\n")
        for map in maps
            mapped_seeds = []
            # mapped_seeds = copy(seeds)
            while length(seeds) > 0
                seed = popfirst!(seeds)
                println("\nmapping $(seed)")
                did_seed_map = false
                for line in split(map, "\n")
                    if line == ""
                        continue
                    elseif occursin(':', line)
                        name = split(line)[1]
                        println(name)
                    else
                        # try to map each seed to this category
                        dest_start, source_start, len = parse.(Int, split(line))
                        source = source_start:source_start+len-1
                        dest = dest_start:dest_start+len-1
                        println("$source, $dest")
                        matching = intersect(seed, source)
                        if length(matching) == 0
                            continue
                        end
                        println("matching: $matching")
                        dest_range = matching .+ (dest_start - source_start)
                        println("dest: $dest_range")
                        # println("match to $(collect(dest_range))")
                        push!(mapped_seeds, dest_range)
                        if length(dest_range) != length(seed)
                            # residual = setdiff(seed, source)
                            # println("residual: $residual")
                            # println("dogfeeding $(collect(residual))")
                            if seed[begin] < source_start
                                residual = seed[begin]:source_start-1
                                println("residual: $residual")
                                push!(seeds, residual)
                            end
                            if seed[end] > source_start + len
                                residual = source_start+len:seed[end]
                                println("residual: $residual")
                                push!(seeds, residual)
                            end
                        end
                        did_seed_map = true
                        break
                    end
                end
                if did_seed_map == false
                    # println("couldn't match $seed")
                    push!(mapped_seeds, seed)
                end
            end
            seeds = mapped_seeds
            # println(seeds)
        end
        println("mapped $seeds")
        println(minimum([x[1] for x in seeds]))
        # println( minimum(seeds))
    end
end


l = read_puzzle("input")
