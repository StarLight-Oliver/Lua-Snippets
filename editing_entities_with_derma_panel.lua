if SERVER then
	
	//SV FILE
	util.AddNetworkString("writeSmth")

	function ENT:Use(ply)
		if ply:IsPlayer() then
			ply.entity = self

			net.Start("writeSmth")
				net.WriteEntity(self)
			net.Send(ply)
		end
	end
	
	net.Receive("writeSmth", function(len, ply)
		local ent = ply.entity
		if not IsValid(ent) then return end
		local mdl = net.ReadString()

		ent:SetModel(mdl)
	end)

else
	// CL FILE
	local openMenu = function(ent)
		timer.Simple(1, function()
			net.Start("writeSmth")
				net.WriteString("models/error/error.mdl")
			net.SendToServer()
		end)
	end

	net.Receive("writeSmth", function(len)
		local ent = net.ReadEntity()

		openMenu(ent)	
	end)
end
