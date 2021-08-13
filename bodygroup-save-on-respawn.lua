/*
	This is a simple bodygroup save after death.
	This isn't tested but should work
*/

local handleDeath = function(ply)
	// get all bodygroup data from the player
	local bodygroupCount = table.Count(ply:GetBodyGroups())
	local bodygroups = {}
	for i = 0, bodygroupCount - 1 do
		bodygroups[i] = ply:GetBodyGroup(i)
	end


	ply._bodygroupData = {
		bodygroups, ply:GetModel()
	}
end

local handleSpawn = function(ply)
	// timer simple for 0 ticks
	if ply._bodygroupData then
		local bodygroups = ply._bodygroupData.bodygroups
		local model = ply._bodygroupData.model
		
		timer.Simple(0, function()

			if !IsValid(ply) or !ply:IsAlive() then return end

			// set the player's bodygroups to whats saved in the bodygroupData

			// if the model isnt the same as the one we saved, we return
			if not model == ply:GetModel() then
				return
			end

			// set the bodygroups
			for i = 0, table.Count(bodygroups) - 1 do
				ply:SetBodyGroup(i, bodygroups[i])
			end
		end)
	end

	// set the store to nil
	ply._bodygroupData = nil
end

hook.Add("PlayerDeath", "SaveBodygroupsOnDeath", handleDeath)
hook.Add("PlayerSilentDeath", "SaveBodygroupsOnDeath", handleDeath)

hook.Add("PlayerSpawn", "LoadBodygroupsOnSpawn", handleSpawn)
