
local function handleDeath(ply)
	local bodygroupCount = table.Count(ply:GetBodyGroups())
	local bodygroups = {}
	for i = 0, bodygroupCount - 1 do
		bodygroups[i] = ply:GetBodygroup(i)
	end

	ply._bodygroupData = {
		bodygroups, ply:GetModel()
	}
end

local function handleSpawn(ply)
	if not ply._bodygroupData then return end

	local bodygroups = ply._bodygroupData[1]
	local model = ply._bodygroupData[2]

	timer.Simple(0, function()
		if not IsValid(ply) or not ply:IsAlive() then return end
		if model != ply:GetModel() then return end

		for i = 0, table.Count(bodygroups) - 1 do
			ply:SetBodygroup(i, bodygroups[i])
		end
	end)

	ply._bodygroupData = nil
end

hook.Add("PlayerDeath", "SaveBodygroupsOnDeath", handleDeath)
hook.Add("PlayerSilentDeath", "SaveBodygroupsOnDeath", handleDeath)

hook.Add("PlayerSpawn", "LoadBodygroupsOnSpawn", handleSpawn)