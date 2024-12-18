function read_puzzle(file)
    s = read(file, String)
    reg, prog = split(s, "\n\n")
    regs = split(reg, "\n")
    rega = parse(Int, split(regs[1], ": ")[2])
    regb = parse(Int, split(regs[2], ": ")[2])
    regc = parse(Int, split(regs[3], ": ")[2])
    program = parse.(Int, split(replace(prog, "Program: " => ""), ","))
    program, (rega = rega, regb = regb, regc = regc)
end

function combo(operand, A, B, C)
    0 <= operand <= 3 && return operand
    operand == 4 && return A
    operand == 5 && return B
    operand == 6 && return C
    @assert false, "Invalid operand $operand"
end

function compute(program; rega = 0, regb = 0, regc = 0, opcode = 1)
    outputs = []
    while opcode < length(program)
        instruction = program[opcode]
        litop = program[opcode + 1]
        combop = combo(litop, rega, regb, regc)
        if instruction == 0
            rega >>= combop
            opcode += 2
        elseif instruction == 1
            regb ⊻= litop
            opcode += 2
        elseif instruction == 2
            regb = combop & 7
            opcode += 2
        elseif instruction == 3
            opcode = if rega != 0
                litop + 1
            else
                opcode + 2
            end
        elseif instruction == 4
            regb ⊻= regc
            opcode += 2
        elseif instruction == 5
            push!(outputs, combop & 7)
            opcode += 2
        elseif instruction == 6
            regb = rega >> combop
            opcode += 2
        elseif instruction == 7
            regc = rega >> combop
            opcode += 2
        end
    end
    join(outputs, ',')
end

# one iteration (for my input!) is
function iter(a)
    b1 = a & 7
    b2 = b1 ⊻ 1
    b3 = b2 ⊻ (a >> b2)
    b4 = b3 ⊻ 4
    b5 = b4 & 7
    b5
end

# returns all values of rega that yield target (mod 8) in regb
function reviter(target, rega)
    res = []
    for a in rega:rega+7
        if iter(a) == target
            push!(res, a)
        end
    end
    res
end

function traverse(p, rega, cycle)
    if cycle <= 0
        return rega
    end
    res = []
    for r in reviter(p[cycle], rega << 3)
        append!(res, traverse(p, r, cycle - 1))
    end
    minimum(res, init=typemax(Int))
end

p, regs = read_puzzle(ARGS[1])
compute(p; regs...) |> println
traverse(p, 0, 16) |> println

"""
Program: X,X,X,X,X,X,X,X,X,X,0,3,5,5,3,0 (redacted)

at the end of the program, 

intsruction 3-0 cycle 16
    regA must be 0
    regB must be 0 (mod 8)
5-5
instruction 0-3 cycle 16
    regA must be 0-7 => regA must be 5 (this instruction will set it to 0)
    regB must be 0 (mod 8)
instruction 1-4 cycle 16
    regA must be 5
    regB must be something
...
instruction 3-0 cycle 15
    regA must be 5
    regB must be 3 (mod 8)
5-5
instruction 0-3 cycle 15
    regA must be 5 * 8 + something less than 8 => regA must be 46 because iter(46) == 3
    regB must be 3 (mod 8)
...
instruction 0-3 cycle 14
    regA must be 46*8 + something less than 8 => regA must be 368
    regB must be 5 (mod 8)

"""
