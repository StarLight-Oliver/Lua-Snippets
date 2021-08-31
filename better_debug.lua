

betterdebug = betterdebug or {}
betterdebug.lines = betterdebug.lines or {}

if SERVER then
	util.AddNetworkString("betterdebug_lines")

	function betterdebug.Line(start, endpos, color, time)

		local line = {
			start = start,
			endpos = endpos,
			color = color,
			time = time or 1,
		}

		table.insert(betterdebug.lines, line)
	end

	hook.Add("Tick", "betterdebug_crash_prevent", function()
		local lines = betterdebug.lines
		
		local lineCount = #lines
		
		if lineCount == 0 then return end


		net.Start("betterdebug_lines")
			net.WriteUInt(lineCount, 16)
			for i = 1, lineCount do
				local line = lines[i]
				net.WriteVector(line.start)
				net.WriteVector(line.endpos)
				net.WriteUInt(line.color.r, 8)
				net.WriteUInt(line.color.g, 8)
				net.WriteUInt(line.color.b, 8)
				net.WriteUInt(line.color.a, 8)
				net.WriteFloat(line.time)
			end
		net.Broadcast()

		betterdebug.lines = {}
	end)

/*

hook.Add("Think", "test_render_lines", function()
	local ply = player.GetAll()[1]
	
	local oldPos = ply.oldPos or ply:GetPos()
	local pos = ply:GetPos()
	
	local delta = pos - oldPos
	local len = delta:Length()
	
	for i = 1,  10 do
		local pos = oldPos + delta * (i / 10) * len
		local color = Color(255, 255, 255, 255)
		
		
		betterdebug.Line(pos, pos + Vector(0,0, 10), Color(255, 0, 0, 255), 5)
	end
end)
*/


else
	
	net.Receive("betterdebug_lines", function()
		local lineCount = net.ReadUInt(16)

		for i = 1, lineCount do
			local start = net.ReadVector()
			local endpos = net.ReadVector()
			local color = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
			local time = net.ReadFloat()

			local line = {
				start = start,
				endpos = endpos,
				color = color,
				time = time + CurTime(),
			}
			table.insert(betterdebug.lines, line)
		end
	end)

	hook.Add("PostDrawTranslucentRenderables", "betterdebug.drawline", function()

		render.SetColorMaterial()

		for k, line in pairs(betterdebug.lines) do
			if line.time < CurTime() then
				table.remove(betterdebug.lines, k)
				continue 
			end

			render.DrawLine(line.start, line.endpos, line.color)
		end
	end)
end