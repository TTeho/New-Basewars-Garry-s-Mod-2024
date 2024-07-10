--JUST DONT EDIT THIS WITH REASON FOR STYLING PLEASE. - Trix
--does this count -Ghosty
LookEnt = {}

LookEnt.Key = Material("custom/key.png")
LookEnt.Dist = 150

LookEnt.ConVarName = "bw_interactions_enabled"
LookEnt.ConVar = CreateConVar(LookEnt.ConVarName, 1, FCVAR_ARCHIVE, "Enable the indicators for entities? 1 = Enabled, 0 = Disabled")

LookEnt.Draw = true

LookEnt.Ents = {}

surface.CreateFont("LookEnt.Key", {
	font = "Roboto",
	size = 28,
	weight = 800,
	antialias = false
})

surface.CreateFont("LookEnt.Text", {
	font = "Roboto",
	size = 24,
	weight = 800,
})

function LookEnt:RegisterEnt(class, key, action, color, cansee)
	key = string.upper(key)
	cansee = cansee or function(aimEnt) return true end
	LookEnt.Ents[class] = {key = key, action = action, color = color, cansee = cansee}
end

local me = LocalPlayer()

function LookEnt:Paint()
	if not LookEnt.Draw then return end
	if not IsValid(me) then me = LocalPlayer() end
	if not IsValid(me) then return end
	if not tobool(LookEnt.ConVar:GetInt()) then return end
	if LookEnt.Key:IsError() and NoDL then LookEnt.Key = Material("custom/key.png") LookEnt.Draw = false timer.Simple( 3, function() LookEnt.Draw = true end ) return end
	local aimEnt = me:GetEyeTrace().Entity
	if not BaseWars.Ents:Valid(aimEnt) then return end
	if aimEnt:GetClass() == "worldspawn" then return end

	local tbl = LookEnt.Ents[aimEnt:GetClass()] or (aimEnt.Base and LookEnt.Ents[aimEnt.Base] or nil)
	if not tbl then return end

	if not tbl.cansee(aimEnt) then return end

	if aimEnt:GetPos():Distance(me:GetPos()) > LookEnt.Dist then return end

	local key = tbl.key
	local action, name = tbl.action(aimEnt)
	local actionCol, nameCol = tbl.color(aimEnt)

	local sW = ScrW()
	local sH = ScrH()

	surface.SetFont("LookEnt.Key")
	local keyW, keyH = surface.GetTextSize(key)

	surface.SetFont("LookEnt.Text")
	local actionW, actionH = surface.GetTextSize(action)
	local nameW, nameH = surface.GetTextSize(name)

	local wholeW = actionW + nameW + 6

	local keySize = 40

	surface.SetMaterial(LookEnt.Key)
	surface.SetDrawColor(Color(255, 255, 225))
	surface.DrawTexturedRect(sW / 2 - keySize - wholeW/2 - 12, sH / 2 + 32, keySize, keySize)

	surface.SetFont("LookEnt.Key")
	surface.SetTextColor(Color(0, 0, 0, 255))
	surface.SetTextPos(sW / 2 - keySize / 2 - wholeW/2 - 12 - keyW / 2, sH / 2 + 32 + keyH / 2 - 7)
	surface.DrawText(key)

	surface.SetFont("LookEnt.Text")

	surface.SetTextColor(Color(0, 0, 0, 127))
	surface.SetTextPos(sW / 2 - keySize / 2 - wholeW/2 + 18 + 2, sH / 2 + 32 + keyH / 2 - 5 + 2)
	surface.DrawText(action)
	surface.SetTextColor(actionCol)
	surface.SetTextPos(sW / 2 - keySize / 2 - wholeW/2 + 18, sH / 2 + 32 + keyH / 2 - 5)
	surface.DrawText(action)

	surface.SetTextColor(Color(0, 0, 0, 127))
	surface.SetTextPos(sW / 2 - keySize / 2 - wholeW/2 + 18 + 6 + actionW + 2, sH / 2 + 32 + keyH / 2 - 5 + 2)
	surface.DrawText(name)
	surface.SetTextColor(nameCol)
	surface.SetTextPos(sW / 2 - keySize / 2 - wholeW/2 + 18 + 6 + actionW, sH / 2 + 32 + keyH / 2 - 5)
	surface.DrawText(name)
end

hook.Add("HUDPaint", "LookEnt.Paint", LookEnt.Paint)

local color1, color2 = Color(255, 255, 21), Color(128, 255, 0)
local color3 = Color(255, 0, 0)

local UseBind = input.LookupBinding("+use")

--The awful part down here
LookEnt:RegisterEnt("prop_door_rotating", UseBind, function(aimEnt)
	return BaseWars.LANG.Use, BaseWars.LANG.Door
end,
function(aimEnt)
	return color1, color2
end)

LookEnt:RegisterEnt("bw_base_moneyprinter", UseBind, function(aimEnt)
	return BaseWars.LANG.Collect, BaseWars.LANG.Money
end,
function(aimEnt)
	return aimEnt:GetMoney() > 0 and color1 or color3, color2
end)

LookEnt:RegisterEnt("bw_spawnpoint", UseBind, function(aimEnt)
	return aimEnt:GetUsable() and BaseWars.LANG.Activate or BaseWars.LANG.LookAt, BaseWars.LANG.Spawnpoint
end,
function(aimEnt)
	return color1, color2
end,
function(aimEnt)
	return aimEnt:GetUsable()
end)

LookEnt:RegisterEnt("bw_druglab", UseBind, function(aimEnt)
	return BaseWars.LANG.Use, "Drug Lab"
end,
function(aimEnt)
	return color1, color2
end)

LookEnt:RegisterEnt("bw_dispenser_armor", UseBind, function(aimEnt)
	return BaseWars.LANG.Use, "Armor Dispenser"
end,
function(aimEnt)
	return aimEnt:GetUsable() and color1 or color3, color2
end)
LookEnt:RegisterEnt("bw_dispenser_armor2", UseBind, function(aimEnt)
	return BaseWars.LANG.Use, "Armor Dispenser"
end,
function(aimEnt)
	return aimEnt:GetUsable() and color1 or color3, color2
end)

LookEnt:RegisterEnt("bw_dispenser_paper", UseBind, function(aimEnt)
	return BaseWars.LANG.Use, "Paper Dispenser"
end,
function(aimEnt)
	return aimEnt:GetUsable() and color1 or color3, color2
end)

LookEnt:RegisterEnt("bw_dispenser_ammo", UseBind, function(aimEnt)
	return BaseWars.LANG.Use, "Ammo Dispenser"
end,
function(aimEnt)
	return aimEnt:GetUsable() and color1 or color3, color2
end)
LookEnt:RegisterEnt("bw_dispenser_ammo2", UseBind, function(aimEnt)
	return BaseWars.LANG.Use, "Ammo Dispenser"
end,
function(aimEnt)
	return aimEnt:GetUsable() and color1 or color3, color2
end)

LookEnt:RegisterEnt("bw_vendingmachine", UseBind, function(aimEnt)
	return BaseWars.LANG.Use, "Vending Machine"
end,
function(aimEnt)
	return aimEnt:GetUsable() and color1 or color3, color2
end)

LookEnt:RegisterEnt("bw_drink_drug", UseBind, function(aimEnt)
	return BaseWars.LANG.Use, aimEnt:GetDrugEffect() or BaseWars.LANG.Drug
end,
function(aimEnt)
	return color1, color2
end)

LookEnt:RegisterEnt("bw_drink_vendingsoda", UseBind, function(aimEnt)
	return BaseWars.LANG.Drink, BaseWars.LANG.Soda
end,
function(aimEnt)
	return color1, color2
end)

LookEnt:RegisterEnt("bw_npc", UseBind, function(aimEnt)
	return BaseWars.LANG.TalkTo, BaseWars.LANG.HelpNPC
end,
function(aimEnt)
	return color1, color2
end)

LookEnt:RegisterEnt("bw_explosive_c4", UseBind, function(aimEnt)
	return BaseWars.LANG.Defuse, "C4"
end,
function(aimEnt)
	return color1, color2
end)

LookEnt:RegisterEnt("bw_explosive_bigbomb", UseBind, function(aimEnt)
	return aimEnt:GetNW2Bool("IsArmed") and BaseWars.LANG.Defuse or BaseWars.LANG.Plant, "Big Bomb"
end,
function(aimEnt)
	return color1, color2
end)

LookEnt:RegisterEnt("bw_explosive_mine", UseBind, function(aimEnt)
	return aimEnt:GetNW2Bool("Armed") and BaseWars.LANG.Defuse or BaseWars.LANG.Plant, "Mine"
end,
function(aimEnt)
	return color1, color2
end)

LookEnt:RegisterEnt("bw_explosive_mine_power", UseBind, function(aimEnt)
	return aimEnt:GetNW2Bool("Armed") and BaseWars.LANG.Defuse or BaseWars.LANG.Plant, "Mine"
end,
function(aimEnt)
	return color1, color2
end)

LookEnt:RegisterEnt("bw_explosive_mine_speed", UseBind, function(aimEnt)
	return aimEnt:GetNW2Bool("Armed") and BaseWars.LANG.Defuse or BaseWars.LANG.Plant, "Mine"
end,
function(aimEnt)
	return color1, color2
end)

LookEnt:RegisterEnt("bw_explosive_mine_shock", UseBind, function(aimEnt)
	return aimEnt:GetNW2Bool("Armed") and BaseWars.LANG.Defuse or BaseWars.LANG.Plant, "Mine"
end,
function(aimEnt)
	return color1, color2
end)

LookEnt:RegisterEnt("bw_explosive_nuke", UseBind, function(aimEnt)
	return aimEnt:GetNW2Bool("IsArmed") and BaseWars.LANG.Defuse or BaseWars.LANG.Plant, "Nuke"
end,
function(aimEnt)
	return color1, color2
end)
