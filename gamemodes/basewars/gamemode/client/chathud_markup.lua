local emoticon_cache = {}
local busy = {}

local function MakeCache(filename, emoticon)
	local mat = Material("data/" .. filename, "noclamp smooth")
	emoticon_cache[emoticon or string.StripExtension(string.GetFileFromFilename(filename))] = mat
end

local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function dec(data)
    data = string.gsub(data, "[^" .. b.. "=]", "")
    return (data:gsub(".", function(x)
        if x == "=" then return "" end
        local r, f = "", (b:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0") end
        return r
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if #x ~= 8 then return "" end
        local c = 0
        for i = 1,8 do c = c + (x:sub(i,i) == "1" and 2 ^ (8 - i) or 0) end
        return string.char(c)
    end))
end

file.CreateDir("emoticon_cache")
local function GetSteamEmoticon(emoticon)
	emoticon = emoticon:gsub(":",""):Trim()
	if emoticon_cache[emoticon] then
		return emoticon_cache[emoticon]
	end
	if busy[emoticon] then
		return false
	end
	if file.Exists("emoticon_cache/" .. emoticon .. ".png", "DATA") then
		MakeCache("emoticon_cache/" .. emoticon .. ".png", emoticon)
	return emoticon_cache[emoticon] or false end
	print("downloading emoticon " .. emoticon)
	http.Fetch("http://steamcommunity-a.akamaihd.net/economy/emoticonhover/" .. emoticon, function(body, len, headers, code)
		if code == 200 then
			if body == "" then
				print("Server returned OK but empty response")
			end
			print("Download OK")
			body = body:match("src=\"data:image/png;base64,(.-)\"")
			if not body then print("NIGGER") return end
			body = dec(body)
			if not body then print("NIGGER") return end
			file.Write("emoticon_cache/" .. emoticon .. ".png", body)
			MakeCache("emoticon_cache/" .. emoticon .. ".png", emoticon)
		else
			print("Download failure. Code: " .. code)
		end
	end)
	busy[emoticon] = true
	return false
end

local f = "DermaDefault"
surface.__SetFont = surface.__SetFont or surface.SetFont

function surface.SetFont(font)
	surface.__SetFont(font)
	f = font
end

function surface.GetFont()
	return f
end

local cche = {}

surface.__GetTextSize = surface.__GetTextSize or surface.GetTextSize
function surface.GetTextSize(t)
	if cche[f] and cche[f][t] then
		return cche[f][t][1], cche[f][t][2]
	end
	cche[f] = cche[f] or {}
	local w, h = surface.__GetTextSize(t)
	cche[f][t] = {w, h}
	return w, h
end

surface.__CreateFont = surface.__CreateFont or surface.CreateFont

function surface.CreateFont(font, ...)
	surface.__CreateFont(font, ...)
	cche[font] = nil
end

function surface.IsValidFont(...)
	return not not pcall(surface.SetFont, ...)
end

local fallbackFont = "DermaDefault"
function surface.SetFontFallback(font)
	if surface.IsValidFont(font) then
		surface.SetFont(font)
	else
		surface.SetFont(fallbackFont)
	end
end

local function utf_totable(str)
	local tbl = {}
	for uchar in string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do
		tbl[#tbl + 1] = uchar
	end
	return tbl
end

local spaces = "[   ᠎           ​  　﻿]"

local function makecharinfo(buffer, text)
	if not text then return end
	local chars = utf_totable(text)
	local words = spaces:Explode(text, true)
	local x, y, w = buffer.x or 0, 0, buffer.w or math.huge
	local font = buffer.font
	surface.SetFontFallback(font)

	local cword = 1
	local charinfo = {}

	local tabwidth = surface.GetTextSize("     ")
	local _,newline = surface.GetTextSize("\n")
	newline = newline / 2

	local skip

	local bigY, bigH = 0, 0

	for i, char in pairs(chars) do
		if skip then skip = nil continue end
		local _newline = newline
		local cw, ch = surface.GetTextSize(char)
		if char:match(spaces) or char == "\t" then
			cword = cword + 1
			local word = words[cword]
			if word then
				local ww = surface.GetTextSize(word)
				if x + ww > w then
					if buffer.newlineSize then
						if buffer.newlineSize > newline then
							_newline = buffer.newlineSize
						end
						buffer.newlineSize = nil
					end
					x, y = 0, y + _newline
					charinfo[#charinfo + 1] = {"\n", x, y, 0, _newline}
				continue end
			end
			charinfo[#charinfo + 1] = {char, x, y, char == "\t" and tabwidth or cw, ch}
			x = x + (char == "\t" and tabwidth or cw)
		continue end
		if char == "\n" or char == "\r" then
			if buffer.newlineSize then
				if buffer.newlineSize > newline then
					_newline = buffer.newlineSize
				end
				buffer.newlineSize = nil
			end
			x, y = 0, y + _newline
			charinfo[#charinfo + 1] = {"\n", x, y, 0, _newline}
		continue end
		charinfo[#charinfo + 1] = {char, x, y, cw, ch}

		x = x + cw

		if x > w then
			x, y = 0, y + _newline
		end

		if ch + y > bigH then
			bigH = ch + y
		end
	end
	return charinfo, bigH, x
end

local ChunkTypes = {}

local Base = {}

function Base:Init() end
function Base:PerformLayout() end
function Base:Think() end
function Base:Draw() end
function Base:ChangeBuffer() end
function Base:TagStart() end
function Base:TagEnd() end

local Text = table.Copy(Base)

ChunkTypes["Text"] = Text

function Text:Init(markup, buffer, data)
	self.__canpanic = false
	if buffer.anime then
		self.data = string.anime(data)
		self:InitData(buffer, data)
	end
	self:InitData(buffer, data)
end

function Text:InitData(buffer, data)
	self.charinfo, self.h, self.x = makecharinfo(buffer, data)
end

function Text:PerformLayout(markup, buffer, data)
	self:InitData(buffer, data)
end

function Text:Draw(markup, buffer, data)
	local charinfo = self.charinfo
	if not charinfo then
		self:InitData(buffer, data)
		charinfo = self.charinfo
	end
	if not self.charinfo then return end

	local font, color = buffer.font, buffer.fgColor

	local isnewword, start = true
	local wordCount = 1

	local y = buffer.y
	for _, ch in pairs(charinfo) do
		local char, cx, cy, cw, ch = ch[1], ch[2], ch[3], ch[4], ch[5]
		cy = cy + y
		buffer.y = cy
		markup:HookCall("StartChar", char, cx, cy, cw, ch, font)
		if char:match(spaces) then
			isnewword = true
			if not start then
				start = true
			else
				markup:HookCall("EndWord", wordCount)
				wordCount = wordCount + 1
			end
		end
		if isnewword then
			isnewword = nil
			markup:HookCall("StartWord", wordCount)
		end
		surface.SetTextColor(color)
		surface.SetTextPos(cx, cy)
		surface.SetFontFallback(font)
		surface.DrawText(char)
		markup:HookCall("EndChar", char, cx, cy, cw, ch, font)
	end
	markup:HookCall("EndWord", wordCount)
end

function Text:ChangeBuffer(markup, buffer, data)
	local charinfo = self.charinfo
	if not charinfo then
		self:InitData(buffer, data)
		charinfo = self.charinfo
	end
	buffer.x = self.x
end

local FGColor = table.Copy(Base)

ChunkTypes["FGColor"] = FGColor

function FGColor:TagStart(markup, buffer, data)
	self.oldcolor = buffer.fgColor
end

function FGColor:ChangeBuffer(markup, buffer, data)
	buffer.fgColor = isfunction(data) and data() or data
end

function FGColor:TagEnd(markup, buffer, data)
	buffer.fgColor = self.oldcolor
end

local BGColor = table.Copy(Base)

ChunkTypes["BGColor"] = BGColor

function BGColor:ChangeBuffer(markup, buffer, data)
	buffer.bgColor = isfunction(data) and data() or data
end

local Font = table.Copy(Base)

ChunkTypes["Font"] = Font

function Font:ChangeBuffer(markup, buffer, data)
	buffer.font = data
end

local Transform = table.Copy(Base)

ChunkTypes["Transform"] = Transform

function Transform:TagStart(markup, buffer, data)
	local matrix = isfunction(data) and data() or data
	cam.PushModelMatrix(matrix)
end

function Transform:TagEnd(markup, buffer, data)
	cam.PopModelMatrix()
end

local Shadow = table.Copy(Base)

ChunkTypes["Shadow"] = Shadow

function Shadow:ChangeBuffer(markup, buffer, data)
	data = isfunction(data) and data() or data
	markup.Hook(markup, "StartChar", function(char, cx, cy, cw, ch, font)
		if pcall(surface.SetFont, font .. "_blur") then
			surface.SetFont(font .. "_blur")
		else
			surface.SetFontFallback(font)
		end
		surface.SetTextColor(0, 0, 0, 255)
		surface.SetTextPos(cx + data - 1, cy + data - 1)
		surface.DrawText(char)
		surface.SetTextColor(0, 0, 0, 200)
		surface.SetTextPos(cx + data, cy + data)
		surface.DrawText(char)
		surface.SetTextColor(0, 0, 0, 145)
		surface.SetTextPos(cx + data + 1, cy + data + 1)
		surface.DrawText(char)
	end)
end

function Shadow:TagEnd()

end

local Image = table.Copy(Base)

ChunkTypes["Image"] = Image

function Image:Init(markup, buffer, data)
	self.image, self.size = data.image, data.size
	self._size = isfunction(self.size) and self.size() or self.size
	buffer.newlineSize = self._size
end

function Image:PerformLayout(markup, buffer, data)
	buffer.newlineSize = self._size
end

function Image:Draw(markup, buffer, data)
	self._size = isfunction(self.size) and self.size() or self.size
	local size = self._size
	self.image = self.image or (isfunction(image) and image() or image)
	self.image = type(self.image) == "IMaterial" and self.image or Material(tostring(self.image), "noclamp smooth")
	local image = self.image
	if image == false then return end
	surface.SetDrawColor(buffer.fgColor)
	surface.SetMaterial(image)
	surface.DrawTexturedRect(buffer.x, buffer.y, size, size)
	draw.NoTexture()
end

function Image:ChangeBuffer(markup, buffer, data)
	self._size = self._size or (isfunction(self.size) and self.size() or self.size)
	self.h = self._size
	buffer.h = self.h
	buffer.x = buffer.x + self._size
	buffer.newlineSize = self._size
end

local SteamEmoticon = table.Copy(Base)

ChunkTypes["SteamEmoticon"] = SteamEmoticon

function SteamEmoticon:Init(markup, buffer, data)
	self.image, self.size = data.image, data.size
	self._size = isfunction(self.size) and self.size() or self.size
	buffer.newlineSize = self._size
end

function SteamEmoticon:PerformLayout(markup, buffer, data)
	buffer.newlineSize = self._size
end

function SteamEmoticon:Draw(markup, buffer, data)
	self._size = isfunction(self.size) and self.size() or self.size
	local size = self._size
	local image = GetSteamEmoticon(self.image)
	if image == false then return end
	surface.SetDrawColor(buffer.fgColor)
	surface.SetMaterial(image)
	surface.DrawTexturedRect(buffer.x, buffer.y, size, size)
	draw.NoTexture()
end

function SteamEmoticon:ChangeBuffer(markup, buffer, data)
	self._size = self._size or (isfunction(self.size) and self.size() or self.size)
	self.h = self._size
	buffer.x = buffer.x + self._size
	buffer.newlineSize = self._size
end

local TagStopper = table.Copy(Base)

ChunkTypes["TagStopper"] = TagStopper

function TagStopper:Init(markup, buffer, data)
	markup:StopTag(data, buffer)
end

function TagStopper:Draw(markup, buffer, data)
	markup:StopTag(data, buffer)
end

local Anime = table.Copy(Base)

ChunkTypes["Anime"] = Anime

function Anime:Init(markup, buffer, data)
	buffer.anime = true
end

function Anime:TagEnd(markup, buffer, data)
	buffer.anime = nil
end

local Buffer = {}

local rawset = rawset
function Buffer:Clear()
	rawset(self, "__table", {})
end

function Buffer:Fill()
	self:Clear()
	self.x = 0
	self.y = 0
	self.w = 0
	self.h = 0
	self.font = "DermaDefault"
	self.fgColor = Color(255, 255, 255, 255)
	self.bgColor = Color(0, 0, 0, 0)
end

function Buffer:__newindex(k, v)
	if k ~= "__table" then
		self.__table[k] = v
	end
end

local rawget = rawget
function Buffer:__index(k)
	return (rawget(self, "__table") and rawget(self, "__table")[k]) or Buffer[k]
end

local Markup = {}

function Markup:Init()
	self.buffer = setmetatable({}, Buffer)
	self.buffer:Fill()
	self.x = 0
	self.y = 0
	self.w = math.huge
	self.h = 0

	self.bgColor = Color(0, 0, 0, 0)
	self.fgColor = Color(255, 255, 255, 255) -- may be deprecated
	self.alpha = 255

	self.chunks = {}
	self.hooks = {}
end

function Markup:SetPos(x, y)
	self.x, self.y = x or self.x, y or self.y
end

function Markup:InsertChunk(chunkt, data)
	local ch = ChunkTypes[chunkt]
	local chunk = setmetatable({}, {__index = ch})
	chunk.data = data
	chunk.needs_layout = true
	chunk.type = chunkt
	self.chunks[#self.chunks + 1] = chunk
	if chunk.Init then
		chunk:Init(self, self.buffer, data)
	end
	return chunk
end

function Markup:AddString(text)
	return self:InsertChunk("Text", text)
end

function Markup:AddFGColor(color)
	return self:InsertChunk("FGColor", color)
end

function Markup:AddBGColor(color)
	return self:InsertChunk("BGColor", color)
end

function Markup:AddFont(font)
	return self:InsertChunk("Font", font)
end

function Markup:AddTransform(matrix)
	return self:InsertChunk("Transform", matrix)
end

function Markup:AddShadow(size)
	return self:InsertChunk("Shadow", size)
end

function Markup:AddImage(data)
	return self:InsertChunk("Image", data)
end

function Markup:AddTagStopper(tag)
	return self:InsertChunk("TagStopper", tag)
end

local tag_mappings = {
	["color"] = {
		Name = "FGColor",
		ParseArgs = function(args)
			if args == "" then return Color(255, 255, 255, 255) end
			args = args:Split(",")
			return Color(tonumber(args[1] and args[1]:Trim() or 0) or 0,
						tonumber(args[2] and args[2]:Trim() or 0) or 0,
						tonumber(args[3] and args[3]:Trim() or 0) or 0,
						tonumber(args[4] and args[4]:Trim() or 255) or 255)
		end
	},
	["texture"] = {
		Name = "Image",
		ParseArgs = function(args)
			args = args:Split(",")
			return {image = args[1] and args[1]:Trim() or "error", size = math.Clamp(args[2] and tonumber(args[2]:Trim()) or 16, 8, 128)}
		end
	},
	["se"] = {
		Name = "SteamEmoticon",
		ParseArgs = function(args)
			args = args:Split(",")
			return {image = args[1] and args[1]:Trim() or "error", size = math.Clamp(args[2] and tonumber(args[2]:Trim()) or 18, 8, 128)}
		end
	},
	["font"] = {
		Name = "Font",
		ParseArgs = function(args) return args end
	},
}

if string.anime then
	tag_mappings["anime"] = {
		Name = "Anime",
		ParseArgs = function(args) return args end
	}
end

function Markup:Parse(string)
	---- preprocess :shortcuts:
	string = string:gsub(":[%a%d_]-:", function(str)
		str = str:sub(2, -2)
		if ChatHUD.shortcuts[str] then
			return ChatHUD.shortcuts[str]
		end
	end)

	local cur = ""
	local inTag
	local inShortcut
	for _, char in pairs(utf_totable(string)) do
		if char == "<" and not inTag then
			if cur ~= "" then
				self:AddString(cur)
				cur = ""
			end
			inTag = true
		continue end
		if char == ">" and inTag then
			if cur:sub(1,1) == "/" then
				local tag = tag_mappings[cur:sub(2)]
				if tag then
					self:AddTagStopper(tag.Name)
				else
					self:AddString("<" .. cur .. ">")
				end
			else
				local tagtype, args = cur:match("(.-)=(.+)")
				if not tagtype then
					tagtype = cur
					args = ""
				end
				local tag = tag_mappings[tagtype]
				if tag then
					self:InsertChunk(tag.Name, tag.ParseArgs(args))
				else
					self:AddString("<" .. cur .. ">")
				end
			end
			cur = ""
			inTag = nil
		continue end
		cur = cur .. char
	end
	if cur ~= "" then self:AddString(cur) end
end

function Markup:SetBGColor(color)
	self.bgColor = color
end

function Markup:StartLife(length)
	self.startTime = CurTime()
	self.endTime = length
end

function Markup:EndLife()
	self.fadeOut = 3
	self:AddTagStopper()
end

function Markup:Call(f, ...)
	for _, gay in pairs(self.chunks) do
		if gay[f] then
			gay[f](..., gay.data)
		end
	end
end

function Markup:Set(k, v)
	for _, gay in pairs(self.chunks) do
		gay[k] = v
	end
end

function Markup:Hook(type, callback)
	self.hooks[type] = self.hooks[type] or {}
	self.hooks[type][#self.hooks[type] + 1] = callback
end

function Markup:HookCall(name, ...)
	local h = self.hooks[name]
	if h then
		for _, hook in pairs(h) do
			hook(...)
		end
	end
end

function Markup:Think(fade)
	self:Call("Think", self)
	if fade and self.alpha > 0 and self.fadeOut then
		local s, e = self.startTime, self.endTime
		if CurTime() > s + e then
			self.alpha = self.alpha - self.fadeOut / 5
		end
	end
end

function Markup:Draw(nodraw)
	self:Set("__start", nil)
	self.hooks = {}
	local buffer = self.buffer
	buffer:Fill()
	buffer.y = self.y
	buffer.w = self.w
	for _, gay in pairs(self.chunks) do
		if gay.__stop then continue end
		if gay.needs_layout then
			if gay.PerformLayout then
				gay:PerformLayout(self, buffer, gay.data)
			end
			gay.needs_layout = nil
		end
		if not gay.__start then
			gay.__start = true
			if gay.TagStart then
				gay:TagStart(self, buffer, gay.data)
			end
		end
		if not nodraw then
			gay:Draw(self, buffer, gay.data)
		end
		gay:ChangeBuffer(self, buffer, gay.data)
	end
	self:SizeToContents()
end

function Markup:SizeToContents()
	local height = 0
	for _, gay in pairs(self.chunks) do
		if gay.h and gay.h > height then
			height = gay.h
		end
	end
	self.h = height
end

function Markup:StopTag(data, buffer)
	for _, gay in pairs(self.chunks) do
		if data == nil or data == gay.type and not gay.__stop then
			gay:TagEnd(self, buffer, gay.data)
		end
	end
end

function Markup:TagPanic()
	for _, gay in pairs(self.chunks) do
		if gay.__canpanic ~= false then
			gay.Draw = function() end
		end
	end
end

_G.Markup = Markup
_G.ChunkTypes = ChunkTypes
