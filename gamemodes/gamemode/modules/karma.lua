MODULE.Name 	= "Karma"
MODULE.Author 	= "Q2F2 & Ghosty"

local tag = "BaseWars.Karma"
local PLAYER = debug.getregistry().Player

local function isPlayer(ply)

	return (IsValid(ply) and ply:IsPlayer())
	
end

function MODULE:Get(ply)
	
	return tonumber(ply:GetNWString(tag)) or 0
	
end
PLAYER.GetKarma = Curry(MODULE.Get)

if SERVER then

	function MODULE:Init(ply)
	
		BaseWars.MySQL.InitPlayer(ply, "karma", "0")
		
	end
	PLAYER.InitKarma = Curry(MODULE.Init)

	for k, v in next, player.GetAll() do
		
		MODULE:Init(v)
	
	end

	function MODULE:Save(ply, amount)

		BaseWars.MySQL.SaveVar(ply, "karma", amount or self:Get(ply))
		
	end
	PLAYER.SaveKarma = Curry(MODULE.Save)
	
	function MODULE:Load(ply)
	
		self:Init(ply)
		
		BaseWars.MySQL.LoadVar(ply, "karma", function(ply, var, val)
			if not IsValid(ply) then return end
			
			ply:SetNWString(tag, tostring(val))
		end)
		
	end
	PLAYER.LoadKarma = Curry(MODULE.Load)

	function MODULE:Set(ply, amount)

		if not isnumber(amount) or amount < -100 then amount = -100 end
		if amount > 100 then amount = 100 end
		
		amount = math.Round(amount)
		self:Save(ply, amount)
		
		ply:SetNWString(tag, tostring(amount))
		
	end
	PLAYER.SetKarma = Curry(MODULE.Set)

	function MODULE:Add(ply, amount)
		
		local Value = ply:GetKarma()
		
		ply:SetKarma(Value + amount)
		
	end
	PLAYER.AddKarma = Curry(MODULE.Add)
	
	hook.Add("LoadData", tag .. ".Load", Curry(MODULE.Load))
	hook.Add("PlayerDisconnected", tag .. ".Save", Curry(MODULE.Save))
	
end
