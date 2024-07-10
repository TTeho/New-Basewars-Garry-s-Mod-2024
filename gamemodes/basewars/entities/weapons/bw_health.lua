AddCSLuaFile()

SWEP.PrintName 				= "Heal Gun"
SWEP.Author 				= "Q2F2 & Masterbrian123"
SWEP.Instructions 			= "Heal Objects and Players"
SWEP.Purpose 				= "Heals"

SWEP.Spawnable 				= true

SWEP.ViewModelFOV 			= 65
SWEP.ViewModel 				= "models/weapons/v_superphyscannon.mdl"
SWEP.WorldModel 			= "models/weapons/w_physics.mdl"

SWEP.AutoSwitchTo 			= true
SWEP.AutoSwitchFrom 		= false

SWEP.Slot 					= 5
SWEP.SlotPos 				= 1

SWEP.HoldType 				= "smg"
SWEP.FiresUnderwater 		= true
SWEP.Weight 				= 20
SWEP.DrawCrosshair 			= true
SWEP.Category 				= "BaseWars"
SWEP.DrawAmmo 				= false
SWEP.Base 					= "weapon_base"

SWEP.HealAmount 			= 2
SWEP.Primary.Damage     	= 0
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.Ammo 			= "none"
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Spread 		= 0.25
SWEP.Primary.NumberofShots 	= 1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Recoil 		= 0.01
SWEP.Primary.Delay 			= 0.08
SWEP.Primary.Force 			= 1

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= true
SWEP.Secondary.Ammo 		= "none"

SWEP.Sound 					= Sound("items/smallmedkit1.wav")
SWEP.Range					= 2^9

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end

	local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Range,
		filter = self.Owner
	})

	local ent = tr.Entity
	
	if IsValid(ent) and ent.GetMaxHealth and ent:GetMaxHealth() > 1 then
		if ent:Health() >= ent:GetMaxHealth() then return end
		local Armor = ent.Armor and ent:Armor()

		local bullet = {}
			bullet.Num = self.Primary.NumberofShots
			bullet.Src = self.Owner:GetShootPos()
			bullet.Dir = self.Owner:GetAimVector()
			bullet.Spread = self.Primary.Spread
			bullet.Tracer = 1
			bullet.TracerName = "ToolTracer"
			bullet.Force = self.Primary.Force
			bullet.Damage = self.Primary.Damage
			bullet.AmmoType = self.Primary.Ammo

		self.Owner:FireBullets(bullet)

		if SERVER then
			ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + self.HealAmount))
			if Armor then ent:SetArmor(Armor) end
			
			self.Owner:EmitSound(self.Sound, 50, math.min(ent:Health() / ent:GetMaxHealth() * 100, 255))
		end
	end
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:Reload() return false end
function SWEP:SecondaryAttack() return false end
