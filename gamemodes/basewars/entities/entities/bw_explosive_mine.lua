AddCSLuaFile()

ENT.Base = "bw_base_explosive"
ENT.PrintName = "Explosive Mine"

ENT.Model = "models/props_combine/combine_mine01.mdl"

ENT.ExplodeRadius = 105
ENT.ShowTimer = false

ENT.Triggered = false
ENT.DetectRange = 220
ENT.TriggerDelay = 1.1
ENT.TriggerSound = Sound("npc/roller/mine/rmine_tossed1.wav")
ENT.ArmSound = Sound("npc/roller/mine/rmine_predetonate.wav")

ENT.PresetMaxHealth = 100

function ENT:Init()
	self:SetUseType(SIMPLE_USE)

	self:SetHealth(self.PresetMaxHealth)
	self:SetMaxHealth(self.PresetMaxHealth)
end

function ENT:Trigger()
	self.Triggered = true
	self:EmitSound(self.TriggerSound)

	timer.Simple(self.TriggerDelay, function()
		if IsValid(self) then
			self:Explode()
		end
	end)
end

function ENT:Use(activator)
	if self.NextUse and self.NextUse > CurTime() then return end
	self.NextUse = CurTime() + 1

	local Owner = BaseWars.Ents:ValidOwner(self)
	if not Owner or activator ~= Owner then return end

	local armed = self:GetNW2Bool("Armed", false)
	self:SetNW2Bool("Armed", not armed)
	self:EmitSound(self.ArmSound)

	local p = self:GetPhysicsObject()
	if IsValid(p) then
		p:EnableMotion(armed)
	end
end

function ENT:ThinkFunc()
	if not self:GetNW2Bool("Armed") or self.Triggered then return end

	local Owner = BaseWars.Ents:ValidOwner(self)
	if not Owner then return end

	for k, v in ipairs(ents.FindInSphere(self:GetPos(), self.DetectRange)) do
		if v:IsPlayer() and v:Alive() and Owner:IsEnemy(v) then
			self:Trigger()
			return
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	local dmg = dmginfo:GetDamage()
	local Attacker = dmginfo:GetAttacker()

	if dmg < 1 then return end

	self:SetHealth(self:Health() - dmg)

	if self:Health() <= 0 and not self.BlownUp then
		self.BlownUp = true

		self:Trigger()
	end
end
