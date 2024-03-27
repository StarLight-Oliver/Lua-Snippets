gui.EnableScreenClicker(true)

if IsValid(rtsBG) then
	rtsBG:Remove()
end

rtsBG = vgui.Create("DPanel")
rtsBG:SetSize(ScrW(), ScrH())
rtsBG.Paint = function() end
local keysDown = {}
local roamPos = Vector(0, 0, 0)
local aimVec = Angle(0, 0, 0)
local lastx, lasty

rtsBG.OnMouseWheeled = function(self, scrollDelta)
	print(scrollDelta)

	if scrollDelta > 0 then
		keysDown["SCROLLUP"] = true
	elseif scrollDelta < 0 then
		keysDown["SCROLLDOWN"] = true
	else
		keysDown["SCROLLDOWN"] = nil
		keysDown["SCROLLUP"] = nil
	end
end

local specBinds = function(ply, bind, pressed)
	if string.StartWith(bind, "inv") then
		if bind == "invnext" then
			keysDown["SCROLLUP"] = true

			return true
		elseif bind == "invprev" then
			keysDown["SCROLLDOWN"] = true

			return true
		end

		return
	end

	local keybind = string.lower(string.match(bind, "+([a-z A-Z 0-9]+)") or "")
	if not keybind or keybind == "use" or keybind == "showscores" or string.find(bind, "messagemode") then return end
	keysDown[keybind:upper()] = pressed

	return true
end

local specThink = function()
	local ply = LocalPlayer()
	local roamSpeed = 1000
	local direction
	local frametime = RealFrameTime()

	if keysDown["FORWARD"] then
		direction = aimVec:Forward()
		direction.z = 0
	elseif keysDown["BACK"] then
		direction = -aimVec:Forward()
		direction.z = 0
	end

	if keysDown["MOVELEFT"] then
		local right = aimVec:Right()
		direction = direction and (direction - right):GetNormalized() or -right
		direction.z = 0
	elseif keysDown["MOVERIGHT"] then
		local right = aimVec:Right()
		direction = direction and (direction + right):GetNormalized() or right
		direction.z = 0
	end

	if keysDown["SPEED"] then
		roamSpeed = 2500
	elseif keysDown["WALK"] or keysDown["DUCK"] then
		roamSpeed = 300
	end

	if keysDown["SCROLLUP"] then
		direction = direction and (direction + Vector(0, 0, 1)):GetNormalized() or Vector(0, 0, 1)
		keysDown["SCROLLUP"] = nil
	elseif keysDown["SCROLLDOWN"] then
		direction = direction and (direction + Vector(0, 0, 1)):GetNormalized() or Vector(0, 0, -1)
		keysDown["SCROLLDOWN"] = nil
	end

	if input.IsMouseDown(MOUSE_RIGHT) then
		local x, y = gui.MousePos()

		if not lastx then
			lastx, lasty = x, y
		end

		dX, dY = x - lastx, y - lasty
		aimVec:RotateAroundAxis(Vector(0, 0, 1), dX * -20 * frametime)
		aimVec:RotateAroundAxis(aimVec:Right(), dY * -20 * frametime)
		aimVec = aimVec
		gui.SetMousePos(lastx, lasty)
	else
		lastx, lasty = nil, nil
	end

	roamVelocity = (direction or Vector(0, 0, 0)) * roamSpeed
	roamPos = roamPos + roamVelocity * frametime
end

--keysDown = {}
local specCalcView = function(ply, pos, angles, fov)
	local view = {}
	view.origin = roamPos
	view.angles = aimVec
	view.drawviewer = false

	return view
end

hook.Add("CalcView", "FSpectate", specCalcView)
hook.Add("PlayerBindPress", "FSpectate", specBinds)
hook.Add("Think", "FSpectate", specThink)