function player.FindInSphere(pos, dist)
	dist = dist * dist
	local t = {}
	local l = 0


	for _, ply in ipairs(player.GetAll()) do
		if ply:GetPos():DistToSqr(pos) < dist then
			l = l + 1
			t[l] = ply
		end
	end
	return t, l
end

function player.FindInBox(mins, maxs)
	mins, max = OrderVectors(mins, maxs)
	local players = {}
	local count = 0
	for index, ply in ipairs(player.GetAll()) do
		local pos = ply:GetPos()
		if pos[1] >= mins[1] and pos[1] <= maxs[1] and pos[2] >= mins[2] and pos[2] <= maxs[2] and pos[3] >= mins[3] and pos[3] <= maxs[3] then
			count = count + 1
			players[count] = ply
		end
	end
	return players, count
end
