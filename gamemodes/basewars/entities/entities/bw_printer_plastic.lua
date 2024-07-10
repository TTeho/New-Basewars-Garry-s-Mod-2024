AddCSLuaFile()
ENT.Base = "bw_base_moneyprinter"

ENT.Model = "models/props_lab/partsbin01.mdl"
ENT.Skin = 0

ENT.Capacity 		= 750
ENT.PrintInterval 	= 1
ENT.PrintAmount		= 4

ENT.PrintName = "Plastic Printer"

ENT.PresetMaxHealth = 30
ENT.PowerRequired = 2

ENT.MaxLevel = 1

function ENT:Draw()
	self:DrawModel()
end
