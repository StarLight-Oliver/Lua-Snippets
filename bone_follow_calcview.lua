

hook.Add("CalcView", "asdasd", function(ply, _pos, _ang, fov)



	local head = ply:LookupBone("ValveBiped.Bip01_Head1")


	if head == -1 then return end // Cam is fucked
	-- local pos, ang = ply:GetBonePosition(head)

	local matrix = LocalPlayer():GetBoneMatrix(head)
	local pos = matrix:GetTranslation()
	local ang = matrix:GetAngles()

	print(ply:GetPos(), pos)
	//print(pos)


	return {
		origin = pos - _ang:Forward() * 100 + _ang:Up() * 10 + _ang:Right() * 10,
		angles = _ang,
		drawviewer = true,
	}

end)