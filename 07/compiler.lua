line_num = 0


function sub (c)
	asm_file:write("// " .. line_num .. ": sub\n")
  asm_file:write("@SP\nA=M\nA=A-1\nD=M\nA=A-1\nD=M-D\nM=D\n@SP\nM=M-1\n")
 
end

function add (c) 
	asm_file:write("// " .. line_num .. ": add\n")
  asm_file:write("@SP\nA=M\nA=A-1\nD=M\nA=A-1\nD=M+D\nM=D\n@SP\nM=M-1\n")
end

function pop (c)
	--print(line_num .. ": pop " .. string.match(c,"%a+ %d+"))
	seg = string.match(c," %a+")
  n = string.match(c,"%d+")
  asm_file:write("// " .. line_num .. ": pop" .. seg .. " " .. n .."\n");
  --addr = seg + i; SP--; *addr = *SP
	if seg == " local" then
    asm_file:write("@" .. n .."\nD=A\n@LCL\nD=D+M\n@addr\nM=D\n")
    asm_file:write("@SP\nM=M-1\nA=M\nD=M\n")
    asm_file:write("@addr\nA=M\nM=D\n")

  elseif seg == " argument" then
    
    asm_file:write("@" .. n .."\nD=A\n@ARG\nD=D+M\n@addr\nM=D\n")
    asm_file:write("@SP\nM=M-1\nA=M\nD=M\n")
    asm_file:write("@addr\nA=M\nM=D\n")
	elseif seg == " this" then 
    asm_file:write("@" .. n .."\nD=A\n@THIS\nD=D+M\n@addr\nM=D\n")
    asm_file:write("@SP\nM=M-1\nA=M\nD=M\n")
    asm_file:write("@addr\nA=M\nM=D\n")
	elseif seg == " that" then    
    asm_file:write("@" .. n .."\nD=A\n@THAT\nD=D+M\n@addr\nM=D\n")
    asm_file:write("@SP\nM=M-1\nA=M\nD=M\n")
    asm_file:write("@addr\nA=M\nM=D\n")

  elseif seg == " temp" then
    asm_file:write("@" .. n .."\nD=A\n@5\nD=D+A\n@addr\nM=D\n")
    asm_file:write("@SP\nM=M-1\nA=M\nD=M\n")
    asm_file:write("@addr\nA=M\nM=D\n")
	elseif seg == " static" then
    asm_file:write("@SP\nM=M-1\nA=M\nD=M\n")
    asm_file:write("@" .. filename .. "." .. n .. "\nM=D\n")
  else
    asm_file:write("not yet implement\n")
	end
end

function push (c)
	--print(line_num .. ": push " .. string.match(c,"%a+ %d+") )
	seg = string.match(c," %a+")
	n = string.match(c,"%d+")
	asm_file:write("// " .. line_num .. ": push" .. seg .. " " .. n .."\n");
	if seg == " constant" then
		asm_file:write("@" .. n .. "\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
	elseif seg == " local" then
		asm_file:write("@" .. n .. "\nD=A\n@LCL\nA=M\nA=A+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
	elseif seg == " this" then
		asm_file:write("@" .. n .. "\nD=A\n@THIS\nA=M\nA=A+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
	elseif seg == " that" then
		asm_file:write("@" .. n .. "\nD=A\n@THAT\nA=M\nA=A+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
  elseif seg == " argument" then
    asm_file:write("@" .. n .. "\nD=A\n@ARG\nA=M\nA=A+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
  elseif seg == " temp" then
    asm_file:write("@5\nD=A\n@" .. n .. "\nD=D+A\nA=D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
  elseif seg == " static" then
    asm_file:write("@" .. filename .. "." .. n .. "\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
  else
    asm_file:write("not yet implement\n")
	end
end

function eqL (x)
	asm_file:write("//" .. line_num .. ": eq\n")
	asm_file:write("@SP\nM=M-1\nA=M\nD=M\n@SP\nM=M-1\nA=M\nD=M-D\n")
	asm_file:write("@TRUE_" .. line_num .. "\nD;JEQ\n")
	asm_file:write("@SP\nA=M\nM=0\n@END_" .. line_num .. "\n0;JMP\n")
	asm_file:write("\n(TRUE_" .. line_num .. ")\n@SP\nA=M\nM=-1\n(END_" .. line_num .. ")\n@SP\nM=M+1\n")
end

function gtL (x)
	asm_file:write("//" .. line_num .. ": gt\n")
	asm_file:write("@SP\nM=M-1\nA=M\nD=M\n@SP\nM=M-1\nA=M\nD=M-D\n")
	asm_file:write("@TRUE_" .. line_num .. "\nD;JGT\n")
	asm_file:write("@SP\nA=M\nM=0\n@END_" .. line_num .. "\n0;JMP\n")
	asm_file:write("\n(TRUE_" .. line_num .. ")\n@SP\nA=M\nM=-1\n(END_" .. line_num .. ")\n@SP\nM=M+1\n")
end

function ltL (x)
	asm_file:write("//" .. line_num .. ": lt\n")
	asm_file:write("@SP\nM=M-1\nA=M\nD=M\n@SP\nM=M-1\nA=M\nD=M-D\n")
	asm_file:write("@TRUE_" .. line_num .. "\nD;JLT\n")
	asm_file:write("@SP\nA=M\nM=0\n@END_" .. line_num .. "\n0;JMP\n")
	asm_file:write("\n(TRUE_" .. line_num .. ")\n@SP\nA=M\nM=-1\n(END_" .. line_num .. ")\n@SP\nM=M+1\n")
end

function andL (x)
	asm_file:write("//" .. line_num .. ": and\n")
	asm_file:write("@SP\nM=M-1\nA=M\nD=M\n@SP\nM=M-1\nA=M\nD=M&D\nM=D\n")
	asm_file:write("@SP\nM=M+1\n")
end

function notL (x)
	asm_file:write("//" .. line_num .. ": not\n")
	asm_file:write("@SP\nM=M-1\nA=M\nM=!M\n@SP\nM=M+1\n")
end

function orL (x)
	asm_file:write("//" .. line_num .. ": or\n")
	asm_file:write("@SP\nM=M-1\nA=M\nD=M\n@SP\nM=M-1\nA=M\nD=M|D\nM=D\n")
	asm_file:write("@SP\nM=M+1\n")
end

function negL (x)
	asm_file:write("//" .. line_num .. ": neg\n")
  asm_file:write("@SP\nA=M-1\nM=-M\n")
end

local parser = {
	["add"] = add,
	["sub"] = sub,
	["pop"] = pop,
	["push"] = push,
	["eq"] = eqL,
	["gt"] = gtL,
	["lt"] = ltL,
	["and"] = andL,
	["or"] = orL,
	["not"] = notL,
	["neg"] = negL,
}

filename = ""
local vm_file = assert(io.open(arg[1],"r"))
filename = string.match(arg[1],"%a+")
asm_file = assert(io.open(filename .. ".asm","w"))
for line in vm_file:lines() do
	line_num = line_num + 1
	if string.match(line,"%a+") and not string.match(line,"//",0) then
		local cmds = {}
		for c in string.gmatch(line,"%a+") do
			table.insert(cmds,c)
		end
		parser[cmds[1]](line)
		
	end
end


vm_file:close()
asm_file:close()

