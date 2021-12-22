/*
	This code could definitely be written better.
	but all attempts i have done have introduced bugs.
	its about 10x worse than the old version but much more stable and passes all test cases.

	TODO: Add all test cases to the bottom of this snippet file.
*/
local function extractParmas(str)
	local args = {}

	str = string.Replace(str, "'", '"')

	local a = string.Explode([["]], str)

	if #a == 1 then
		args = string.Explode(" ", a[1])
	else
		for index, stVal in pairs(a) do
			if index % 2 == 0 then
				args[#args+1] = stVal		
			else
				table.Add(args, string.Explode(" ", string.Trim(stVal) ) )
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

/*
concommand.Add("test_param_extraction", function()
	local args = extractParmas("test 'test' 'test2' 'test3 asd'")
	assert(#args == 4)
	assert(args[1] == "test")
	assert(args[2] == "test")
	assert(args[3] == "test2")
	assert(args[4] == "test3 asd")
end)
*/