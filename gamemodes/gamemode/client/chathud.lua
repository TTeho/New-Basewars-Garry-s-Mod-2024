local THINK = {}

function THINK:Think()
	hook.Call("PanelThink")
end

function THINK:OnRemove()
	THINK = vgui.Create("Thinker")
end

vgui.Register("Thinker", THINK)

if _G.THINK then
	_G.THINK:Remove()
	_G.THINK = nil
else
	_G.THINK = vgui.Create("Thinker")
end

surface.CreateFont("chathud_18", {
	font = "Roboto",
	extended = true,
	size = 18,
	weight = 350,
})

surface.CreateFont("chathud_18_blur", {
	font = "Roboto",
	extended = true,
	size = 18,
	weight = 350,
	blursize = 2,
})

ChatHUD = {}

ChatHUD.shortcuts = ChatHUD.shortcuts or {}

for _, i in pairs(file.Find("materials/icon16/*.png", "GAME")) do
	ChatHUD.shortcuts[i:match("(.+).png")] = "<texture=icon16/" .. i .. ">"
end

function ChatHUD.CreateSteamShortcuts(update)
	local tag = os.date("%Y%m%d")
	local latest = "steam_emotes_"..tag..".dat"

	local found = file.Find("emoticon_cache/steam_emotes_*.dat", "DATA")
	for k, v in next,found do
		if v ~= latest then file.Delete("emoticon_cache/" .. v) end
	end

	latest = "emoticon_cache/" .. latest

	if file.Exists(latest, "DATA") and not update then
		local data = file.Read(latest, "DATA")

		for name in data:gmatch('"name": ":(.-):"') do
			if not ChatHUD.shortcuts[name] then ChatHUD.shortcuts[name] = "<se=" .. name .. ">" end
		end
	else
		http.Fetch("http://cdn.steam.tools/data/emote.json", function(b)
			for name in b:gmatch('"name": ":(.-):"') do
				if not ChatHUD.shortcuts[name] then ChatHUD.shortcuts[name] = "<se=" .. name .. ">" end
			end

			file.Write(latest, b)
		end)
	end
end

ChatHUD.CreateSteamShortcuts()

Chat = {}

Chat.markups = {}
Chat.x = 24
Chat.y = ScrH() - 200
Chat.w = 600
Chat.h = math.huge

Chat.isHud = true
Chat.markupLimit = 200

function Chat:SetPos(x, y)
	self.x, self.y = x, y
	self:Invalidate()
end

function Chat:SetSize(w, h)
	self.w, self.h = w, h
end

function Chat:AddMarkup()
	local mk = Markup
	local Markup = setmetatable({}, {__index = mk})
	Markup:Init()
	Markup.w = self.w
	self.markups[#self.markups + 1] = Markup
	self:CleanupOldMarkup()
	self:Invalidate()
	return Markup
end

function Chat:CleanupOldMarkup()
	local i = 0
	for k, v in pairs(self.markups) do
		i = i + 1
		if i > self.markupLimit then
			self[k] = nil
		end
	end
end

function Chat:Invalidate()
	self.needs_layout = true
end

function Chat:PerformLayout()
	local y = self.y
	for i = #self.markups, 1, -1 do
		local mk = self.markups[i]
		mk:Draw(true)
		mk.w = self.w
		if mk.h then
			y = y - mk.h
		end

		mk.y = y
	end
end

function Chat:Think()
	for _, mk in pairs(self.markups) do
		mk:Think(self.isHud)
	end
end

function Chat:Draw()
	if self.needs_layout then
		self:PerformLayout()
		self.needs_layout = nil
	end
	for _, mk in pairs(self.markups) do
		if self.isHud then
			local a = mk.alpha
			if a <= 0 then continue end
			surface.SetAlphaMultiplier(a / 255)
		end
		mk:Draw()
		surface.SetAlphaMultiplier(1)
	end
end

local mtrx = Matrix()
local function DrawChat()
	local eyepos, eyeang = Vector(16, 0, 0), LocalPlayer():EyeAngles()
	local ang = Angle()
	ang:Set(eyeang)
	ang:RotateAroundAxis(eyeang:Right(), -90)

	mtrx:SetTranslation(Vector(Chat.x, 0, 0))
	cam.PushModelMatrix(mtrx)
		local ok, why = pcall(Chat.Draw, Chat)
		if not ok then print("CHATHUD SPERGE\n", why) debug.Trace() end
	cam.PopModelMatrix()
end

local function Think()
	Chat:Think()
end

hook.Add("HUDPaint", "DrawChatHUD", DrawChat)
hook.Add("PanelThink", "PanelThinkHUD", Think)

hook.Add("HUDShouldDraw", "ChatHUD_HUDShouldDraw", function(chud)
	if chud == "CHudChat" then return false end
end)

hook.Add("ChatText", "ChatHUD_ChatText", function(index, name, text, type)
	chat.AddText(Color(0, 204, 102), text)
end)

chat.AddTextOLD = chat.AddTextOLD or chat.AddText
function chat.AddText(...)
	chat.AddTextOLD(...)
	local mk = Chat:AddMarkup()
	mk:StartLife(10)
	mk:AddFont("chathud_18")
	mk:AddShadow(1)

	local ply = chatexp.LastPlayer
	chatexp.LastPlayer = nil

	for i = 1, select("#", ...) do
		local gay = select(i, ...)
		if isstring(gay) then
			mk:Parse(gay, ply)
		elseif istable(gay) and gay.r and gay.g and gay.b and gay.a then
			mk:AddFGColor(gay)
		elseif isentity(gay) and gay:IsPlayer() then
			mk:AddFGColor(team.GetColor(gay:Team()))
			mk:Parse(gay:Nick(), ply)
		else
			mk:AddString(tostring(gay))
		end
	end
	mk:EndLife()
end

hook.Add("OnPlayerChat", "ChatHUDTagPanic", function(_,txt)
	if txt:lower():Trim() == "sh" then
		for _, gay in pairs(Chat.markups) do
			gay:TagPanic()
		end
	end
end)
