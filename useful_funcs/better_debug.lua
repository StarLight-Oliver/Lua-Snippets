/*
	Have you ever had debug just not work?
	Well this fixes it.
*/

betterdebug = betterdebug or {}
betterdebug.lines = betterdebug.lines or {}
betterdebug.boxes = betterdebug.boxes or {}

if SERVER then
	util.AddNetworkString("betterdebug_lines")
	util.AddNetworkString("betterdebug_boxes")

	function betterdebug.Line(start, endpos, color, time)

		local line = {
			start = start,
			endpos = endpos,
			color = color,
			time = time or 1,
		}

		table.insert(betterdebug.lines, line)
	end

	function betterdebug.Box(pos, min, max, time, color)
		local box = {
			pos = pos,
			min = min,
			max = max,
			time = time or 1,
			color = color or Color(255, 255, 255, 255),
		}

		table.insert(betterdebug.boxes, box)
	end

	hook.Add("Tick", "betterdebug_crash_prevent", function()
		local lines = betterdebug.lines

		local lineCount = #lines

		if lineCount != 0 then
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
		end

		local boxes = betterdebug.boxes

		local boxCount = #boxes

		if boxCount != 0 then
			net.Start("betterdebug_boxes")
				net.WriteUInt(boxCount, 16)
				for i = 1, boxCount do
					local box = boxes[i]
					net.WriteVector(box.pos)
					net.WriteVector(box.min)
					net.WriteVector(box.max)
					net.WriteFloat(box.time)
					net.WriteUInt(box.color.r, 8)
					net.WriteUInt(box.color.g, 8)
					net.WriteUInt(box.color.b, 8)
					net.WriteUInt(box.color.a, 8)
				end
			net.Broadcast()

			betterdebug.boxes = {}
		end
	end)
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

	net.Receive("betterdebug_boxes", function()
		local boxCount = net.ReadUInt(16)

		for i = 1, boxCount do
			local pos = net.ReadVector()
			local min = net.ReadVector()
			local max = net.ReadVector()
			local time = net.ReadFloat()
			local color = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))

			local box = {
				pos = pos,
				min = min,
				max = max,
				time = time + CurTime(),
				color = color,
			}

			table.insert(betterdebug.boxes, box)
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

		for k, box in pairs(betterdebug.boxes) do
			if box.time < CurTime() then
				table.remove(betterdebug.boxes, k)
				continue
			end

			render.DrawWireframeBox(box.pos, Angle(0,0,0), box.min, box.max, box.color)
		end
	end)
end