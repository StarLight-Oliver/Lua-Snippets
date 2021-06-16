local radarPosX = 0
local radarPosY = 0
local radarScale = 1
local radarSize = 100


local cX, cY = radarPosX + radarSize/2, radarPosY + radarSize/2

hook.Add("HUDPaint", "radar", function()
    local pos = LocalPlayer():GetPos()
    pos.z = 0

    // Apply rotationns here
    for _, ply in ipairs(player.GetHumans()) do
        if ply == LocalPlayer() then continue end
        local rPos = (ply:GetPos() - pos) * radarScale
        local x,y =  cX + rPos[1], cY + rPos[2]

        surface.DrawRect(x-rectSize, y-rectSize, rectSize, rectSize)
    end
end)