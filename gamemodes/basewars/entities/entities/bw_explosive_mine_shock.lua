AddCSLuaFile()

ENT.Base = "bw_explosive_mine"
ENT.PrintName = "Shock Mine"

ENT.ExplodeRadius = 20

ENT.DetectRange = 220
ENT.TriggerDelay = 0.2
ENT.TriggerSound = Sound("npc/roller/mine/rmine_shockvehicle2.wav")

ENT.ShockRange = 500
ENT.ShockAmt = 200

function ENT:Trigger()
	self.Triggered = true
	self:EmitSound(self.TriggerSound)

	timer.Simple(self.TriggerDelay, function()
		if IsValid(self) then
			for k, v in ipairs(ents.FindInSphere(self:GetPos(), self.ShockRange)) do
				if v:IsPlayer() then
					v:ApplyDrug("Stun", self.ShockAmt * (self.ShockRange / self:GetPos():Distance(v:GetPos())))
				end
			end

			self:Explode()
		end
	end)
end
