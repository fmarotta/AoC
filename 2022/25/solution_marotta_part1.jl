#!/usr/bin/env julia

# we don't need to convert anything, we can just do column addition
const SNAFU = Dict(
    '=' => -2,
    '-' => -1,
    '0' => 0,
    '1' => 1,
    '2' => 2,
    -2 => '=',
    -1 => '-',
    0 => '0',
    1 => '1',
    2 => '2',
)

const dec2digits = [sum(2 .* 5 .^ (0:i-1)) for i in 1:100]

""" zeropad

pad a string with zeros until the required number of digits.
"""
function zeropad(s, i)
    l = length(s)
    pad = repeat('0', i - l)
    return pad * s
end

function snafu2dec(snafu_vec::Vector{Int})
    sum([snafu_vec[i] * 5^(i-1) for i in 1:length(snafu_vec)])
end

function snafu2dec(snafu_string::String)
    snafu2dec(map(x -> SNAFU[x], reverse(collect(snafu_string))))
end

function dec2snafu(dec_num::Int)
    if dec_num in keys(SNAFU)
        return SNAFU[dec_num]
    end
    flip = false
    if dec_num < 0
        flip = true
        dec_num = -dec_num
    end
    i = 1
    while dec_num > dec2digits[i]
        i += 1
    end
    # println("$dec_num will have $i digits")
    first_digit = round(Int, dec_num / 5^(i-1))
    # println("The first digit is $first_digit")
    # println("the rest is $(dec_num - first_digit * 5^(i-1))")
    if flip
        res = SNAFU[-first_digit] * zeropad(dec2snafu(Int(-dec_num + first_digit * 5^(i-1))), i-1)
    else
        res = SNAFU[first_digit] * zeropad(dec2snafu(Int(dec_num - first_digit * 5^(i-1))), i-1)
    end
    return res
end


for i in 1:63
    println("converting $i to SNAFU")
    println(dec2snafu(i))
    println(snafu2dec("" * dec2snafu(i)))
    if snafu2dec("" * dec2snafu(i)) != i
        @error "Puppaaa"
    end
    println()
end
println(dec2snafu(314159265))
# println(dec2snafu(48))
# exit()

open("input.txt") do io
    col_sums = Int[]
    for snafu in eachline(io)
        num = map(x -> SNAFU[x], reverse(collect(snafu)))
        # println(num)
        for (i, digit) in enumerate(num)
            if length(col_sums) < i
                push!(col_sums, 0)
            end
            col_sums[i] += digit
        end
    end
    println(col_sums)
    println(snafu2dec(col_sums))
    println(dec2snafu(snafu2dec(col_sums)))
    # now we need to take care of the carry-ons.
    # for example, the 1 pos is now 10, which means that we have
    # to carry 2 to the 5 pos, with 0 remaining in the 1 pos.
    # the 5 pos is 11 but it becomes 13. 13 is > 2*pos (2*5) so
    # we can't encode it. We carry 1 to the next position.
    # we carry exactly floor(13 / 2*pos). in the 5 position we have
    # what? well, we added 25, so we need to subtract 12.
    # OK, I think I need a routine to convert from decimal to
    # SNAFU.
end
