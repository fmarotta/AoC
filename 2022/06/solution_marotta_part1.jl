#!/usr/bin/env julia

# We could use a regex or look 4 letters ahead at each position,
# but where's the fun?

const n_states = 4

input = readline()
current = 1  # The current location in the string
state = 1  # The current state (from 1 to n_states)

while current < length(input)
    global current += 1
    state_change = 1
    for i = 1:state
        if input[current] == input[current - i]
            state_change = -(state - i)
            break
        end
    end
    global state += state_change
    if state == n_states
        println(current)
        break
    end
end

