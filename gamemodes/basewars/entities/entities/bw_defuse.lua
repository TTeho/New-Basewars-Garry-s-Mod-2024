AddCSLuaFile()

ENT.Base 		= "base_gmodentity"
ENT.Type 		= "anim"
ENT.PrintName 	= "Defuse Kit"

ENT.Model 		= "models/weapons/w_defuser.mdl"

if CLIENT then return end

function ENT:SpawnFunction(ply, tr, class)
	local pos = ply:GetPos()

	local ent = ents.Create(class)
		ent:CPPISetOwner(ply)
		ent:SetPos(pos + ply:GetForward() * 32)
	ent:Spawn()
	ent:Activate()

	local phys = ent:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
	end

	return ent
end

function ENT:Initialize()
	self.BaseClass:Initialize()

	self:SetModel(self.Model)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)

	self:PhysWake()

	self:Activate()
end

function ENT:Use(ply)
	if not (IsValid(ply) and ply:IsPlayer()) then return end

	if not ply:GetNW2Bool("BW_Defuser") and not self.Removing then
		ply:SetNW2Bool("BW_Defuser", true)

		self.Removing = true
		self:Remove()
	end
end
