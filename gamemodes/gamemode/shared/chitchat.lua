chatexp = {}
chatexp.NetTag = "chatexp" -- Do not change this unless you experience some very strange issues
chatexp.AbuseMode = "Kick" -- Kick or EarRape, this is what happens to people who try and epxloit the system

-- This is basicly chitchat3
-- Max message length is now 0x80000000 (10^31)
-- Filters are fixed, better mode handling.

local color_red = Color(225, 0, 0, 255)
local color_greentext = Color(0, 240, 0, 255)
local color_green = Color(0, 200, 0, 255)
local color_hint = Color(240, 220, 180, 255)

function net.HasOverflowed()
    return (net.BytesWritten() or 0) >= 65536
end

chatexp.Devs = {
	--Owners
	["STEAM_0:1:74836666"] = "Trixter",
	["STEAM_0:1:62445445"] = "Q2F2",
	["STEAM_0:0:133411986"] = "CakeShaked", --Trixter alt acc

	--Devs
	--["STEAM_0:0:80997988"] = "oplexz",
	["STEAM_0:1:32476157"] = "Tenrys",
	["STEAM_0:0:80669850"] = "user4992",
	--["STEAM_0:0:155546951"] = "notoplex",
	["STEAM_0:0:42138604"] = "Liquid",
	["STEAM_0:0:62588856"] = "Ghosty",
	--["STEAM_0:1:29543208"] = "ToastyEngineer",

}

chatexp.Reworkers = {
	--Reworkers
	["STEAM_0:0:483080973"] = "tehoo",
}

local tagParse
do
	local white,gray = Color(255,255,255),Color(128,128,128)
	local red, blu, green = Color(225,0,0), Color(80, 200, 255), Color(133,208,142)
	local orange = Color(255,160,30)
	local cyan = Color(0,255,255)

	local showranks = CreateConVar("bw_chat_showranks", "1", { FCVAR_ARCHIVE }, "Should we show player ranks when they talk? ex. \"[Owners] Q2F2: imgay\"")

	local function NiceFormat(str)
		local nice = str:lower()
		nice = str:gsub("^%l", string.upper)

		return nice
	end

	local ranks_tags = {
		["some_rank"] = { -- Group name on ULX, make sure to spell it right
			color = red,
			title = "Some Rank",
		},
		["some_other_rank"] = {
			color = blu,
			title = "Some Other Rank",
		},
	}

	-- ported from chitchat2
	function tagParse(tbl, ply)
		if IsValid(ply) and ply:IsPlayer() then
			local ugroup = ply:GetUserGroup()
			if chatexp.Devs[ply:SteamID()] then
				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "["
				tbl[#tbl + 1] = orange
				tbl[#tbl + 1] = "GM-Dev"
				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "] "
			elseif chatexp.Reworkers[ply:SteamID()] then
				tbl[#tbl + 1] = orange
				tbl[#tbl + 1] = "["
				tbl[#tbl + 1] = cyan
				tbl[#tbl + 1] = "Reworker"
				tbl[#tbl + 1] = orange
				tbl[#tbl + 1] = "] "
			elseif ranks_tags[ugroup] and showranks:GetBool() then
				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "["
				tbl[#tbl + 1] = ranks_tags[ugroup].color
				tbl[#tbl + 1] = ranks_tags[ugroup].title
				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "] "
			elseif (ply:IsAdmin() or (ply.IsMod and ply:IsMod())) and showranks:GetBool() then
				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "["
				tbl[#tbl + 1] = blu
				tbl[#tbl + 1] = NiceFormat(ugroup)
				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "] "
			end

			if table.HasValue(BaseWars.Config.VIPRanks, ugroup) then
				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "["
				tbl[#tbl + 1] = green
				tbl[#tbl + 1] = "$"
				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "] "
			end
		end
	end
end

chatexp.Modes = {
	{
			Name = "Default",
			Filter = function(send, ply)
				return true
			end,
			Handle = function(tbl, ply, msg, dead, mode_data)
				if dead then
					tbl[#tbl + 1] = color_red
					tbl[#tbl + 1] = "*DEAD* "
				end

				tagParse(tbl, ply)

				tbl[#tbl + 1] = ply -- ChatHUD parses this automaticly
				tbl[#tbl + 1] = color_white
				tbl[#tbl + 1] = ": "
				tbl[#tbl + 1] = color_white

				if msg:StartWith(">") and #msg > 1 then
					tbl[#tbl + 1] = color_greentext
				end

				tbl[#tbl + 1] = msg
			end,
	},
	{
			Name = "Team",
			Filter = function(send, ply)
				return send:Team() == ply:Team()
			end,
			Handle = function(tbl, ply, msg, dead, mode_data)
				if dead then
					tbl[#tbl + 1] = color_red
					tbl[#tbl + 1] = "*DEAD* "
				end

				tbl[#tbl + 1] = color_green
				tbl[#tbl + 1] = "(TEAM) "

				tagParse(tbl, ply)

				tbl[#tbl + 1] = ply -- ChatHUD parses this automaticly
				tbl[#tbl + 1] = color_white
				tbl[#tbl + 1] = ": "
				tbl[#tbl + 1] = color_white

				if msg:StartWith(">") and #msg > 1 then
					tbl[#tbl + 1] = color_greentext
				end

				tbl[#tbl + 1] = msg
			end,
	},
	{
			Name = "DM",
			-- No Filter.
			Handle = function(tbl, ply, msg, dead, mode_data)
				if ply == LocalPlayer() then
					tbl[#tbl + 1] = color_hint
					tbl[#tbl + 1] = "You"
					tbl[#tbl + 1] = color_white
					tbl[#tbl + 1] = " -> "
					tbl[#tbl + 1] = Player(mode_data)

					hook.Run("SendDM", Player(mode_data), msg)
				else
					tbl[#tbl + 1] = ply
					tbl[#tbl + 1] = color_white
					tbl[#tbl + 1] = " -> "
					tbl[#tbl + 1] = color_hint
					tbl[#tbl + 1] = "You"

					hook.Run("ReceiveDM", ply, msg)
				end

				tbl[#tbl + 1] = color_white
				tbl[#tbl + 1] = ": "

				tbl[#tbl + 1] = color_white
				tbl[#tbl + 1] = msg
			end,
	},
}

for k, v in next, chatexp.Modes do
	_G["CHATMODE_"..v.Name:upper()] = k
end

if CLIENT then

	local showTS = CreateConVar("bw_chat_timestamp_show", "0", FCVAR_ARCHIVE, "Show timestamps in chat")
	local hour24 = CreateConVar("bw_chat_timestamp_24h", "1", FCVAR_ARCHIVE, "Display timestamps in a 24-hour format")
	local tsSec = CreateConVar("bw_chat_timestamp_seconds", "0", FCVAR_ARCHIVE, "Display timestamps with seconds")

	local dgray = Color(150, 150, 150)

	local function pad(z)
		return z >= 10 and tostring(z) or "0" .. z
	end

	local zw = "\xE2\x80\x8B"
	local function MakeTimeStamp(t, h24, seconds)
		t[#t + 1] = dgray
		local d = os.date("*t")
		if h24 then
			t[#t + 1] = pad(d.hour) .. ":" .. zw .. pad(d.min) .. zw .. (seconds and ":" .. zw .. pad(d.sec) or "")
		else
			local h, pm = d.hour
			if h > 11 then
				pm = true
				h = h > 12 and h - 12 or h
			elseif h == 0 then
				h = 12
			end
			t[#t + 1] = pad(h) .. ":" .. zw .. pad(d.min) .. zw .. (seconds and ":" .. zw .. pad(d.sec) .. zw or "") .. (pm and " PM" or " AM")
		end
		t[#t + 1] = " - "
	end

	function chatexp.Say(msg, mode, mode_data)
		local cdata = util.Compress(msg)

		net.Start(chatexp.NetTag)
			net.WriteUInt(#cdata, 16)
			net.WriteData(cdata, #cdata)

			net.WriteUInt(mode, 8)
			net.WriteUInt(mode_data or 0, 16)
		net.SendToServer()
	end

	function chatexp.SayChannel(msg, channel)
		chatexp.Say(msg, CHATMODE_CHANNEL, channel)
	end

	function chatexp.DirectMessage(msg, ply)
		chatexp.Say(msg, CHATMODE_DM, ply:UserID())
	end

	net.Receive(chatexp.NetTag, function()
		local ply 	= net.ReadEntity()

		local len 	= net.ReadUInt(16)
		local data 	= net.ReadData(len)

		local mode 	= net.ReadUInt(8)
		local mode_data = net.ReadUInt(16)

		data = util.Decompress(data)

		if not data then
			Msg"CEXP" print"Failed to decompress message."
			return
		end

		local dead = ply:IsValid() and ply:IsPlayer() and not ply:Alive()
		gamemode.Call("OnPlayerChat", ply, data, mode, dead, mode_data)
	end)

	local gm = GM or GAMEMODE
	function gm:OnPlayerChat(ply, msg, mode, dead, mode_data)
		chatexp.LastPlayer = ply

		if mode == true  then mode = CHATMODE_TEAM end
		if mode == false then mode = CHATMODE_DEFAULT end

		local msgmode = chatexp.Modes[mode]
		local tbl = {}

		if showTS:GetBool() then
			MakeTimeStamp(tbl, hour24:GetBool(), tsSec:GetBool())
		end

		local ret
		if msgmode.Handle then
			ret = msgmode.Handle(tbl, ply, msg, dead, mode_data)
		else -- Some modes may just be a filter
			ret = chatexp.Modes[CHATMODE_DEFAULT].Handle(tbl, ply, msg, dead, mode_data)
		end

		if ret == false then return true end

		chat.AddText(unpack(tbl))
		return true
	end

else -- CLIENT

	util.AddNetworkString(chatexp.NetTag)

	function chatexp.FuckOff(ply)
		local m = chatexp.AbuseMode

		if m == "EarRape" then
			ply:SendLua[[local d=vgui.Create'DHTML'd:OpenURL'https://www.youtube.com/watch?v=WevymH75pW8'chat.AddText'dont fuck with chat']]
		elseif m == "Kick" then
			ply:Kick("Please refrain from touching *bzzzt*")
		end
	end

	function chatexp.SayAs(ply, data, mode, mode_data)
		if #data > 1024 then
			chatexp.FuckOff(ply)
			return
		end

		local ret = hook.Run("PlayerSay", ply, data, mode)

		if ret == "" or ret == false then return end
		if isstring(ret) then data = ret end

		(epoe and epoe.RealMsgC or MsgC)(Color(255, 255, 0, 255), ply, color_white, ": ", data, "\n")

		local msgmode = chatexp.Modes[mode]

		local filter = {}
		if mode == CHATMODE_DM then
			filter = {Player(mode_data)}
		elseif msgmode.Filter then
			for k, v in next,player.GetHumans() do
				if msgmode.Filter(ply, v) ~= false then filter[#filter+1] = v end
			end
		else
			filter = player.GetHumans()
		end

		if #filter == 0 then return end
		if not table.HasValue(filter, ply) then filter[#filter+1] = ply end

		local cdata = util.Compress(data)
		if not cdata then
			Msg"[CEXP] " print"Failed to re-compress message."
			return
		end

		net.Start(chatexp.NetTag)
			net.WriteEntity(ply)

			net.WriteUInt(#cdata, 16)
			net.WriteData(cdata, #cdata)

			net.WriteUInt(mode, 8)
			net.WriteUInt(mode_data, 16)

			if net.HasOverflowed() then
				Msg"[CEXP] " print("Net overflow -> '" .. data .. "'")
				return
			end
		net.Send(filter)
	end

	net.Receive(chatexp.NetTag, function(_, ply)
		local len		= net.ReadUInt(16)
		local cdata	= net.ReadData(len)

		local mode	= net.ReadUInt(8)
		local mode_data = net.ReadUInt(16)

		local data = util.Decompress(cdata)

		if not data then
			Msg"[CEXP] " print"Failed to decompress message."
			return
		end

		chatexp.SayAs(ply, data, mode, mode_data)
	end)

end -- SERVER
