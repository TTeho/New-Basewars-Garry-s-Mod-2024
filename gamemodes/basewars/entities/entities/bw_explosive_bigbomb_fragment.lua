AddCSLuaFile()

ENT.Base = "bw_base_explosive"
ENT.PrintName = "Big Bomb Shrapnel"

ENT.ExplodeRadius = 300
ENT.ShowTimer = false

ENT.Models = {"models/props_c17/oildrumchunk01a.mdl", "models/props_c17/oildrumchunk01b.mdl", "models/props_c17/oildrumchunk01c.mdl", "models/props_c17/oildrumchunk01d.mdl", "models/props_c17/oildrumchunk01e.mdl"}

function ENT:Init()
	self:SetModel(table.Random(self.Models))

	util.SpriteTrail(self, 0, Color(255, 255, 255), false, 16, 0, 3, 0.03125, "trails/smoke.vmt")
end

function ENT:PhysicsCollide(d, p)
	local e = d.HitEntity
	if (IsValid(e) or e == Entity(0)) and e:GetClass() ~= "bw_explosive_bigbomb_fragment" then self:Explode() end
end
