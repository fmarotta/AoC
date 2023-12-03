#!/usr/bin/env julia

mutable struct PQ
    heap::Vector{Vector{Any}}
    tail::Int
end
PQ() where T = PQ(Vector{Vector{Any}}(undef, 8), 0)

function swap!(A, i, j)
    temp = A[i]
    A[i] = A[j]
    A[j] = temp
end

function heapify_up!(heap, curr)
    parent = Int(floor(curr / 2))
    while curr > 1
        if heap[curr][2] < heap[parent][2]
            swap!(heap, curr, parent)
            curr = parent
            parent = Int(floor(curr / 2))
        else
            break
        end
    end
end

function heapify_down!(heap, curr, tail)
    left_child = 2 * curr
    right_child = left_child + 1
    while curr < tail
        if left_child <= tail && right_child <= tail
            # swap with minimum of left and right
            if heap[left_child][2] <= heap[right_child][2] && heap[curr][2] > heap[left_child][2]
                swap!(heap, curr, left_child)
                curr = left_child
                left_child = 2 * curr
                right_child = left_child + 1
            elseif heap[left_child][2] > heap[right_child][2] && heap[curr][2] > heap[right_child][2]
                swap!(heap, curr, right_child)
                curr = right_child
                left_child = 2 * curr
                right_child = left_child + 1
            else
                break
            end
        elseif left_child <= tail
            # check only the left child
            if heap[curr][2] > heap[left_child][2]
                swap!(heap, curr, left_child)
                curr = left_child
                left_child = 2 * curr
                right_child = left_child + 1
            else
                break
            end
        else
            break
        end
    end
end

function enqueue!(q::PQ, item)
    q.tail += 1
    if q.tail > length(q.heap)
        newheap = Vector{Vector{Any}}(undef, length(q.heap) * 2)
        copyto!(newheap, 1, q.heap, 1, length(q.heap))
        q.heap = newheap
    end
    q.heap[q.tail] = item
    # heap property:
    # parent < max(child1, child2)
    # 1 -> 2, 3
    # 2 -> 4, 5
    # 3 -> 6, 7
    # 4 -> 8, 9
    # 5 -> 10, 11
    heapify_up!(q.heap, q.tail)
end

function deque!(q::PQ)
    if q.tail == 0
        return nothing
    end
    item = q.heap[1]
    q.heap[1] = q.heap[q.tail]
    q.tail -= 1
    heapify_down!(q.heap, 1, q.tail)
    return item
end

function update!(q::PQ, id::Any, new::Any)
    i = 0
    while i < length(q.tail)
        i += 1
        if q.heap[i][1] == id
            q.heap[i][2] = new
            break
        end
    end
    curr = i
    parent = Int(floor(i / 2))
    left_child = 2 * i
    right_child = left_child + 1
    if parent >= 1 && q.heap[curr][2] < q.heap[parent][2]
        heapify_up!(q.heap, curr)
    else
        heapify_down!(q.heap, i, q.tail)
    end
end

function getnode(q::PQ, id)
    for i in 1:q.tail
        if q.heap[i][1] == id
            return q.heap[i]
        end
    end
    return nothing
end

function printheap(q::PQ)
    row = 1
    i = 1
    while i <= q.tail
        print(q.heap[i], " ")
        if i + 1 == 2^row
            row += 1
            println()
        end
        i += 1
    end
    println("\n")
end

# q = PQ()
# enqueue!(q, [(1, 1), 20])
# enqueue!(q, [(1, 2), 12])
# enqueue!(q, [(1, 3), 8])
# enqueue!(q, [(4, 1), 49])
# enqueue!(q, [(5, 1), 22])
# enqueue!(q, [(1, 6), 22])
# enqueue!(q, [(7, 1), 2])
# printheap(q)
# deque!(q)
# printheap(q)
# update!(q, (1, 3), 40)
# printheap(q)
# update!(q, (1, 6), 10)
# printheap(q)
# update!(q, (1, 1), 23)
# printheap(q)


const directions = [(-1, 0), (0, 1), (1, 0), (0, -1)]

graph, start, finish = open("input.txt", "r") do io
    lines = readlines(io)
    heightmap = [lines[l][i] for l in 1:length(lines), i in 1:length(lines[1])]
    graph = Dict{NTuple{2, Int}, Vector{NTuple{2, Int}}}()
    start = finish = nothing
    for row in 1:size(heightmap)[1], col in 1:size(heightmap)[2]
        if !((row, col) in keys(graph))
            graph[(row, col)] = []
        end
        for d in directions
            current = (row, col)
            probe = current .+ d
            try
                for coord in [probe, current]
                    if heightmap[coord...] == 'S'
                        start = coord
                        heightmap[coord...] = 'a'
                    end
                    if heightmap[coord...] == 'E'
                        finish = coord
                        heightmap[coord...] = 'z'
                    end
                end
                if heightmap[probe...] - heightmap[current...] <= 1
                    push!(graph[current], probe)
                end
            catch
            end
        end
    end
    return graph, start, finish
end

println(graph)

# Dijkstra
# we start from the start and add the visitable nodes to a priority queue.
# we need to keep track of already visited nodes, maybe with another dict.
# we deque, mark as visited, and add the reachable nodes with priority equal to the length of the path + the edge weight (in this case the edge weight is always 1)

# we start at start and decorate each neighbour node with its distance.
# at the same time, we update / add the nodes to the pq
# we mark the node as visited, deque and repeat.

dijkstra = function(graph, start, finish)
    pq = PQ()
    visited = Set{NTuple{2, Int}}()
    println(visited)
    enqueue!(pq, [start, 0])
    printheap(pq)
    while pq.tail > 0
        current_coord, current_distance = deque!(pq)
        if current_coord == finish
            println(current_distance)
            return
        end
        println("visiting $current_coord, whose distance is $current_distance")
        push!(visited, current_coord)
        for neighbour_coord in graph[current_coord...]
            if !(neighbour_coord in visited)
                # get current distance
                node = getnode(pq, neighbour_coord)
                if node == nothing
                    enqueue!(pq, [neighbour_coord, current_distance + 1])
                else
                    update!(pq, neighbour_coord, current_distance + 1)
                end
            end
        end
    end
end

dijkstra(graph, start, finish)
