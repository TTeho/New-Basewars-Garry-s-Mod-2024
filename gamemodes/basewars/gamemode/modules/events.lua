MODULE.Name 	= "Events"
MODULE.Author 	= "Q2F2 & Ghosty"

local tag = "BaseWars.Events"
local PLAYER = debug.getregistry().Player

if SERVER then

	function MODULE:PayDay(ply)

		if not ply then

			for k,v in next, player.GetAll() do

				v:PayDay()

			end

			return

		end

		local Money 		= ply:GetMoney()

		local BaseRate 		= BaseWars.Config.PayDayBase
		local Thousands  	= math.floor(Money / BaseWars.Config.PayDayDivisor)

		local Final 		= math.max(BaseWars.Config.PayDayMin, BaseRate - Thousands + math.random(-BaseWars.Config.PayDayRandom, BaseWars.Config.PayDayRandom))

		local donator = BaseWars.Config.ScaleVIPPayDay and table.HasValue(BaseWars.Config.VIPRanks, ply:GetUserGroup())
		if donator then Final = math.max(math.floor(ply:GetMoney() * 0.002), Final) end
		Final = hook.Run("BW_PayDay", ply, Final) or Final

		if ply.AFKTime and ply:AFKTime() > 60 * 15 then
			local count = player.GetCount()
			if count >= math.min(game.MaxPlayers() / 5, 10) then
				ply:Notify("You just missed out on £" .. BaseWars.NumberFormat(Final) .. " because you were AFK.", BASEWARS_NOTIFICATION_ERROR)
			else
				Final = math.floor(Final / 2)
				ply:Notify("You received a reduced PayDay of £" .. BaseWars.NumberFormat(Final) .. " for seeding the server.", BASEWARS_NOTIFICATION_GENRL)
				ply:GiveMoney(Final)
			end
		else
			ply:Notify(string.format(BaseWars.LANG.PayDay, BaseWars.NumberFormat(Final)), BASEWARS_NOTIFICATION_MONEY)
			ply:GiveMoney(Final)
		end
	end
	PLAYER.PayDay = Curry(MODULE.PayDay)

	function MODULE:CleanupMap()

		for k, v in next, ents.FindByClass("game_text") do

			SafeRemoveEntity(v)

		end

	end

	timer.Create(tag .. ".PayDay", BaseWars.Config.PayDayRate, 0, Curry(MODULE.PayDay))
	hook.Add("InitPostEntity", tag .. ".CleanupMap", Curry(MODULE.CleanupMap))
	hook.Add("PostCleanupMap", tag .. ".CleanupMap", Curry(MODULE.CleanupMap))

end
