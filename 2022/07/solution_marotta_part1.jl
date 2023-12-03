#!/usr/bin/env julia

mutable struct Node
    name::String  # The name of the file or dir
    type::Char  # d for directory, f for file
    size::Union{Int, Missing}  # For a file, the raw size; for a dir, the sum of the sizes of its children
    parent::Union{Node, Nothing}  # The node's parent (for easy traversal)
    children::Dict{String, Node}  # The children of a node (empty for files)
end

findsize(p::Node) = sum([child.size for child in values(p.children)])

const size_cap = 100_000

# Assume that each directory is visited only once
root = Node("/", 'd', missing, nothing, Dict{String, Node}())
open("test.txt", "r") do io
    current = root
    result = 0
    for l in eachline(io)
        println(l)
        if (m = match(r"\$ cd (.*)", l)) != nothing
            # parse command
            if m[1] == "/"
                current = root
            elseif m[1] == ".."
                # moving back to the parent, time to compute the size
                current.size = findsize(current)
                if current.size <= size_cap
                    result += current.size
                end
                current = current.parent
            else
                # entering a new directory
                current = current.children[m[1]]
            end
            println("moving to $(current.name)")
        elseif (m = match(r"dir (.*)", l)) != nothing
            # parse dir
            current.children[m[1]] = Node(m[1], 'd', missing, current, Dict{String, Node}())
        elseif (m = match(r"(\d+) (.+)", l)) != nothing
            # parse file
            current.children[m[2]] = Node(m[2], 'f', parse(Int, m[1]), current, Dict{String, Node}())
        else
            # This is an `$ ls` line, nothing to do
            continue
        end
    end
    # We go back to the root and find the remaining sizes
    while current != nothing
        current.size = findsize(current)
        if current.size <= size_cap
            result += current.size
        end
        current = current.parent
    end
    println(result)
end
