AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Ammo Pack"

if SERVER then
	function ENT:SpawnFunction(ply)
		self:Remove()

		local wep = ply:GetActiveWeapon()
		if not wep:IsValid() then return end

		local clipSize    = wep.Primary and wep.Primary.ClipSize    or wep.GetStat and wep:GetStat("Primary.ClipSize") 
		local defaultClip = wep.Primary and wep.Primary.DefaultClip or wep.GetStat and wep:GetStat("Primary.DefaultClip")
		if not clipSize or not defaultClip then return end

		local percent = clipSize / defaultClip
		local ammoToGive = defaultClip * percent


		ply:GiveAmmo(ammoToGive, wep:GetPrimaryAmmoType())
		return self
	end		
end
