
local PANEL = {}

AccessorFunc( PANEL, "m_fAnimSpeed",	"AnimSpeed" )
AccessorFunc( PANEL, "vCamPos",			"CamPos" )
AccessorFunc( PANEL, "fFOV",			"FOV" )
AccessorFunc( PANEL, "vLookatPos",		"LookAt" )
AccessorFunc( PANEL, "aLookAngle",		"LookAng" )
AccessorFunc( PANEL, "colAmbientLight",	"AmbientLight" )
AccessorFunc( PANEL, "colColor",		"Color" )
AccessorFunc( PANEL, "bAnimated",		"Animated" )

function PANEL:Init()

	self.Entity = {}
	self.LastPaint = 0
	self.DirectionalLight = {}
	self.FarZ = 4096

	self:SetCamPos( Vector( 50, 50, 50 ) )
	self:SetLookAt( Vector( 0, 0, 40 ) )
	self:SetFOV( 70 )

	self:SetText( "" )
	self:SetAnimSpeed( 0.5 )
	self:SetAnimated( false )

	self:SetAmbientLight( Color( 50, 50, 50 ) )

	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )

	self:SetColor( color_white )

end

function PANEL:SetDirectionalLight( iDirection, color )
	self.DirectionalLight[ iDirection ] = color
end

function PANEL:RunAnimation(ent, seqName)

	if ( !IsValid( ent ) ) then return end

	local iSeq = ent:LookupSequence( seqName )
	if ( iSeq <= 0 ) then return end

	ent:ResetSequence( iSeq )
	ent:SetCycle( 0 )

end

function PANEL:AddEntity(name)

	-- Note: Not in menu dll
	if ( !ClientsideModel ) then return end

	local ent = ClientsideModel( "models/props_junk/wood_crate001a.mdl", RENDERGROUP_BOTH )
	ent:SetNoDraw( true )
	ent:SetIK(false)

	ent.name = name

	table.insert(self.Entity, ent)

	return ent
end

function PANEL:RemoveEntity(ent)

	if ( !IsValid( ent ) ) then return end

	table.RemoveByValue(self.Entity, ent)
	ent:Remove()
end

function PANEL:RemoveEntityByName(name)

	for k, v in ipairs(self.Entity) do
		if ( !IsValid( v ) ) then continue end
		if ( v.name == name ) then
			self:RemoveEntity(v)
		end
	end
end

function PANEL:GetEntities()
	return self.Entity
end

function PANEL:GetModels()

	local mdls = {}

	for k, v in ipairs(self.Entity) do
		if ( !IsValid( v ) ) then continue end
		table.insert(mdls, v:GetModel())
	end

	return mdls
end

function PANEL:DrawModel()

	local curparent = self
	local leftx, topy = self:LocalToScreen( 0, 0 )
	local rightx, bottomy = self:LocalToScreen( self:GetWide(), self:GetTall() )
	while ( curparent:GetParent() != nil ) do
		curparent = curparent:GetParent()

		local x1, y1 = curparent:LocalToScreen( 0, 0 )
		local x2, y2 = curparent:LocalToScreen( curparent:GetWide(), curparent:GetTall() )

		leftx = math.max( leftx, x1 )
		topy = math.max( topy, y1 )
		rightx = math.min( rightx, x2 )
		bottomy = math.min( bottomy, y2 )
		previous = curparent
	end

	-- Causes issues with stencils, but only for some people?
	-- render.ClearDepth()

	render.SetScissorRect( leftx, topy, rightx, bottomy, true )

	local ret = self:PreDrawModels( self.Entity )
	if ( ret != false ) then

		for k, v in ipairs(self.Entity) do
			if ( !IsValid( v ) ) then continue end
			v:DrawModel()
		end

		self:PostDrawModels( self.Entity )
	end

	render.SetScissorRect( 0, 0, 0, 0, false )
end

function PANEL:PreDrawModels( ent )
	return true
end

function PANEL:PostDrawModels( ent )

end

function PANEL:Paint( w, h )

	if ( table.IsEmpty( self.Entity ) ) then return end

	local x, y = self:LocalToScreen( 0, 0 )

	self:LayoutEntity( self.Entity )

	local ang = self.aLookAngle
	if ( !ang ) then
		ang = ( self.vLookatPos - self.vCamPos ):Angle()
	end

	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity[1]:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
	render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
	render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) ) -- * surface.GetAlphaMultiplier()

	for i = 0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
		end
	end

	self:DrawModel()

	render.SuppressEngineLighting( false )
	cam.End3D()

	self.LastPaint = RealTime()

end

function PANEL:LayoutEntity( entities )

	--
	-- This function is to be overriden
	--

	if ( self.bAnimated ) then

		for k, v in pairs(entities) do
			if ( !IsValid( v ) ) then continue end
			v:FrameAdvance( ( RealTime() - self.LastPaint ) * self.fAnimSpeed )
		end

		-- self:RunAnimation()
	end

	for k, v in pairs(entities) do
		if ( !IsValid( v ) ) then continue end
		v:SetAngles( Angle( 0, RealTime() * 10 % 360, 0 ) )
	end

end

function PANEL:OnRemove()
	for k, v in pairs(self.Entity) do
		if ( !IsValid( v ) ) then continue end
		v:Remove()
	end
end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 300, 300 )
	local ent = ctrl:AddEntity("Crate")
	ent:SetModel( "models/fyu/body/clothe_17.mdl" )
	ent:SetSkin(2)

	self:RunAnimation(ent, "walk_all")

	local head = ctrl:AddEntity("Head")
	head:SetModel( "models/fyu/head/togruta_1.mdl" )
	head:SetParent(ent)
	head:AddEffects(EF_BONEMERGE)

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )
end

derma.DefineControl( "DMultiModelPanel", "A panel containing multiple models", PANEL, "DButton" )