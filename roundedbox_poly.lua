function draw.RoundedBoxPoly(cornerRadius, x, y, w, h)
	local poly = {}
	poly[1] = { x = x + w/2, y = y + h/2, u = 0.5, v = 0.5}

	poly[2] = {x = x + w/2, y = y, u = 0.5, v = 0}
	poly[3] = {x = x + w - cornerRadius, y = y, u = (w-cornerRadius) / w, v = 0}

	local topX = x + w-cornerRadius
	local topY = y + cornerRadius
	for i = -89, 0 do
		local X = topX + math.cos(math.rad(i)) * cornerRadius 
		local Y = topY + math.sin(math.rad(i)) *cornerRadius
		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x )/w,
			v = (Y - y) /h,
		}
	end

	poly[#poly + 1] = {
		x = x + w,
		y = y + h - cornerRadius,
		u =  1, 
		v = (h-cornerRadius) / h,
	}

	topX = x + w-cornerRadius
	topY = y +h - cornerRadius

	for i = 1, 90 do
		local X = topX + math.cos(math.rad(i)) * cornerRadius 
		local Y = topY + math.sin(math.rad(i)) *cornerRadius
		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x )/w,
			v = (Y - y) /h,
		}
	end

	poly[#poly + 1] = {
		x = x +cornerRadius,
		y = y + h,
		u =  cornerRadius/w, 
		v = 1,
	}

	topX = x +cornerRadius
	topY = y +h - cornerRadius

	for _i = 180, 270 do
		i = _i - 90
		local X = topX + math.cos(math.rad(i)) * cornerRadius 
		local Y = topY + math.sin(math.rad(i)) *cornerRadius
		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x )/w,
			v = (Y - y) /h,
		}
	end

	poly[#poly + 1] = {
		x = x,
		y = y + cornerRadius,
		u = 0,
		v = cornerRadius/h,
	}

	topX = x + cornerRadius
	topY = y + cornerRadius

	for _i = 270, 360 do
		i = _i - 90
		local X = topX + math.cos(math.rad(i)) * cornerRadius 
		local Y = topY + math.sin(math.rad(i)) *cornerRadius
		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x )/w,
			v = (Y - y) /h,
		}
	end

	poly[#poly + 1] = {x = x + w/2, y = y, u = 0.5, v = 0}

	surface.DrawPoly(poly)
end

local mat = Material("osiris/jvs/container/lightsaber/1_2.png", "noclamp smooth")
hook.Add("HUDPaint", "draw.RoundedBoxPoly", function()
	surface.SetMaterial(mat)
	surface.SetDrawColor(255,255,255)
	
	local w,h  = ScrW(), ScrH()	
	
	local progress = math.sin(CurTime())*0.5 + 0.5
	draw.RoundedBoxPoly( progress * 100 , 100, h/2 - 100, 200, 200)
end)

