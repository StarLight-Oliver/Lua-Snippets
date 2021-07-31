function player.FindInSphere(pos, dist)
    dist = dist * dist
    local t = {}
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetPos():DistToSqr(pos) < dist then
            t[#t + 1] = ply
        end
    end
    return t
end

function player.FindInBox(mins, maxs)
	mins, max = OrderVectors(mins, maxs)
	local players = {}
	for index, ply in ipairs(player.GetAll()) do
		local pos = ply:GetPos()
		if pos[1] >= mins[1] and pos[1] <= maxs[1] and pos[2] >= mins[2] and pos[2] <= maxs[2] and pos[3] >= mins[3] and pos[3] <= maxs[3] then
			players[#players + 1] = ply
		end
	end
	return players
end
