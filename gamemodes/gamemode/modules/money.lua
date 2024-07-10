MODULE.Name 	= "Money"
MODULE.Author 	= "Q2F2, Ghosty and Tenrys"

local tag = "BaseWars.Money"
local PLAYER = debug.getregistry().Player

local function isPlayer(ply)

	return (IsValid(ply) and ply:IsPlayer())
	
end

function MODULE:GetMoney(ply)

	return tonumber(ply:GetNWString(tag)) or 0
	
end
PLAYER.GetMoney = Curry(MODULE.GetMoney)

if SERVER then

	function MODULE:InitMoney(ply)
	
		BaseWars.MySQL.InitPlayer(ply, "money", tostring(BaseWars.Config.StartMoney))
		
	end
	PLAYER.InitMoney = Curry(MODULE.InitMoney)

	for k, v in next,player.GetAll() do
		
		MODULE:InitMoney(v)
	
	end

	function MODULE:SaveMoney(ply, amount)
	
		BaseWars.MySQL.SaveVar(ply, "money", amount or self:GetMoney(ply))

	end
	PLAYER.SaveMoney = Curry(MODULE.SaveMoney)
	
	function MODULE:LoadMoney(ply)
		
		self:InitMoney(ply)
		
		BaseWars.MySQL.LoadVar(ply, "money", function(ply, var, val)
			if not IsValid(ply) then return end
			
			ply:SetNWString(tag, tostring(val))
		end)
	
	end
	PLAYER.LoadMoney = Curry(MODULE.LoadMoney)

	function MODULE:SetMoney(ply, amount)
		local amount = tonumber(amount)
		
		if not isnumber(amount) or amount < 0 then amount = 0 end
		if amount ~= amount then amount = 0 end
		
		amount = math.Round(amount)
		self:SaveMoney(ply, amount)
		
		ply:SetNWString(tag, tostring(amount))
		
	end
	PLAYER.SetMoney = Curry(MODULE.SetMoney)

	function MODULE:GiveMoney(ply, amount)
	
		self:SetMoney(ply, self:GetMoney(ply) + amount)
		
	end
	PLAYER.GiveMoney = Curry(MODULE.GiveMoney)
	
	function MODULE:TakeMoney(ply, amount)
	
		self:SetMoney(ply, self:GetMoney(ply) - amount)
		
	end
	PLAYER.TakeMoney = Curry(MODULE.TakeMoney)

	function MODULE:TransferMoney(ply1, amount, ply2)
	
		self:TakeMoney(ply1, amount)
		self:GiveMoney(ply2, amount)
		
	end
	PLAYER.TransferMoney = Curry(MODULE.TransferMoney)

	hook.Add("LoadData", tag .. ".Load", Curry(MODULE.LoadMoney))
	hook.Add("PlayerDisconnected", tag .. ".Save", Curry(MODULE.SaveMoney))
	
end
