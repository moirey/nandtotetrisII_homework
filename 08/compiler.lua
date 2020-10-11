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
    asm_file:write("@" .. vm_filename .. "." .. n .. "\nM=D\n")
	 elseif seg == " pointer" and n == "0" then
    asm_file:write("@SP\nM=M-1\nA=M\nD=M\n@THIS\nM=D\n")
  elseif seg == " pointer" and n == "1" then
    asm_file:write("@SP\nM=M-1\nA=M\nD=M\n@THAT\nM=D\n")
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
    asm_file:write("@" .. vm_filename .. "." .. n .. "\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
	elseif seg == " pointer" and n == "0" then
    asm_file:write("@THIS\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
  elseif seg == " pointer" and n == "1" then
    asm_file:write("@THAT\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
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

function label (x)
	name = string.match(x, " %S+"):sub(2)
	asm_file:write("//" .. line_num .. ": label " .. name .. "\n")
  asm_file:write("(" .. name .. ")\n")
end

function if_goto (x)
	name = string.match(x, " %S+"):sub(2)
	asm_file:write("//" .. line_num .. ": if-goto " .. name .. "\n")
	-- if true goto
	-- true = 11111111 = -1 ( less than 0)
  asm_file:write("@SP\nM=M-1\nA=M\nD=M\n@" .. name .. "\nD;JLT\n")
end

function gotoB (x)
	name = string.match(x, " %S+"):sub(2)
	asm_file:write("//" .. line_num .. ": goto " .. name .. "\n")
  asm_file:write("@" .. name .. "\n0;JMP\n")
	
end

function functionF (x)
	-- print(x .. "\n")
	-- function simplefunction.test 2
	name = string.match(x, " %S+"):sub(2)
	vars = string.match(x, "%d+")
	asm_file:write("//" .. line_num .. ": function " .. name .. " " .. vars .. "\n")
  asm_file:write("(" .. name .. ")\n")
	for i=1,tonumber(vars) do
		asm_file:write("@0\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
	end

end
-- endframe use r13 to tmp address
-- returnAddress use r14 to tmp address
function returnF (x)
	asm_file:write("//" .. line_num .. ": return\n")
	asm_file:write("@LCL\nD=M\n@13\nM=D\n")
	asm_file:write("@5\nD=D-A\nA=D\nD=M\n@14\nM=D\n")
	-- *arg = pop()
  asm_file:write("@0\nM=M-1\nA=M\nD=M\n@ARG\nA=M\nM=D\n")
	
	-- sp = arg+1
	asm_file:write("@ARG\nD=M\n@SP\nM=D+1\n")
	-- that = *(13 - 1)
  asm_file:write("@13\nD=M\n@1\nD=D-A\nA=D\nD=M\n@THAT\nM=D\n")
	asm_file:write("@13\nD=M\n@2\nD=D-A\nA=D\nD=M\n@THIS\nM=D\n")
	asm_file:write("@13\nD=M\n@3\nD=D-A\nA=D\nD=M\n@ARG\nM=D\n")
	asm_file:write("@13\nD=M\n@4\nD=D-A\nA=D\nD=M\n@LCL\nM=D\n")
  asm_file:write("@14\nA=M\n0;JMP\n")
end

function callF (x)
	--print(x .. "\n")
	name = string.match(x, " %S+"):sub(2)
	args = string.match(x, " %d+")
	if not args then args = 0 else args = args:sub(2) end

	asm_file:write("//" .. line_num .. ": call " .. name .. " " .. args .. "\n")

	-- return symbol
	-- functionName$ret.i
	local retName = name .. "$ret." .. line_num;
	-- push returnAddress
	asm_file:write("@" .. retName .. "\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n");
	asm_file:write("@LCL\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n");
	asm_file:write("@ARG\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n");
	asm_file:write("@THIS\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n");
	asm_file:write("@THAT\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n");

	-- arg = sp-5-nargs
	asm_file:write("@SP\nD=M\n@5\nD=D-A\n@" .. args .. "\nD=D-A\n@ARG\nM=D\n")
	asm_file:write("@SP\nD=M\n@LCL\nM=D\n")
	parser["goto"]("goto " .. name)
	asm_file:write("(" .. retName .. ")\n")
end

parser = {
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
	["label"] = label,
	["if-goto"] = if_goto,
	["goto"] = gotoB,
	["function"] = functionF,
	["return"] = returnF,
	["call"] = callF,
}


function parser_file (file)
	for line in vm_file:lines() do
		line_num = line_num + 1
		if string.sub(line,1,2) == "//" then
			-- do nothing
		elseif string.match(line,"(%a+)-(%a+)") then
			parser["if-goto"](line)
		elseif string.match(line,"%a+") then
			--print(line .. "\n")
			local cmds = {}
			for c in string.gmatch(line,"%a+") do
				--print(c .. "\n")
				table.insert(cmds,c)
			end
			--print("cmds[1] " .. cmds[1] .. "\n")
			parser[cmds[1]](line)
		end
	end
	
end

asm_filename = ""
asm_filename = string.match(arg[1],"%a+")
asm_file = assert(io.open(asm_filename .. "/" .. asm_filename .. ".asm","w"))

vm_filename = ""

-- sp = 256
asm_file:write("// boot code - sp = 256\n")
asm_file:write("@256\nD=A\n@SP\nM=D\n")
-- call Sys.init
asm_file:write("// boot code - call Sys.init\n")
parser["call"]("call Sys.init")

local extname = string.match(arg[1],"%a+.vm")

if not extname then
	local files = io.popen("ls " .. arg[1] .. "/*.vm")
	for filename in files:lines() do		
		vm_file = assert(io.open(filename,"r"))
		ind, rem = string.find(filename,[[//]],1)
		vm_filename = filename:sub(ind+2)

		parser_file(vm_file)
		vm_file:close()
	end
	files:close()
else
	vm_file = assert(io.open(arg[1],"r"))
	parser_file(vm_file)
	vm_file:close()
end


asm_file:close()

