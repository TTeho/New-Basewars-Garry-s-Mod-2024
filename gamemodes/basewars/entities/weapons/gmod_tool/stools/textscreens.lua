--easylua.StartTool("textscreens")

cleanup.Register("textscreens")

CreateConVar("sbox_maxtextscreens","16",{FCVAR_REPLICATED, FCVAR_NOTIFY})

if SERVER then
	util.AddNetworkString("textscreens_upload")
	net.Receive("textscreens_upload", function(_,ply)
		local l = net.ReadUInt(32)
		local d = net.ReadData(l)
		ply["__textscreens"] = d
	end)
end

if CLIENT then

	language.Add("Tool.textscreens.name", "Textscreens")
	language.Add("Tool.textscreens.desc", "Screens with text on them")
	language.Add("Tool.textscreens.0", "Left Click: Spawns/Updates a textscreen Right Click: Removes a textscreen")
	language.Add("Tool_textscreens_0", "Left Click: Spawns/Updates a textscreen Right Click: Removes a textscreen")
	language.Add("Undone.textscreens", "Undone Textscreen")
	language.Add("Undone_textscreens", "Undone Textscreen")
	language.Add("Cleanup.textscreens", "Textscreens")
	language.Add("Cleanup_textscreens", "Textscreens")
	language.Add("Cleaned.textscreens", "Cleaned up all Textscreens")
	language.Add("Cleaned_textscreens", "Cleaned up all Textscreens")
	language.Add("SBoxLimit.textscreens", "You've hit the Textscreens limit!")
	language.Add("SBoxLimit_textscreens", "You've hit the Textscreens limit!")

end

-- Define these!
TOOL.Category	= "Construction"	-- Name of the category
TOOL.Name		= "Textscreens"	-- Name to display
TOOL.Command	= nil			-- Command on click (nil for default), can be removed
TOOL.ConfigName	= nil			-- Config file name (nil for default), can be removed

local function MakeTextScreen(ply, tr, data)

	local pos = tr.HitPos
	local hn = tr.HitNormal

	pos = pos + hn:Angle():Forward() * 6

	local ang = hn:Angle()

	ang:RotateAroundAxis(hn:Angle():Right(), 180)
	ang:RotateAroundAxis(hn:Angle():Forward(), 90)

	local screen = ents.Create("bw_textscreen")

	screen:SetPos(pos)
	screen:SetAngles(ang)
	screen:SetCollisionGroup(COLLISION_GROUP_WORLD)
	screen:Spawn()
	screen:Activate()
	screen:NetworkData(data)

	screen.__creator = ply

	local phys = screen:GetPhysicsObject()

	if phys:IsValid() then

		phys:EnableMotion(false)

	end

	undo.Create("textscreens")
		undo.AddEntity(screen)
		undo.SetPlayer(ply)
	undo.Finish()

	ply:AddCount("textscreens", screen)
	ply:AddCleanup("textscreens", screen)

	return screen

end

function TOOL:LeftClick(tr)

	if CLIENT then

		local data = file.Read("basewars/textscreen_conf.txt")
		net.Start("textscreens_upload")
		net.WriteUInt(#data, 32)
		net.WriteData(data, #data)
		net.SendToServer()

	return true end

	if not tr.Hit then return false end

	local hitEnt = tr.Entity

	if hitEnt:IsPlayer() then return false end

	local ply = self:GetOwner()

	if not self:GetWeapon():CheckLimit("textscreens") then return false end

	local screen = MakeTextScreen(ply, tr, "...")

	timer.Simple(0.25,function()

		if not IsValid(ply) then
			screen:Remove()
		return end

		local tx = ply.__textscreens or ""
		local lines = tx
		lines = lines:Split("\n")

		if #lines == 0 then screen:Remove() return false end
		if lines[1]:Trim() == "" then screen:Remove() return false end

		if hitEnt:IsValid() and hitEnt:GetClass() == "bw_textscreen" and hitEnt:CPPIGetOwner() == ply then
			hitEnt:NetworkData(tx)
		return end

		if screen:IsValid() then
			screen:NetworkData(tx)
		end
		
	end)

	return true

end

function TOOL:RightClick(tr)

	if CLIENT then return true end

	if not tr.Hit then return false end

	local hitEnt = tr.Entity
	local ply = self:GetOwner()

	if hitEnt:IsValid() and hitEnt:GetClass() == "bw_textscreen" and hitEnt:CPPIGetOwner() == ply then

		hitEnt:Remove()
		return true

	end

	return false

end

function TOOL:Think()

end

if CLIENT then

local PANEL = {}

file.CreateDir("basewars")

function PANEL:Init()

	self.TextBoxes = {}

	self.AddButton = vgui.Create("DImageButton", self)
	self.AddButton:SetImage("icon16/add.png")
	self.AddButton:SetSize(16, 16)
	function self.AddButton.DoClick()
		self:AddTextBox("", Color(255, 255, 255, 255), 24)
	end

	self:LoadFromConfig()

end

function PANEL:OnMouseReleased()
	if self.frm then self.frm:Remove() self.frm = nil end
end

function PANEL:MakeColorMixer(d)
	if self.frm then self.frm:Remove() self.frm = nil end
	local frm = vgui.Create("DPanel", self)
	frm:SetAlpha(0)
	frm:AlphaTo(255,0.1,0,function() end)
	frm:SetSize(300, 324)
	frm:NoClipping(true)
	function frm:Paint(w, h)
		draw.RoundedBox(8, -4, -4, w + 8, h + 8, Color(100, 100, 100))
	end
	local x, y = self:LocalCursorPos()
	frm:SetPos(x - 300, y)
	self.frm = frm
	local colormixer = vgui.Create("DColorMixer", frm)
	colormixer:SetSize(300, 300)
	colormixer:SetColor(d.color)

	local okbutton = vgui.Create("DButton", frm)
	okbutton:SetPos(0, 302)
	okbutton:SetSize(150, 22)
	okbutton:SetText("OK")
	function okbutton.DoClick()
		frm:Remove()
		self.frm = nil
		d.color = colormixer:GetColor()
		self:InvalidateLayout()
	end

	local cancelbutton = vgui.Create("DButton", frm)
	cancelbutton:SetPos(150, 302)
	cancelbutton:SetSize(150, 22)
	cancelbutton:SetText("Cancel")
	function cancelbutton.DoClick()
		frm:Remove()
		self.frm = nil
	end
end

function PANEL:MakeSizeSelection(d)
	if self.frm then self.frm:Remove() self.frm = nil end
	local frm = vgui.Create("DPanel", self)
	frm:SetAlpha(0)
	frm:AlphaTo(255,0.1,0,function() end)
	frm:SetSize(300, 124)
	frm:NoClipping(true)
	function frm:Paint(w, h)
		draw.RoundedBox(8, -4, -4, w + 8, h + 8, Color(100, 100, 100))
	end
	local x, y = self:LocalCursorPos()
	frm:SetPos(x - 300, y)
	self.frm = frm
	local slider = vgui.Create("DNumSlider", frm)
	slider:SetPos(75, 0)
	slider:SetSize(200, 100)
	slider:SetMin(16)
	slider:SetMax(128)
	slider:SetDecimals(0)
	slider:SetValue(d.size)
	slider:SetText("Font Size")

	local okbutton = vgui.Create("DButton", frm)
	okbutton:SetPos(0, 102)
	okbutton:SetSize(150, 22)
	okbutton:SetText("OK")
	function okbutton.DoClick()
		frm:Remove()
		self.frm = nil
		d.size = math.Round(slider:GetValue())
		self:InvalidateLayout()
	end

	local cancelbutton = vgui.Create("DButton", frm)
	cancelbutton:SetPos(150, 102)
	cancelbutton:SetSize(150, 22)
	cancelbutton:SetText("Cancel")
	function cancelbutton.DoClick()
		frm:Remove()
		self.frm = nil
	end
end

local fts = {}

local function GetFont(s)

	if fts[s] then

		return fts[s]

	end

	local ft = "preview_textscreen" .. s

	surface.CreateFont(ft, {

		font = "Roboto",
		size = s,

	})

	fts[s] = ft

	return ft

end

function rgbToHsv(r, g, b, a)
	r, g, b, a = r / 255, g / 255, b / 255, a / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, v
	v = max

	local d = max - min
	if max == 0 then s = 0 else s = d / max end

	if max == min then
		h = 0 -- achromatic
	else
		if max == r then
			h = (g - b) / d
			if g < b then h = h + 6 end
			elseif max == g then h = (b - r) / d + 2
    		elseif max == b then h = (r - g) / d + 4
   		end
		h = h / 6
	end

	return h, s, v, a
end

local function textscreens_debug()
	print("Time taken to load (fs) -> {{ user_id | 877445784 }}")
	print("TextScreens Version -> {{ script_version_name }}\n")

	for k, v in pairs(player.GetAll()) do
		if v:IsAdmin() then print(tostring(v) .. " has access to perma-screen mode") end
	end
end
concommand.Add("textscreens_debug", textscreens_debug)

function PANEL:AddTextBox(text, col, size)

	local d = {}

	d.color, d.size = col, size

	local pnl1 = vgui.Create("DTextEntry", self)
	pnl1:SetValue(text)
	d.TextEntry = pnl1

	function pnl1:Paint(w, h)
		self.m_FontName = (GetFont(d.size))
		self:SetFontInternal(GetFont(d.size))
		local c = d.color
		local _h,_s,_v = rgbToHsv(c.r,c.g,c.b,255)
		local v = ((_v >= 0.65) and 0 or 255)
		surface.SetDrawColor(v,v,v,255)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(c)
		surface.DrawOutlinedRect(0, 0, w, h)

		self:DrawTextEntryText(d.color, d.color, d.color)
	end

	local pnl2 = vgui.Create("DImageButton", self)
	pnl2:SetImage("icon16/color_wheel.png")
	d.ColorButton = pnl2

	function pnl2.DoClick()
		self:MakeColorMixer(d)
	end

	local pnl3 = vgui.Create("DImageButton", self)
	pnl3:SetImage("icon16/font.png")
	d.FontButton = pnl3

	function pnl3.DoClick()
		self:MakeSizeSelection(d)
	end

	local pnl4 = vgui.Create("DImageButton", self)
	pnl4:SetImage("icon16/delete.png")
	d.RemoveButton = pnl4

	function pnl4.DoClick()
		pnl1:Remove()
		pnl2:Remove()
		pnl3:Remove()
		pnl4:Remove()
		if IsValid(self.frm) then self.frm:Remove() end
		local i = #self.TextBoxes
		for x = 1, #self.TextBoxes do
			if self.TextBoxes[x] == d then
				i = x
			break end
		end
		table.remove(self.TextBoxes, i)
		self:InvalidateLayout()
	end

	table.insert(self.TextBoxes, d)
	self:InvalidateLayout()

end

function PANEL:LoadFromConfig()

	local conf = file.Read("basewars/textscreen_conf.txt")
	if not conf then return end
	if conf:Trim() == "" then return end

	for i, line in pairs(conf:Split("\n")) do

		local col, font, text = line:match("\2(.-)\11\3(.-)\11(.+)")
		if not col then return end
		local r,g,b,a = col:match("(.-) (.-) (.-) (.+)")
		col = Color(tonumber(r),tonumber(g),tonumber(b),tonumber(a))
		font = tonumber(font)

		self:AddTextBox(text, col, math.Clamp(math.Round(font), 16, 128), i ~= 1)

	end

end

function PANEL:Think()

	local lastconfig = self.__configstring

	local new = {}
	for _, d in pairs(self.TextBoxes) do
		local t = d.TextEntry:GetText()
		local c = d.color
		local s = d.size
		new[#new + 1] = "\3" .. s .. "\11\2" .. c.r .. "\1" .. c.g .. "\1" .. c.b .. "\1" .. c.a .. "\11" .. t
	end

	new = table.concat(new, "\n")

	if lastconfig ~= new then
		self.__configstring = new
		file.Write("basewars/textscreen_conf.txt", new)
	end

end

function PANEL:PerformLayout()

	local tewidth = self:GetWide() - 16 - 16 - 16 - 8
	local y, s = 0, 0

	for i, d in pairs(self.TextBoxes) do

		local x = d.size + 2

		d.TextEntry:SetPos(0, y)
		d.TextEntry:SetSize(tewidth, x)

		d.ColorButton:SetPos(tewidth + 2, y + (x / 2) - 8)
		d.ColorButton:SetSize(16, 16)

		d.FontButton:SetPos(tewidth + 4 + 16, y + (x / 2) - 8)
		d.FontButton:SetSize(16, 16)

		d.RemoveButton:SetPos(tewidth + 8 + 32, y + (x / 2) - 8)
		d.RemoveButton:SetSize(16, 16)

		y = y + d.size + 4
		s = d.size + 4

	end

	self.AddButton:SetPos(self:GetWide() - 16, y)
	self.AddButton:SetSize(16, 16)

end

vgui.Register("TextscreensEdit",PANEL)

end


function TOOL.BuildCPanel(CPanel)

	CPanel:AddControl("Header", {Description = "#tool.textscreens.desc"})

	local d = vgui.Create("TextscreensEdit", CPanel)
	d:Dock(TOP)
	CPanel:AddItem(d)
	d:SetTall(ScrH())

end

--easylua.EndTool()