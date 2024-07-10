AddCSLuaFile()

ENT.Base 				= "bw_dispenser_health"
ENT.Type 				= "anim"

ENT.PrintName 			= "Health Dispenser v2"
ENT.Author 				= "Q2F2"

ENT.Model 				= "models/props_combine/health_charger001.mdl"
ENT.Sound				= Sound("HL1/fvox/blip.wav")

ENT.MaxHealth           = 150
ENT.HealthAmt           = 25

function ENT:Init()
	self:SetModel(self.Model)
	self:SetHealth(5000)

	self:SetUseType(CONTINUOUS_USE)

	self:SetColor(Color(100, 100 ,255))
end
