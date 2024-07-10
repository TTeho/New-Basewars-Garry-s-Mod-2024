AddCSLuaFile()

ENT.Base = "bw_base_explosive"
ENT.PrintName = "Big Bomb"

ENT.Model = "models/props_c17/oildrum001.mdl"

ENT.ExplodeTime = 80
ENT.ExplodeRadius = 850
ENT.DefuseTime = 25
ENT.ShowTimer = true
ENT.OnlyPlantWorld = true
ENT.UsePlant = true

function ENT:DetonateEffects()
	local pos = self:GetPos()
	ParticleEffect("explosion_huge_b", pos + Vector(0, 0, 32), Angle())
	ParticleEffect("explosion_huge_c", pos + Vector(0, 0, 32), Angle())
	ParticleEffect("explosion_huge_c", pos + Vector(0, 0, 32), Angle())
	ParticleEffect("explosion_huge_g", pos + Vector(0, 0, 32), Angle())
	ParticleEffect("explosion_huge_f", pos + Vector(0, 0, 32), Angle())
	ParticleEffect("hightower_explosion", pos + Vector(0, 0, 32), Angle())
end

ENT.Cluster = true
ENT.ClusterAmt = 7
ENT.ClusterClass = "bw_explosive_bigbomb_fragment"
