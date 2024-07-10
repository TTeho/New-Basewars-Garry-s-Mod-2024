AddCSLuaFile()

local tag    = "nametags_coh"
local start  = "nametags_coh.start"
local finish = "nametags_coh.finish"

if SERVER then
	util.AddNetworkString(tag)
	util.AddNetworkString(start)
	util.AddNetworkString(finish)

	net.Receive(start, function(_, ply)
		local uid = ply:UserID()
		net.Start(start)
			net.WriteUInt(uid, 16)
		net.Broadcast()
	end)

	net.Receive(finish, function(_, ply)
		local uid = ply:UserID()
		net.Start(finish)
			net.WriteUInt(uid, 16)
		net.Broadcast()
	end)

	net.Receive(tag, function(_, ply)
		local len  = net.ReadUInt(16)
		if len > 4096 then return end -- loudno

		local data = net.ReadData(len)
		local uid = ply:UserID()

		net.Start(tag)
			net.WriteUInt(uid, 16)
			net.WriteUInt(len, 16)
			net.WriteData(data, len)
		net.Broadcast()
	end)

	return
end

coh_players = coh_players or {}

do
	local char_limit = 48 -- configurable?

	local function wrap(data)
		data = string.Trim(data)

		if not data:match("\n") then
			data = utf8.totable(data)

			for i = char_limit, #data, char_limit do
				while data[i] ~= " " do
					if not data[i] then goto done end
					i = i + 1
				end

				data[i] = ""
				table.insert(data, i, "\n")
			end
			::done::

			data = table.concat(data, "")
		end
		-- if it has newlines assume its code and don't parse

		return data
	end

	-- recieve
	net.Receive(start, function()
		coh_players[net.ReadUInt(16)] = "..."
	end)

	net.Receive(finish, function()
		coh_players[net.ReadUInt(16)] = nil
	end)

	net.Receive(tag, function()
		local uid = net.ReadUInt(16)
		coh_players[uid] = "..."

		if not enabled_cl:GetBool() then return end

		local rec_name = "unknown"
		local rec_player = Player(uid)
		if IsValid(rec_player) then
			rec_name = rec_player:Nick()
		end

		local len = net.ReadUInt(16)
		if len > 4096 then print(string.format("warning: recieved massive coh data from '%s'", rec_name)) return end -- loudno

		local data = net.ReadData(len)

		data = util.Decompress(data)
		if not data then return end
		if string.len(data) > 4096 then print(string.format("warning: recieved massive coh data from '%s'", rec_name)) return end -- loudno

		coh_players[uid] = wrap(data)
	end)
end

do
	local box_color = Color(255, 255, 255)
	local text_color = Color(0, 0, 0)

	local poly = {
		{
			x = -16,
			y = 0,
		},
		{
			x = -16,
			y = 0,
		},
		{
			x = 16,
			y = 0,
		},
	}

	local font = "DermaLarge"

	surface.SetFont(font)
	local _, fontHeight = surface.GetTextSize("W|")

	hook.Add("OnRenderPlayerNametags", tag, function(ply, cur_y)
		local text = coh_players[ply:UserID()]

		if text then
			surface.SetFont(font)
			local tw = surface.GetTextSize(text)
			local lines = #string.Split(text, "\n")
			local lineh = fontHeight * lines

			cur_y = cur_y + 32

			surface.SetDrawColor(box_color)

			do
				surface.DrawRect(
					-tw / 2 - 16, -cur_y - lineh - 16,
					tw + 32, lineh + 32
				)

				poly[1].y = -cur_y + 32
				poly[2].y = -cur_y
				poly[3].y = -cur_y

				draw.NoTexture()
				surface.DrawPoly(poly)
			end

			draw.DrawText(text, font, -tw / 2, -cur_y - lineh, text_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		end
	end)
end
