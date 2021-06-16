
function table.sortfucked(tbl, func)
	local keyTbl = table.GetKeys(tbl)

	table.sort(keyTbl, function(a, b) return func(tbl[a], tbl[b]) end)

	local newTbl = {}

	for index, value in ipairs(keyTbl) do
		newTbl[index] = tbl[value]
	end

	return newTbl
end

local tbl = {
	["name"] = {
		Order = 1,
	},
	[1] = {
		Order = 2,
	},
}


local a = table.sortfucked(tbl, function(a, b) return a.Order < b.Order end)

PrintTable(a)