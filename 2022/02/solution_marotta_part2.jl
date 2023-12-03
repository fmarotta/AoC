#!/usr/bin/env julia

# Gives the move that the player must play in order to get the desired
# outcome
const reversescorematrix = [3 1 2; 1 2 3; 2 3 1]

# Score matrix encoded as the opponent's choice on the rows and the player's
# choice on the column. The order is RPS.
const scorematrix = [3 6 0; 0 3 6; 6 0 3]

# Score vector to find the score due to the player's choice
const scorevector = [1 2 3]

opponentchoice(c::Char) = Int(c) - Int('A') + 1
finaloutcome(c::Char) = Int(c) - Int('X') + 1

open("input.txt", "r") do io
    score = 0
    while !eof(io)
        oppo = opponentchoice(read(io, Char))
        sep = read(io, Char)
        outcome = finaloutcome(read(io, Char))
        player = reversescorematrix[oppo, outcome]
        score += scorematrix[oppo, player] + scorevector[player]
        while !eof(io) && read(io, Char) != '\n'
        end
    end
    println(score)
end
