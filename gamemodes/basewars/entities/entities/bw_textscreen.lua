AddCSLuaFile()

ENT.Base 	= "base_gmodentity"
ENT.Type 	= "anim"

if SERVER then

	function ENT:Initialize()

		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)

		self:PhysWake()

	end

	function ENT:NetworkData(data)

		self:SetNWString("textscreen_lines", data)

	end

else

	local fts = {}

	local function GetFont(s)

		if fts[s] then
			
			return fts[s]

		end

		local ft = "textscreen" .. s

		surface.CreateFont(ft, {

			font = "Roboto",
			size = s,
			antialias = false,
			outline = true,

		})

		fts[s] = ft

		return ft

	end

	function ENT:Draw3D2D(pos, ang, scale)

		local l = self.Lines

		local col = Color(255,255,255)
		local font = GetFont(24)

		local y = 0

		for _, line in next, l do

			if line:match("\2(%d-)\1(%d-)\1(%d-)\1(%d-)\11") then
				
				local r,g,b,a = line:match("\2(%d-)\1(%d-)\1(%d-)\1(%d-)\11")

				col = Color(tonumber(r), tonumber(g), tonumber(b), tonumber(a))
				line = line:gsub("\2%d-\1%d-\1%d-\1%d-\11", "")

			end

			if line:match("\3%d-\11") then
				
				local siz = line:match("\3(%d-)\11")

				font = GetFont(tonumber(siz))

				line = line:gsub("\3%d-\11", "")

			end

			surface.SetFont(font)

			local _, th = surface.GetTextSize(line)

			draw.DrawText(line, font, 0, y, col, TEXT_ALIGN_CENTER)

			y = y + th

		end

	end

	function ENT:Calc3D2DParams(pos, ang)

		ang:RotateAroundAxis(ang:Right(), 90)

		pos = pos + ang:Up() * -5.5

		return pos, ang, 0.5

	end

	function ENT:Draw()

		self:DestroyShadow()

		if not self.Lines then return end

		local pos, ang, scale = self:Calc3D2DParams(self:GetPos(), self:GetAngles())

		cam.Start3D2D(pos, ang, scale)

			pcall(self.Draw3D2D, self, pos, ang, scale)

		cam.End3D2D()

	end

	function ENT:Think()

		local tbl = {}

		local lines = self:GetNWString("textscreen_lines", "none")

		if lines == "none" then return end

		if self.rawlines == lines then return end

		self.Lines = lines:Split("\n")
		self.rawlines = lines

	end

end
