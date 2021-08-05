// an example of a way to extend the net library

function net.WriteSaberData(tbl)
	net.WriteUInt(table.Count(tbl), 16)

	for saberKey, data in pairs(tbl) do
		net.WriteString(saberKey)
		net.WriteType(data)
	end
end




// Read

function net.ReadSaberData()
	local tbl = {}

	local count = net.ReadUInt(16)

	for x = 1, count do
		tbl[net.ReadString()] = net.ReadType()
	end

	return tbl
end

local playerData = {}
if SERVER then
	local syncSaberData = function(ply)

		net.Start("syncSaberData")
		net.WriteUInt(table.Count(playerData, 16))
		for steamID, data in pairs(playerData) do
			net.WriteString(ply:SteamID64())
			net.WriteSaberData(player)
		end
		net.Send(ply)
	end

else


	net.Receive("syncSaberData", function()
		local data = {}
		for playerCount = 1, net.ReadUInt(16) do
			data[net.ReadString()] = net.ReadSaberData()
		end
	end)

end