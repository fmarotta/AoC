#!/usr/bin/env julia

# Score matrix encoded as the opponent's choice on the rows and the player's
# choice on the column. The order is RPS.
const scorematrix = [3 6 0; 0 3 6; 6 0 3]

# Score vector to find the score due to the player's choice
const scorevector = [1 2 3]

opponentchoice(c::Char) = Int(c) - Int('A') + 1
playerchoice(c::Char) = Int(c) - Int('X') + 1

open("input.txt", "r") do io
    score = 0
    while !eof(io)
        oppo = opponentchoice(read(io, Char))
        sep = read(io, Char)
        player = playerchoice(read(io, Char))
        score += scorematrix[oppo, player] + scorevector[player]
        while !eof(io) && read(io, Char) != '\n'
        end
    end
    println(score)
end
