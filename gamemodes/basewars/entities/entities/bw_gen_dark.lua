AddCSLuaFile()

ENT.Base 			= "bw_base_generator"
ENT.PrintName 		= "Dark Fusion Reactor"

ENT.Model 			= "models/props/de_train/pallet_barrels.mdl"

ENT.PowerGenerated 	= 700
ENT.PowerCapacity 	= 110000

ENT.TransmitRadius 	= 900
ENT.TransmitRate 	= 60

ENT.Color 			= Color(50, 50, 50)

function ENT:Init()
	self:SetColor(self.Color)
end
