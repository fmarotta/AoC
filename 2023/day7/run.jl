@enum HandType high pair twopair three full four five

function parse_hand(hand; part = 1)
    return map(collect(hand)) do card
        if isdigit(card)
            return parse(Int, card)
        elseif 'T' == card
            return 10
        elseif 'J' == card
            if 2 == part
                return 1
            else
                return 11
            end
        elseif 'Q' == card
            return 12
        elseif 'K' == card
            return 13
        elseif 'A' == card
            return 14
        else
            throw(card)
        end
    end
end

function get_hand_type(hand; part = 1)
    occurrences = zeros(Int, 14)
    for card in hand
        occurrences[card] += 1
    end
    if 1 == part
        if any(5 .== occurrences)
            return five
        elseif any(4 .== occurrences)
            return four
        elseif any(3 .== occurrences) && any(2 .== occurrences)
            return full
        elseif any(3 .== occurrences)
            return three
        elseif length(findall(x -> 2 == x, occurrences)) == 2
            return twopair
        elseif length(findall(x -> 2 == x, occurrences)) == 1
            return pair
        else
            return high
        end
    else
        jokers = occurrences[1]
        occurrences = occurrences[2:end]
        if any(5 .== occurrences) || 5 == jokers
            return five
        elseif any(4 .== occurrences)
            if 1 == jokers
                return five
            end
            return four
        elseif any(3 .== occurrences) && any(2 .== occurrences)
            return full
        elseif any(3 .== occurrences)
            if 2 == jokers
                return five
            elseif 1 == jokers
                return four
            end
            return three
        elseif length(findall(x -> 2 == x, occurrences)) == 2
            if 1 == jokers
                return full
            end
            return twopair
        elseif length(findall(x -> 2 == x, occurrences)) == 1
            if 3 == jokers
                return five
            elseif 2 == jokers
                return four
            elseif 1 == jokers
                return three
            end
            return pair
        else
            if 4 == jokers
                return five
            elseif 3 == jokers
                return four
            elseif 2 == jokers
                return three
            elseif 1 == jokers
                return pair
            end
            return high
        end
    end
end

function read_puzzle(file; part=1)
    hands = []
    for l in eachline(file)
        hand, bid = split(l)
        parsed_hand = parse_hand(hand; part)
        typeof_hand = get_hand_type(parsed_hand; part)
        push!(hands, (typeof_hand, parsed_hand, parse(Int, bid)))
    end
    return hands
end

function ordering(x, y)
    # is x less thn y?
    typex, typey = x[1], y[1]
    restx, resty = x[2], y[2]
    if typex < typey
        return true
    elseif typex > typey
        return false
    end
    for i in 1:length(restx)
        if restx[i] < resty[i]
            return true
        elseif restx[i] > resty[i]
            return false
        end
    end
    return false
end

function compute(hands)
    res = 0
    for (i, h) in enumerate(sort(hands, lt = (x, y) -> ordering(x, y)))
        # println(h)
        res += i * h[3]
    end
    return res
end


hands1 = read_puzzle("input", part = 1)
println(compute(hands1))
hands2 = read_puzzle("input", part = 2)
println(compute(hands2))
