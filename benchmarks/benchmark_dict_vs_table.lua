
local t = {
	"a", "b", "c", "d",
}

local d = {
	a = true,
	b = true,
	c = true,
	d = true,
	e = true,
	f = true,
	g = true,
	h = true,
	i = true,
	j = true,
	k = true,
	l = true,
	m = true,
	n = true,
	o = true,
	p = true,
	q = true,
	r = true,
	s = true,
	t = true,
	u = true,
	v = true,
	w = true,
	x = true,
	y = true,
	z = true,
}

local startTime = SysTime()


for _, a in ipairs(t) do
	if a == "a" then break end
end

local endTime = SysTime()


local dictTime = SysTime()

if d["k"] == "z" then end

local dictETime = SysTime()



local tableTime = endTime - startTime
local dictTime = dictETime - dictTime


print("The table took ", tableTime)
print("The dict took", dictTime)

if dictTime < tableTime then
	print(  ((tableTime/dictTime ) * 100) - 100, "Dictonary lookups are this more efficent")
end
