
local effectFiles = {}
local effectTbl = effects.GetList()

for _, ef in ipairs(effectTbl) do
	if not ef.Init then continue end
	local filePath = debug.getinfo(ef.Init).short_src
	local effectName = nil

	if filePath:EndsWith("init.lua") then
		effectName = filePath:match("(.+)/init.lua")
	else
		effectName = filePath:match("(.+).lua")
	end

	effectName = effectName:match(".+/(.+)")

	effectFiles[#effectFiles + 1] = {
		name = effectName,
		filePath = filePath
	}
end


local bg = vgui.Create("DFrame")
bg:SetSize(ScrW() * 0.5, ScrH() * 0.5)
bg:Center()
bg:SetTitle("Effects")
bg:MakePopup()

local top = vgui.Create("DPanel", bg)
top:Dock(TOP)
top:SetTall(30)

local text = vgui.Create("DLabel", top)
text:Dock(FILL)
text:SetText("")
text:SetFont("DermaLarge")
text:SetContentAlignment(5)

local leftBtn = vgui.Create("DButton", top)
leftBtn:Dock(LEFT)
leftBtn:SetText("<")
leftBtn:SetWide(30)


local rightBtn = vgui.Create("DButton", top)
rightBtn:Dock(RIGHT)
rightBtn:SetText(">")
rightBtn:SetWide(30)

function bg.UpdateContent(self, index)

	self.currentIndex = index

	local effect = effectFiles[index]

	text:SetText(effect.name)

	local pnl = vgui.Create("DPanel", bg)
	pnl:Dock(FILL)
	pnl:DockMargin(5, 5, 5, 5)
	pnl:SetBackgroundColor(Color(0, 0, 0))

	bg.currentPanel = pnl

	local code = vgui.Create("RichText", pnl)
	code:Dock(FILL)
	local effectFile = file.Read(effect.filePath, "GAME")

	if not effectFile then
		print(effect.filePath)
		code:SetText("Could not read file D=")
		return
	end
	// set the colour to black
	code:SetFontInternal("DermaLarge")
	code:SetVerticalScrollbarEnabled(true)
	code:SetPaintBackgroundEnabled(false)
	code:InsertColorChange(0,0,0, 255)
	code:AppendText(effectFile)

	code.PerformLayout = function(rich)
		rich:SetFontInternal("CloseCaption_Normal")
	end


end

function rightBtn.DoClick()
	if not bg.currentIndex then return end
	if bg.currentIndex == #effectFiles then return end

	bg.currentPanel:Remove()
	bg.UpdateContent(bg, bg.currentIndex + 1)
end

function leftBtn.DoClick()
	if not bg.currentIndex then return end
	if bg.currentIndex == 1 then return end

	bg.currentPanel:Remove()
	bg.UpdateContent(bg, bg.currentIndex - 1)
end

bg.UpdateContent(bg, 1)
