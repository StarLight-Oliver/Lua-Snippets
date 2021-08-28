/*
This is a first write of these functions.
No optimisation has been done.
and test need to be done.
*/

local util = util

local math_sqrt = math.sqrt

function util.IntersectRayWithCircle(center, radius, dir, startPos)
	local a = dir.x * dir.x + dir.y * dir.y
	local b = 2 * (dir.x * (startPos.x - center.x) + dir.y * (startPos.y - center.y))
	local c = (startPos.x - center.x) * (startPos.x - center.x) + (startPos.y - center.y) * (startPos.y - center.y) - radius * radius
	local delta = b * b - 4 * a * c
	if delta < 0 then return nil end
	local sqrtDelta = math_sqrt(delta)
	local t1 = (-b - sqrtDelta) / (2 * a)
	local t2 = (-b + sqrtDelta) / (2 * a)
	if t1 > t2 then
		local tmp = t1
		t1 = t2
		t2 = tmp
	end
	if t2 < 0 then return nil end

	local pos1 = startPos + dir * t1
	local pos2 = startPos + dir * t2

	return pos1, pos2
end


function util.IntersectRayWithSphere(center, radius, dir, startPos)
	local a = dir.x * dir.x + dir.y * dir.y + dir.z * dir.z
	local b = 2 * (dir.x * (startPos.x - center.x) + dir.y * (startPos.y - center.y) + dir.z * (startPos.z - center.z))
	local c = (startPos.x - center.x) * (startPos.x - center.x) + (startPos.y - center.y) * (startPos.y - center.y) + (startPos.z - center.z) * (startPos.z - center.z) - radius * radius
	local delta = b * b - 4 * a * c
	if delta < 0 then return nil end
	local sqrtDelta = math_sqrt(delta)
	local t1 = (-b - sqrtDelta) / (2 * a)
	local t2 = (-b + sqrtDelta) / (2 * a)
	if t1 > t2 then
		local tmp = t1
		t1 = t2
		t2 = tmp
	end
	if t2 < 0 then return nil end

	local pos1 = startPos + dir * t1
	local pos2 = startPos + dir * t2

	return pos1, pos2
end
/*
An example usage
hook.Add("HUDPaint", "asdasd", function()
	local center = Vector(ScrW() / 2, ScrH() / 2, 0)
	local radius = ScrH() / 4
	local dir = Vector(-1, -1, 0)
	local startPos = center + Vector(0, 100,0)
	
	local pos1, pos2 = util.IntersectRayWithCircle(center, radius, dir, startPos)
	
	// draw circle
	surface.DrawCircle(center.x, center.y, radius, 255,255,255)
	
	// draw start pos
	surface.DrawCircle(startPos.x, startPos.y, 5, 0,0,255)
	
	if pos1 then
		surface.SetDrawColor(255, 0, 0, 255)
		surface.DrawLine(pos1.x, pos1.y, pos2.x, pos2.y)
	end
end)
*/
