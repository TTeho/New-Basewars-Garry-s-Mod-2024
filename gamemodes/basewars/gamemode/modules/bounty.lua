MODULE.Name 	= "Bounty"
MODULE.Author 	= "Trixter"
MODULE.BountyTable = {}

local tag = "BaseWars.Bounty"
local PLAYER = debug.getregistry().Player

function MODULE:__INIT()

	if __BASEWARS_BOUNTY_BACKUP then

		BaseWars.UTIL.Log("Detected bounty backup. ATTEMPTING TO RESTORE.")
		self.BountyTable = table.Copy(__BASEWARS_BOUNTY_BACKUP)

		__BASEWARS_BOUNTY_BACKUP = nil

	end

end

if SERVER then

	function MODULE:GetBountyTbl()
		return BaseWars.Bounty.BountyTable
	end

	function MODULE:PlaceBounty(ply, who, amt)

		if not IsValid(ply) or not IsValid(who) then return false, BaseWars.LANG.InvalidPlayer end
		if who:EntIndex() == ply:EntIndex() then return false, BaseWars.LANG.BountyOnSelf end
		if who:GetMoney() < amt then return false, BaseWars.LANG.BountyNotEnoughMoney end
		if amt < 1 then return false, BaseWars.LANG.InvalidAmount end
		if who:InFaction() and ply:InFaction() and who:Team() == ply:Team() then return false, BaseWars.LANG.BountyInFaction end
		--if who.IsFriends and who:IsFriends(ply) then return false, BaseWars.LANG.BountyIsFriend end

		local tbl = self:GetBountyTbl()

		who:TakeMoney( amt )
		
		local added = false
		if tbl[ply:SteamID()] then 
			added = true
			tbl[ply:SteamID()] = tbl[ply:SteamID()] + amt 
		else
			tbl[ply:SteamID()] = amt
		end
	
		if added then
			PrintMessage(3, "Bounty on player " .. ply:Name() .. " has increased to " .. BaseWars.NumberFormat(tbl[ply:SteamID()]) )
		else
			PrintMessage(3, "Bounty of " .. BaseWars.LANG.CURRENCY .. BaseWars.NumberFormat(amt) .. " has been placed on " .. ply:Name())
		end
		BaseWars.UTIL.Log("Players " .. ply:Name() .. " bounty was set to " .. BaseWars.LANG.CURRENCY .. BaseWars.NumberFormat(amt) .. ".")

	end
	PLAYER.PlaceBounty = Curry(MODULE.PlaceBounty)

	function MODULE:RemoveBounty(ply)

		local tbl = self:GetBountyTbl()
		tbl[ply:SteamID()] = nil

		ply:SetNWInt(tag, 0)

		PrintMessage(3, "Bounty on " .. ply:Name() .. " has been removed.")
		BaseWars.UTIL.Log("Players " .. ply:Name() .. " bounty was removed." )

	end
	PLAYER.RemoveBounty = Curry(MODULE.RemoveBounty)

	function MODULE:PlayerDeath( victim, inflictor, attacker )

		if not IsValid(victim) or not IsValid(attacker) or not victim:IsPlayer() or not attacker:IsPlayer() then return end
		if victim == attacker then return end

		local tbl = self:GetBountyTbl()
		local amt = tbl[victim:SteamID()]

		if not amt then return end

		attacker:GiveMoney( math.min(attacker:GetMoney() * BaseWars.Config.BountyDelimiter, amt) )
		tbl[victim:SteamID()] = nil

		PrintMessage(3, "Bounty on " .. victim:Name() .. " has been claimed by " .. attacker:Name() .. ".")

	end
	hook.Add("PlayerDeath", tag, Curry(MODULE.PlayerDeath))

end

function MODULE:GetBounty(ply)

	if SERVER then
		return self:GetBountyTbl()[ply:SteamID()]
	else
		return self:GetNW2Int(tag, 0)
	end

end
PLAYER.GetBounty = Curry(MODULE.GetBounty)

