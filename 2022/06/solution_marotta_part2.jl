#!/usr/bin/env julia

function statemachine(input, n_states, state = 1, current = 1)
    while current < length(input)
        current += 1
        state_change = 1
        for i = 1:state
            if input[current] == input[current - i]
                state_change = -(state - i)
                break
            end
        end
        state += state_change
        if state == n_states
            return current
        end
    end
    return 0
end

# Using collect to convert the input to a Vector{Char} makes it ~1000 times faster...
println(statemachine(collect(readline()), 14))
