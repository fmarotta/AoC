#!/usr/bin/env julia

mutable struct Node
    name::String  # The name of the file or dir
    type::Char  # d for directories, f for files
    size::Union{Int, Missing}  # For a file, the raw size; for a dir, the sum of the sizes of its children
    parent::Union{Node, Nothing}  # The node's parent (for easy traversal)
    children::Dict{String, Node}  # The children of a node (empty for files)
end
Node(name::AbstractString, size::Missing, parent::Union{Node, Nothing}) = Node(name, 'd', size, parent, Dict{String, Node}())
Node(name::AbstractString, size::Int, parent::Union{Node, Nothing}) = Node(name, 'f', size, parent, Dict{String, Node}())

function addchild!(p::Node, name::AbstractString, size::Union{Int, Missing})
    n = Node(name, size, p)
    p.children[name] = n
end

findsize(p::Node) = sum([child.size for child in values(p.children)])

const total_disk_space = 70_000_000
const free_space_needed = 30_000_000

# Assume that each directory is visited only once
root = Node("/", missing, nothing)
open("input.txt", "r") do io
    current = root
    for l in eachline(io)
        if (m = match(r"\$ cd (.*)", l)) != nothing
            # parse command
            if m[1] == "/"
                current = root
            elseif m[1] == ".."
                # moving back to the parent
                current.size = findsize(current)
                current = current.parent
            else
                # entering a new directory
                current = current.children[m[1]]
            end
        elseif (m = match(r"dir (.*)", l)) != nothing
            # parse dir
            addchild!(current, m[1], missing)
        elseif (m = match(r"(\d+) (.+)", l)) != nothing
            # parse file
            addchild!(current, m[2], parse(Int, m[1]))
        else
            # This is an `$ ls` line, nothing to do
            continue
        end
    end
    # We go back to the root and find the remaining sizes
    while current != nothing
        current.size = findsize(current)
        current = current.parent
    end
end

total_used_space = root.size
space_to_free = free_space_needed - (total_disk_space - total_used_space)

# traverse breadth-first
queue = [root]
min_size = root.size
while length(queue) > 0
    current = popfirst!(queue)
    if current.size >= space_to_free && current.size < min_size
        global min_size = current.size
    end
    append!(queue, [c for c in values(current.children) if c.type == 'd'])
end
println(min_size)
