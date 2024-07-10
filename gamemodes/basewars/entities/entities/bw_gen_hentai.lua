AddCSLuaFile()

ENT.Base 			= "bw_base_generator"
ENT.PrintName 		= "Hentai Generator"

ENT.Model 			= "models/props_junk/garbage_newspaper001a.mdl"

ENT.PowerGenerated 	= 696969
ENT.PowerCapacity 	= 69696969

ENT.TransmitRadius 	= 400
ENT.TransmitRate 	= 6969

ENT.Color			= Color(255, 20, 147, 255)

function ENT:Init()
	self:SetColor(self.Color)
end
