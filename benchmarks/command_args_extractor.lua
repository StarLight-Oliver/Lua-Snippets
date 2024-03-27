--[[
	This code could definitely be written better.
	but all attempts i have done have introduced bugs.
	its about 10x worse than the old version but much more stable and passes all test cases.

	TODO: Add all test cases to the bottom of this snippet file.
]]
local function extractParmas(str)
	local args = {}
	str = string.Replace(str, "'", '"')
	local a = string.Explode([["]], str)

	if #a == 1 then
		args = string.Explode(" ", a[1])
	else
		for index, stVal in pairs(a) do
			if index % 2 == 0 then
				args[#args + 1] = stVal
			else
				table.Add(args, string.Explode(" ", string.Trim(stVal)))
			end
		end
	end

	for index, st in pairs(args) do
		if st == "" then
			table.RemoveByValue(args, st)
		end
	end

	return args
end

local function extractParmasPatterns(input)
	local args = {}
		local pattern1 = "(%b\"\")"
		local pattern2 = "(%b\'\')"
		local pattern3 = "([%S]+)"
		local index = 1

		while index <= #input do
			local char = input:sub(index, index)
			local arg
			local argEnd

			if char == "\"" then
				arg, argEnd, text = input:find(pattern1, index)

				if arg then
					text = text:sub(2, #text - 1)
				end
			elseif char == "'" then
				arg, argEnd, text = input:find(pattern2, index)

				if arg then
					text = text:sub(2, #text - 1)
				end
			end

			if not arg then
				arg, argEnd, text = input:find(pattern3, index)
			end

			if arg then
				table.insert(args, text)
				index = argEnd + 1
			end

			index = index + 1
		end

		return args
	end


	local input1 = 'a b c'
	local input2 = 'a "b c" d'
	local input3 = 'a b" c d'
	local args1 = ExtractArgs(input1)
	local args2 = ExtractArgs(input2)
	local args3 = ExtractArgs(input3)
	print(#args1, #args2, #args3)
	PrintTable(args1) -- Output: { "a", "b", "c" }
	PrintTable(args2) -- Output: { "a", "b c", "d" }
	PrintTable(args3) -- Output: { "a", "b\"", "c", "d" }
--[[
concommand.Add("test_param_extraction", function()
	local args = extractParmas("test 'test' 'test2' 'test3 asd'")
	assert(#args == 4)
	assert(args[1] == "test")
	assert(args[2] == "test")
	assert(args[3] == "test2")
	assert(args[4] == "test3 asd")
end)
]]

local testSize = 10000

local explodeTime = 0

local testStr = "test 'test' 'test2' 'test3 asd' ahhhasdasd \"asdasdasd \"asdasdadas\""

for x = 1, testSize do
	local start = SysTime()
	local args = extractParmas(testStr)
	explodeTime = explodeTime + (SysTime() - start)
end

print("explodeTime", explodeTime)

local patternTime = 0

for x = 1, testSize do
	local start = SysTime()
	local args = extractParmasPatterns(testStr)
	patternTime = patternTime + (SysTime() - start)
end

print("patternTime", patternTime)

local timeTbl =  {
	[patternTime] = "patternTime",
	[explodeTime] = "explodeTime"
}
PrintTable(timeTbl)