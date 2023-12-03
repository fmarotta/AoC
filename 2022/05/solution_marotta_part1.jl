#!/usr/bin/env julia

# We could peek into the input file and notice that there are just nine
# stacks and roughly 50 items, so we could just create nine arrays of 50
# elements each. But let's pretend that we just know how many stacks
# there are.

const nstacks = 9

mutable struct Node{T}
    payload::T
    prev::Union{Node{T}, Nothing}
end

mutable struct Stack{T}
    top::Union{Node{T}, Nothing}
    bottom::Union{Node{T}, Nothing}
end

function prepend!(stack::Stack{T}, item::T) where T
    node = Node{T}(item, nothing)
    if isnothing(stack.bottom)
        stack.top = stack.bottom = node
    else
        stack.bottom.prev = node
        stack.bottom = node
    end
end

function append!(stack::Stack{T}, item::T) where T
    node = Node{T}(item, nothing)
    if isnothing(stack.top)
        stack.top = stack.bottom = node
    else
        node.prev = stack.top
        stack.top = node
    end
end

function pop!(stack::Stack{T}) where T
    node = stack.top
    stack.top = node.prev
    return node.payload
end

stacks = Vector{Stack{Char}}(undef, nstacks)
for i in 1:length(stacks)
    stacks[i] = Stack{Char}(nothing, nothing)
end

io = open("input.txt", "r")

# read the initial configuration
for line = eachline(io)
    if match(r"^ 1 ", line) != nothing
        _ = readline(io) # skip the empty line
        break
    end
    # With n stacks we are going to have 3n + n - 1 = 4n-1 chars
    for stack in 1:nstacks
        if line[4(stack - 1) + 1] == '['
            prepend!(stacks[stack], line[4(stack - 1) + 2])
        end
    end
end

while !eof(io)
    line = readline(io)
    move = match(r"move (\d+) from (\d+) to (\d+)", line)
    how_many = parse(Int, move.captures[1])
    from = parse(Int, move.captures[2])
    to = parse(Int, move.captures[3])
    println(how_many)
    println(from)
    println(to)
    println()
    while how_many > 0
        item = pop!(stacks[from])
        append!(stacks[to], item)
        how_many -= 1
    end
end

# print everything
pointers = Vector{Union{Node{Char}, Nothing}}(undef, nstacks)
for i in 1:nstacks
    print(" $i  ")
    pointers[i] = stacks[i].top
end
println()
done = false
while !done
    global done = true
    for i in 1:nstacks
        if pointers[i] != nothing
            print("[$(pointers[i].payload)] ")
            pointers[i] = pointers[i].prev
            global done = false
        else
            print("    ")
        end
    end
    println()
end

# Get the answer
for s in stacks
    print(s.top.payload)
end
