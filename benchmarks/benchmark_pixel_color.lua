

/*
This example shows if we were to naively load the material at the same time as we wanted to read pixels
However generally the textures would likely already be loaded, so this is a worst case scenario.


If your tests don't show the same as mine, wait some time in game, before running.
Normal material reading has a degregation over time, for some reason?
I haven't tracked if its from just time or loading multiple materials

Example:
	Wall Mask loading at start
	0.25540069999988	=	Normal
	Wall Mask loading later
	0.62069799999881	=	Normal

If you want to test this but not use my VTF parser, just comment out the VTFParser.Material line and uncomment the Material line.

Example:
Wall Mask
	0.012670999999955	=	RT
	0.18600450000002	=	Normal
	0.2186653	=	VTF
Wall
	0.013160299999981	=	RT
	0.1976755	=	Normal
	0.25678539999996	=	VTF
*/

local function testThem(textureName)

	local mat = Material(textureName)
	// preload it so that this shouldn't affect the test? though it might.


	local rtStart = SysTime()
	local base = Material(textureName):GetTexture("$basetexture")
	local helperMat = Material("osiris_overrides/helper")
	// Helper Mat is an unlit generic with nocull and ignorez set to true, could be procedural but this is easier to test with.
	local rt = GetRenderTarget("render_target_for_reading" .. base:Width() .. "_" .. base:Height(), base:Width(), base:Height())
	render.PushRenderTarget(rt)
	helperMat:SetTexture("$basetexture", base:GetName())
	cam.Start2D()
		surface.SetMaterial(helperMat)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(0,0, base:Width(), base:Height())
	cam.End2D()

	-- render.PushRenderTarget(base, 0,0, base:Width(), base:Height())
	render.CapturePixels()
	for width = 1, base:Width() do
		for height = 1, base:Height() do
			local col = render.ReadPixel(width, height)
		end
	end
	render.PopRenderTarget()
	local rtEnd = SysTime()


	local normalStart = SysTime()
	local base = Material(textureName):GetTexture("$basetexture")

	for width = 1, base:Width() do
		for height = 1, base:Height() do
			local col = base:GetColor(width, height)
		end
	end
	local normalEnd = SysTime()

	local vtfStart = SysTime()
	base = VTFParser.Material(textureName)

	for width = 1, base:Width() do
		for height = 1, base:Height() do
			local col = base:GetColor(width, height)
		end
	end
	local vtfEnd = SysTime()


	return normalEnd - normalStart, vtfEnd - vtfStart, rtEnd - rtStart
end


local tbl = {
	["Wall Mask"] = "models/osiris/jvs/tython/wall_mask",
	["Wall"] = "models/osiris/jvs/tython/wall",
}

for name, mat  in pairs(tbl) do
	local norm, vtf, rt = testThem(mat)

	local results = {
		[norm] = "Normal",
		[vtf] = "VTF",
		[rt] = "RT"
	}
	print(name)
	PrintTable(results)
end