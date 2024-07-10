AddCSLuaFile()

nametags = nametags or {}

include("nt2/titles.lua")
include("nt2/nametags_parser.lua")

include("nt2/nametags_coh.lua")

if SERVER then return end

-- Serverside max fade range.
nametags.max_range = 512

local tag = "nametags"
local max, min, sqrt, ceil, floor = math.max, math.min, math.sqrt, math.ceil, math.floor

local function clamp(x, a, b)
	return min(max(x, a), b)
end

local function frac(a, b, x)
	return (x - a) / (b - a)
end

do
	local font_convar_cache = {}
	local font_name_cache = {}

	local function updateInternalFonts(id, name_cache, convar_cache)
		local font_data = {
			size     = name_cache.size,

			font     = convar_cache.font:GetString(),
			weight   = max(convar_cache.weight:GetInt(), 0),
			italic   = convar_cache.italic:GetBool(),
		}

		font_data.blursize = 0
		surface.CreateFont(name_cache[1], font_data)

		font_data.blursize = clamp(convar_cache.blursize:GetInt(), 0, 100)
		surface.CreateFont(name_cache[2], font_data)
	end

	function nametags.rebuildFont(id)
		updateInternalFonts(id, font_name_cache[id], font_convar_cache[id])
	end

	function nametags.createConvarFont(id, size, default_font, default_weight, default_blursize, default_font_unix)
		if font_name_cache[id] then
			local name_cache = font_name_cache[id]
			return name_cache[1], name_cache[2], name_cache.size
		end

		default_font     = default_font     or "Roboto"
		default_weight   = default_weight   or 1
		default_blursize = default_blursize or 8

		if jit.os ~= "Windows" and default_font_unix then
			default_font = default_font_unix
		end

		local name_cache = {}
		font_name_cache[id] = name_cache

		-- font names actually registered
		name_cache[1] = tag .. "_" .. id
		name_cache[2] = tag .. "_" .. id .. "_blur"

		name_cache.size = size

		local convar_cache = {}
		font_convar_cache[id] = convar_cache

		-- convars to avoid re-getting them
		local convar_prefix = tag .. "_fonts_" .. id
		local rebuild = function(_, old, new)
			nametags.rebuildFont(id)
		end

		convar_cache.font = CreateClientConVar(convar_prefix .. "_font", default_font, true, false, "What should the base font for " .. id .. "s be?")
		cvars.AddChangeCallback(convar_prefix .. "_font", rebuild, "font_rebuild")

		convar_cache.weight = CreateClientConVar(convar_prefix .. "_weight", tostring(default_weight), true, false, "What should the weight for " .. id .. "s be?")
		cvars.AddChangeCallback(convar_prefix .. "_weight", rebuild, "font_rebuild")

		convar_cache.italic = CreateClientConVar(convar_prefix .. "_italic", "0", true, false, "Should " .. id .. "s be italic?")
		cvars.AddChangeCallback(convar_prefix .. "_italic", rebuild, "font_rebuild")

		convar_cache.blursize = CreateClientConVar(convar_prefix .. "_blursize", tostring(default_blursize), true, false, "What should the blur size for " .. id .. "s be?")
		cvars.AddChangeCallback(convar_prefix .. "_blursize", rebuild, "font_rebuild")

		-- perform first build
		updateInternalFonts(id, name_cache, convar_cache)

		return name_cache[1], name_cache[2], size
	end

	function nametags.getFontNames(id)
		local name_cache = font_name_cache[id]
		return name_cache[1], name_cache[2], name_cache.size
	end
end

do
	local drawTxt
	do
		local default_color = Color(255, 255, 255, 255)

		function drawTxt(font, col, x, y, txt)
			surface.SetFont(font)
			surface.SetTextColor(col or default_color)
			surface.SetTextPos(ceil(x), ceil(y))
			surface.DrawText(txt)
		end
	end

	local data_cache = {}
	local shadow_color = Color(0, 0, 0, 192)

	local function drawTextBlurCached(id, data, font_id, x, y, default_color, center, alpha, passes)
		default_color = default_color or Color(255, 255, 255, 255)
		passes        = passes        or 2
		alpha         = alpha         or 1

		local font, font_blur, h = nametags.getFontNames(font_id)

		local entire_string, w
		local strings, s_idx

		if id and data_cache[id] and data_cache[id][default_color] then
			local v = data_cache[id]
			entire_string, w, strings, s_idx = v[1], v[2], v[3], v[4]
		else
			entire_string, w = "", 0
			strings, s_idx = {}, 0

			surface.SetFont(font)
			local last_color = default_color

			for _, v in ipairs(data) do
				if isstring(v) then
					local vw --[[, vh]] = surface.GetTextSize(v)

					w = w + vw
					entire_string = entire_string .. v

					s_idx = s_idx + 1
					strings[s_idx] = {v, vw, last_color}
				else
					last_color = v
				end
			end

			if id then
				data_cache[id] = data_cache[id] or {}
				data_cache[id][default_color] = {entire_string, w, strings, s_idx}
			end
		end

		local alignment = 0
		if center then
			alignment = -w / 2
		end
		x = x + alignment

		shadow_color.a = 192 * alpha

		-- rendering starts here
		for i = 1, passes do
			drawTxt(font_blur, shadow_color, x - 1, y - h, entire_string)
		end

		local cur_x = x
		for i = 1, s_idx do
			local v = strings[i]
			local txt, txt_w, color = v[1], v[2], v[3]
			color = Color(color.r, color.g, color.b, color.a * alpha)

			drawTxt(font, color, cur_x, y - h, txt)
			cur_x = cur_x + txt_w
		end
	end

	function nametags.drawMarkupText(txt, font_id, x, y, default_color, center, alpha, passes)
		local data, static = nametags.parser(txt, default_color)
		drawTextBlurCached(static and txt or nil, data, font_id, x, y, default_color, center, alpha, passes)
	end

	function nametags.drawPlayerNick(ply, font_id, x, y, center, alpha, passes)
		local nick, color = ply:Nick(), team.GetColor(ply:Team())
		nametags.drawMarkupText(nick, font_id, x, y, color, center, alpha, passes)
	end
end

do
	local eye_pos--[[, eye_ang]] = Vector() --[[, Angle()]]
	local players, frame_num = {}, 0

	hook.Add("RenderScene", tag, function(pos, ang)
		eye_pos   = pos
		--eye_ang   = ang
		frame_num = FrameNumber()
	end)

	hook.Add("UpdateAnimation", tag, function(ply)
		players[ply] = frame_num
	end)

	local render_pos, render_ang, render_alpha = Vector(), Angle(), 1
	local render_offset, render_scale = Vector(0, 0, 8), .066

	local function set3D2DPlayer(ply)
		local ent

		local ragdoll = ply:GetRagdollEntity()
		if not ply:Alive() and IsValid(ragdoll) then
			ent = ragdoll
		elseif ply:Alive() then
			ent = ply
		else
			return false
		end

		local eye_attch = ply:LookupAttachment("eyes")
		if not (eye_attch and eye_attch >= 0) then return false end

		local eyes = ent:GetAttachment(eye_attch)
		if not eyes then return false end

		render_pos   = eyes.Pos
		render_ang   = Angle()
		render_ang.p = 0
		render_ang.y = (render_pos - eye_pos):Angle().y
		render_ang.r = 0
		render_ang:RotateAroundAxis(render_ang:Up(), -90)
		render_ang:RotateAroundAxis(render_ang:Forward(), 90)

		return true
	end

	local function isPlayerTarget(ply, pfn)
		if pfn ~= frame_num - 1 and ply:Alive() then
			return false
		end

		return true
	end

	local setupRenderAlpha
	do
		local max_range_cvar = CreateClientConVar(tag .. "_draw_maxrange", "512", true, false, "How far away should nametags draw? This is limited by the server.")

		local max_range = max_range_cvar:GetInt()
		local max_range_sqr, max_range_sqr_full = max_range * max_range, (max_range + 100) * (max_range + 100)

		local rebuild_max = function(_, old, new)
			max_range = clamp(new, 0, nametags.max_range)
			max_range_sqr, max_range_sqr_full = max_range * max_range, (max_range + 100) * (max_range + 100)
		end
		cvars.AddChangeCallback(tag .. "_draw_maxrange", rebuild_max, "rebuild_max")

		local fade_range_cvar = CreateClientConVar(tag .. "_draw_faderange", "96", true, false, "How close to players should nametags fade to avoid being in the way?")

		local fade_range = fade_range_cvar:GetInt()
		local fade_range_sqr = fade_range * fade_range

		local rebuild_fade = function(_, old, new)
			fade_range = clamp(new, 0, max_range)
			fade_range_sqr = fade_range * fade_range
		end
		cvars.AddChangeCallback(tag .. "_draw_faderange", rebuild_fade, "rebuild_fade")

		local should_draw_local = CreateClientConVar(tag .. "_draw_localplayer", "1", true, false, "Should the nametags draw for the local player (you)?")
		function setupRenderAlpha(ply)
			local local_player = LocalPlayer()

			render_alpha = 1

			if ply == local_player then
				local draw_local = should_draw_local:GetBool() and local_player:ShouldDrawLocalPlayer()
				local local_afk  = local_player.IsAFK and local_player:IsAFK()

				if draw_local or local_afk then
					return -- alpha is already 1
				else
					render_alpha = 0
					return
				end
			end

			local dist_sqr = ply:GetPos():DistToSqr(eye_pos)

			if dist_sqr <= fade_range_sqr then
				render_alpha = math.max(0, frac(fade_range - 32, fade_range, sqrt(dist_sqr)))
			elseif dist_sqr >= max_range_sqr_full then
				render_alpha = 0 -- avoid math
			elseif dist_sqr >= max_range_sqr then
				render_alpha = math.max(0, 1 - frac(max_range, max_range + 64, sqrt(dist_sqr)))
			end
		end
	end

	local should_draw = CreateClientConVar(tag .. "_draw", "1", true, false, "Should the nametags draw?")
	hook.Add("PostPlayerDraw", tag, function(ply)
		if not should_draw:GetBool() or hook.Run("ShouldRenderPlayerNametags", ply) == false then return end

		local pfn = players[ply] or 0
		if not isPlayerTarget(ply, pfn) then return end

		setupRenderAlpha(ply)

		if render_alpha > 0.01 and res ~= false and set3D2DPlayer(ply) then
			cam.Start3D2D(render_pos + render_offset, render_ang, render_scale)
				hook.Run("OnRenderPlayerNametags", ply, nametags.mainRenderPlayer(ply))
			cam.End3D2D()
		end
	end)

	hook.Add("HUDDrawTargetID", tag, function(ply)
		if should_draw:GetBool() then return false end
	end)

	function nametags.draw3D2DMarkupText(txt, font_id, y, default_color, passes)
		nametags.drawMarkupText(txt, font_id, 0, -y, default_color, true, render_alpha, passes)
	end

	function nametags.draw3D2DPlayerNick(ply, font_id, y, passes)
		nametags.drawPlayerNick(ply, font_id, 0, -y, true, render_alpha, passes)
	end
end

do
	local afk_phrases = {
		"Boire du thé...",
		"Dors devant son PC",
		"Pas là...",
		"Nous rompîchames...",
		"Zzz...",
		"Fait dodo...",
	}

	local padding_cvar = CreateClientConVar(tag .. "_draw_padding", "-28", true, false, "How much should the lines be padded (- means closer).")

	local padding = padding_cvar:GetInt()

	local rebuild_padding = function(_, old, new)
		padding = new
	end
	cvars.AddChangeCallback(tag .. "_draw_padding", rebuild_padding, "rebuild_padding")

	-- TODO: Put into info table to reduce this cancer code
	-- Add optional border box ala vr char https://www.youtube.com/watch?v=eR7yRKBromQ&t=323s
	-- Add speaking + typing indicators
	-- Make something like AFCamera
	function nametags.mainRenderPlayer(ply)
		local cur_y = 0

		if ply:Crouching() then
			return cur_y -- coh
		end

		if ply.GetCustomTitle then
			local title = ply:GetCustomTitle()

			if title and title:Trim() ~= "" then
				local _, _, title_size = nametags.createConvarFont("title", 72, "Roboto", 1, 6)

				nametags.draw3D2DMarkupText(ply:GetCustomTitle(), "title", cur_y)
				cur_y = cur_y + title_size + padding
			end
		end

		do
			local _, _, name_size  = nametags.createConvarFont("name", 128, "Segoe UI", 880, 8, "Fira Sans")

			nametags.draw3D2DPlayerNick(ply, "name", cur_y)
			cur_y = cur_y + name_size + padding
		end

		if ply.IsAFK and ply:IsAFK() then
			local _, _, afk_size = nametags.createConvarFont("afk", 50, "Roboto", 880, 8)

			local len = ply:AFKTime()
			local h = floor(len / 60 / 60)
			local m = floor(len / 60 - h * 60)
			local s = floor(len - m * 60 - h * 60 * 60)

			local afk_time = string.format("%.2d:%.2d:%.2d", h, m, s)
			local str = afk_phrases[floor((CurTime() / 4 + ply:EntIndex()) % #afk_phrases) + 1]

			nametags.draw3D2DMarkupText(string.format("<color=172,255,86>%s</color> - <color=122,122,172>%s</color>", str, afk_time), "afk", cur_y)
			cur_y = cur_y + afk_size + padding
		else
			local _, _, health_size  = nametags.createConvarFont("health", 64, "Segoe UI", 1, 8, "Fira Sans")

			local str
			local health = ply:Health()
			if health <= 0 then
				str = "<color=255,64,64>Dead</color>"

				if ply.GetRespawnTime and isnumber(ply:GetRespawnTime()) then
					local len = ply:GetRespawnTime()

					if len > 0 then
						local m = floor(len / 60)
						local s = floor(len - m * 60)

						str = string.format("%s - <color=122,122,172>%.2d:%.2d</color>", str, m, s)
					end
				end
			elseif health >= 1 and health <= 25 then
				str = "<color=255,127,64>Près de la mort</color>"
			elseif health >= 26 and health <= 50 then
				str = "<color=255,255,6>Gravement blessé</color>"
			elseif health >= 51 and health <= 75 then
				str = "<color=147,225,64>Blessé</color>"
			end

			if str then
				nametags.draw3D2DMarkupText(str, "health", cur_y)
				cur_y = cur_y + health_size + padding
			end
		end

		return cur_y
	end
end
