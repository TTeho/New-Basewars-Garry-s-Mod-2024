AddCSLuaFile()
ENT.Base = "bw_base_moneyprinter"

ENT.Model = "models/props_junk/wood_crate001a.mdl"
ENT.Skin = 0

ENT.Capacity 		= 500
ENT.PrintInterval 	= 1
ENT.PrintAmount		= 3

ENT.PrintName = "Wooden Printer"

ENT.PresetMaxHealth = 20
ENT.PowerRequired = 1

ENT.MaxLevel = 1

function ENT:Draw()
	self:DrawModel()
end
