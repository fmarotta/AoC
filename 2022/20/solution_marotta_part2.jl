#!/usr/bin/env julia

"""
0  1       . This moves to 1
1  2       . This moves to 3
2  -3      . This moves to 6
3  3       . This moves to 6
4  -2      .
5  0       .
6  4       .

    0    1    2    3    4    5    6
    -------------------------------

0)  1    2   -3    3   -2    0    4 

1 goes from 0 to 1; all numbers at positions (0, 1] unshift.
1)  2    1   -3    3   -2    0    4 

2 goes from 0 to 2; all numbers at positions (0, 2] unshift.
2)  1   -3    2    3   -2    0    4

-3 goes from 1 to 4 (!); all numbers in (1, 4] unshift.
3)  1    2    3   -2   -3    0    4

3 goes from 2 to 5; all numbers in (2, 5] unshift.
4)  1    2   -2   -3    0    3    4

-2 goes from 2 to 6 (!); all numbers in (2, 6] unshift.
5)  1    2   -3    0    3    4   -2

0 does not move
6)  1    2   -3    0    3    4   -2

4 moves from 5 to 3; all numbers in [3, 5) (!) shift (!)
7)  1    2   -3    4    0    3   -2


... you get the idea. In one pass, we can compute how many times
each number unshifts.

# rules
if the range is reversed, we shift; if the range is OK, we unshift.
wraps can be ignored, the only thing that matters is that numbers
in the (from, to] range unshift (or shift), and the number itself
shifts (or unshifts) of to - from.

in one pass, we can get which numbers shift.
Then, we find which original position + shift equals 1000, 2000, 3000.
We get the numbers at that position in the original array, and we're done.

no, wait, we need to know where the second number is. well, the second number
is at the second position plus its shift/unshift.
"""

const multiplier = 811589153
# const multiplier = 1

open("input.txt") do io
    numbers = multiplier * parse.(Int, readlines(io))
    println(numbers)
    shifts = zeros(Int, length(numbers))
    for mixing in 1:10
        for (i, n) in enumerate(numbers)
            # number i moves from i + shifts[i] to i + shifts[i] + numbers[0]
            from = (i - 1) + shifts[i]
            to = (from + numbers[i])
            # println("$(numbers[i]) moves from $from to $to")
            # if to <= 0 && numbers[i] < 0
                # println("$to <= 0 so we add $(Int(floor((to - 1) / length(numbers))))")
                # to += Int(floor((to - 1) / length(numbers)))
            # elseif to > length(numbers)
                # println("$to > $(length(numbers)), so we add $(Int(floor(to / length(numbers))))")
                # to += Int(floor(to / length(numbers)))
                # println(to)
            # end
            to = mod(to, length(numbers) - 1)
            # println("$(numbers[i]) moves from $from to $to")
            if to > from
                # println("we have to shift all numbers in [$(from+2), $(to+1)]")
                # these are all numbers whose index + shift is within the range.
                range = [n for n in 1:length(numbers) if from + 2 <= n + shifts[n] <= to + 1]
                @. shifts[range] -= 1
            elseif from > to
                # println("we have to shift all numbers in [$(to+1), $(from)]")
                range = [n for n in 1:length(numbers) if to + 1 <= n + shifts[n] <= from]
                @. shifts[range] += 1
            end
            shifts[i] += to - from
            # println(numbers)
            # println(shifts)
            # newnumbers = []
            # for target in 1:length(numbers)
            #     index = [n for n in 1:length(numbers) if n + shifts[n] == target]
            #     push!(newnumbers, numbers[index...])
            # end
            # println(newnumbers)
        end
        println()
        println()
        println()
        # println(numbers)
        # println(shifts)
        newnumbers = []
        for target in 1:length(numbers)
            index = [n for n in 1:length(numbers) if n + shifts[n] == target]
            push!(newnumbers, numbers[index...])
        end
        println(newnumbers)
        # println(numbers)
        # println(shifts)
    end

    # locate the value 0
    i = 1
    while numbers[i] != 0
        i += 1
    end
    println(i)
    pos = i + shifts[i] - 1
    println("zero is at position $pos")
    targets = [(pos + t) % length(numbers) for t in [1000, 2000, 3000]]
    # println(targets)
    indices = [n for n in 1:length(numbers) if n + shifts[n] in targets .+ 1]
    # println(indices)
    # println(numbers[indices])
    println(sum(numbers[indices]))
end
