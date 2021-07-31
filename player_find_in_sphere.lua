function player.FindInSphere(pos, dist)
    dist = dist * dist
    local t = {}
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetPos():DistToSqr(pos) < dist then
            t[#t + 1] = ply
        end
    end
    return t
end