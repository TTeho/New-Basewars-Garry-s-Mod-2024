AddCSLuaFile()

ENT.Base            = "bw_vault"
ENT.Type            = "anim"

ENT.PrintName       = "VIP Money Vault"

ENT.Model           = "models/props_c17/furnituredrawer001a.mdl"

ENT.Radius          = 600
ENT.PowerRequired   = 15

ENT.PowerCapacity   = 25000
ENT.PresetMaxHealth = 1000

ENT.CollectInterval = 10 -- also interest interval for sake of simplicity
ENT.InterestRate    = 0.002

function ENT:Draw()
	self.FontColor = HSVToColor(CurTime() % 6 * 60, 1, 1)
	self.BaseClass.Draw(self)
end
