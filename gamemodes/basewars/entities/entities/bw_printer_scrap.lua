AddCSLuaFile()
ENT.Base = "bw_base_moneyprinter"

ENT.Model = "models/props_lab/reciever01c.mdl"
ENT.Skin = 0

ENT.Capacity 		= 1000
ENT.PrintInterval 	= 1
ENT.PrintAmount		= 5

ENT.PrintName = "Scrap Metal Printer"

ENT.PresetMaxHealth = 45
ENT.PowerRequired = 2

ENT.MaxLevel = 1

function ENT:Draw()
	self:DrawModel()
end
