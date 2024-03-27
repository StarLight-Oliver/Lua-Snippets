local cosCache = {}

local math_cos = function(value)
	if (cosCache[value]) then return cosCache[value] end
	cosCache[value] = math.cos(math.rad(value))

	return cosCache[value]
end

local sinCache = {}

local math_sin = function(value)
	if (sinCache[value]) then return sinCache[value] end
	sinCache[value] = math.sin(math.rad(value))

	return sinCache[value]
end

-- math.cos and sin are used below in places still, to make it cheaper you can replace it with these functions above ^
function draw.RoundedBoxPoly(cornerRadius, x, y, w, h, noDraw)
	local poly = {}

	poly[1] = {
		x = x + w / 2,
		y = y + h / 2,
		u = 0.5,
		v = 0.5
	}

	poly[2] = {
		x = x + w / 2,
		y = y,
		u = 0.5,
		v = 0
	}

	poly[3] = {
		x = x + w - cornerRadius,
		y = y,
		u = (w - cornerRadius) / w,
		v = 0
	}

	local topX = x + w - cornerRadius
	local topY = y + cornerRadius

	for i = -89, 0 do
		local X = topX + math_cos(i) * cornerRadius
		local Y = topY + math_sin(i) * cornerRadius

		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x) / w,
			v = (Y - y) / h,
		}
	end

	poly[#poly + 1] = {
		x = x + w,
		y = y + h - cornerRadius,
		u = 1,
		v = (h - cornerRadius) / h,
	}

	topX = x + w - cornerRadius
	topY = y + h - cornerRadius

	for i = 1, 90 do
		local X = topX + math_cos(i) * cornerRadius
		local Y = topY + math_sin(i) * cornerRadius

		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x) / w,
			v = (Y - y) / h,
		}
	end

	poly[#poly + 1] = {
		x = x + cornerRadius,
		y = y + h,
		u = cornerRadius / w,
		v = 1,
	}

	topX = x + cornerRadius
	topY = y + h - cornerRadius

	for _i = 180, 270 do
		local i = _i - 90
		local X = topX + math_cos(i) * cornerRadius
		local Y = topY + math_sin(i) * cornerRadius

		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x) / w,
			v = (Y - y) / h,
		}
	end

	poly[#poly + 1] = {
		x = x,
		y = y + cornerRadius,
		u = 0,
		v = cornerRadius / h,
	}

	topX = x + cornerRadius
	topY = y + cornerRadius

	for _i = 270, 360 do
		local i = _i - 90
		local X = topX + math_cos(i) * cornerRadius
		local Y = topY + math_sin(i) * cornerRadius

		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x) / w,
			v = (Y - y) / h,
		}
	end

	poly[#poly + 1] = {
		x = x + w / 2,
		y = y,
		u = 0.5,
		v = 0
	}

	if not noDraw then
		surface.DrawPoly(poly)
	end

	return poly
end

function surface.DrawRoundedOutlinedBox(arc, x, y, w, h, detail)
	detail = detail or 1
	surface.DrawLine(x + arc, y, x + w - arc, y)
	surface.DrawLine(x + arc, y + h, x + w - arc, y + h)
	surface.DrawLine(x, y + arc, x, y + h - arc)
	surface.DrawLine(x + w, y + arc, x + w, y + h - arc)
	local leftTop = Vector(x + arc, y + arc, 0)
	local rightTop = Vector(x + w - arc, y + arc, 0)
	local leftBottom = Vector(x + arc, y + h - arc, 0)
	local rightBottom = Vector(x + w - arc, y + h - arc, 0)

	for rot = 1, 90 * detail do
		local deg = math.rad(rot / detail)
		local nextDeg = math.rad((rot + 1) / detail)
		local x1 = math.sin(deg) * arc
		local y1 = math.cos(deg) * arc
		local x2 = math.sin(nextDeg) * (arc - 1)
		local y2 = math.cos(nextDeg) * (arc - 1)
		surface.DrawLine(rightBottom.x + x1, rightBottom.y + y1, rightBottom.x + x2, rightBottom.y + y2)
		surface.DrawLine(leftBottom.x - x1, leftBottom.y + y1, leftBottom.x - x2, leftBottom.y + y2)
		surface.DrawLine(leftTop.x - x1, leftTop.y - y1, leftTop.x - x2, leftTop.y - y2)
		surface.DrawLine(rightTop.x + x1, rightTop.y - y1, rightTop.x + x2, rightTop.y - y2)
	end
end

function surface.DrawRoundedOutlinedBoxEx(arc, x, y, w, h, detail, topLeftBool, topRightBool, bottomLeftBool, bottomRightBool)
	detail = detail or 1
	surface.DrawLine(x + arc, y, x + w - arc, y)
	surface.DrawLine(x + arc, y + h, x + w - arc, y + h)
	surface.DrawLine(x, y + arc, x, y + h - arc)
	surface.DrawLine(x + w, y + arc, x + w, y + h - arc)
	local leftTop = Vector(x + arc, y + arc, 0)
	local rightTop = Vector(x + w - arc, y + arc, 0)
	local leftBottom = Vector(x + arc, y + h - arc, 0)
	local rightBottom = Vector(x + w - arc, y + h - arc, 0)

	for rot = 1, 90 * detail do
		local deg = math.rad(rot / detail)
		local nextDeg = math.rad((rot + 1) / detail)
		local x1 = math.sin(deg) * arc
		local y1 = math.cos(deg) * arc
		local x2 = math.sin(nextDeg) * (arc - 1)
		local y2 = math.cos(nextDeg) * (arc - 1)

		if bottomRightBool then
			surface.DrawLine(rightBottom.x + x1, rightBottom.y + y1, rightBottom.x + x2, rightBottom.y + y2)
		end

		if bottomLeftBool then
			surface.DrawLine(leftBottom.x - x1, leftBottom.y + y1, leftBottom.x - x2, leftBottom.y + y2)
		end

		if topLeftBool then
			surface.DrawLine(leftTop.x - x1, leftTop.y - y1, leftTop.x - x2, leftTop.y - y2)
		end

		if topRightBool then
			surface.DrawLine(rightTop.x + x1, rightTop.y - y1, rightTop.x + x2, rightTop.y - y2)
		end
	end

	if not bottomRightBool then
		surface.DrawLine(rightBottom.x + arc, rightBottom.y, rightBottom.x + arc, rightBottom.y + arc)
		surface.DrawLine(rightBottom.x + arc, rightBottom.y + arc, rightBottom.x, rightBottom.y + arc)
	end

	if not bottomLeftBool then
		surface.DrawLine(leftBottom.x - arc, leftBottom.y, leftBottom.x - arc, leftBottom.y + arc)
		surface.DrawLine(leftBottom.x - arc, leftBottom.y + arc, leftBottom.x, leftBottom.y + arc)
	end

	if not topLeftBool then
		surface.DrawLine(leftTop.x - arc, leftTop.y, leftTop.x - arc, leftTop.y - arc)
		surface.DrawLine(leftTop.x - arc, leftTop.y - arc, leftTop.x, leftTop.y - arc)
	end

	if not topRightBool then
		surface.DrawLine(rightTop.x + arc, rightTop.y, rightTop.x + arc, rightTop.y - arc)
		surface.DrawLine(rightTop.x + arc, rightTop.y - arc, rightTop.x, rightTop.y - arc)
	end
end

function surface.RoundedBoxPolyEx(cornerRadius, x, y, w, h, leftTop, rightTop, rightBottom, leftBottom, noDraw)
	local poly = {}

	poly[1] = {
		x = x + w / 2,
		y = y + h / 2,
		u = 0.5,
		v = 0.5
	}

	poly[2] = {
		x = x + w / 2,
		y = y,
		u = 0.5,
		v = 0
	}

	poly[3] = {
		x = x + w - cornerRadius,
		y = y,
		u = (w - cornerRadius) / w,
		v = 0
	}

	local topX = x + w - cornerRadius
	local topY = y + cornerRadius

	if rightTop then
		for i = -89, 0 do
			local X = topX + math.cos(math.rad(i)) * cornerRadius
			local Y = topY + math.sin(math.rad(i)) * cornerRadius

			poly[#poly + 1] = {
				x = X,
				y = Y,
				u = (X - x) / w,
				v = (Y - y) / h,
			}
		end
	else
		poly[#poly + 1] = {
			x = x + w,
			y = y,
			u = w / w,
			v = w / h,
		}
	end

	poly[#poly + 1] = {
		x = x + w,
		y = y + h - cornerRadius,
		u = 1,
		v = (h - cornerRadius) / h,
	}

	topX = x + w - cornerRadius
	topY = y + h - cornerRadius

	if rightBottom then
		for i = 1, 90 do
			local X = topX + math.cos(math.rad(i)) * cornerRadius
			local Y = topY + math.sin(math.rad(i)) * cornerRadius

			poly[#poly + 1] = {
				x = X,
				y = Y,
				u = (X - x) / w,
				v = (Y - y) / h,
			}
		end
	else
		poly[#poly + 1] = {
			x = x + h,
			y = y + h,
			u = 1,
			v = 1,
		}
	end

	poly[#poly + 1] = {
		x = x + cornerRadius,
		y = y + h,
		u = cornerRadius / w,
		v = 1,
	}

	topX = x + cornerRadius
	topY = y + h - cornerRadius

	if leftBottom then
		for _i = 180, 270 do
			i = _i - 90
			local X = topX + math.cos(math.rad(i)) * cornerRadius
			local Y = topY + math.sin(math.rad(i)) * cornerRadius

			poly[#poly + 1] = {
				x = X,
				y = Y,
				u = (X - x) / w,
				v = (Y - y) / h,
			}
		end
	else
		poly[#poly + 1] = {
			x = x,
			y = y + h,
			u = 0,
			v = 1,
		}
	end

	poly[#poly + 1] = {
		x = x,
		y = y + cornerRadius,
		u = 0,
		v = cornerRadius / h,
	}

	topX = x + cornerRadius
	topY = y + cornerRadius

	if leftTop then
		for _i = 270, 360 do
			i = _i - 90
			local X = topX + math.cos(math.rad(i)) * cornerRadius
			local Y = topY + math.sin(math.rad(i)) * cornerRadius

			poly[#poly + 1] = {
				x = X,
				y = Y,
				u = (X - x) / w,
				v = (Y - y) / h,
			}
		end
	else
		poly[#poly + 1] = {
			x = x,
			y = y,
			u = 0,
			v = 0,
		}
	end

	poly[#poly + 1] = {
		x = x + w / 2,
		y = y,
		u = 0.5,
		v = 0
	}

	if not noDraw then
		surface.DrawPoly(poly)
	end

	return poly
end

if false then
	local mat = Material("osiris/jvs/container/lightsaber/1_2.png", "noclamp smooth")

	hook.Add("HUDPaint", "draw.RoundedBoxPoly", function()
		surface.SetMaterial(mat)
		surface.SetDrawColor(255, 255, 255)
		local _, h = ScrW(), ScrH()
		local progress = math.sin(CurTime()) * 0.5 + 0.5
		draw.RoundedBoxPoly(progress * 100, 100, h / 2 - 100, 200, 200)
	end)
end