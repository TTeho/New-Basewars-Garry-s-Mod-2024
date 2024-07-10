AddCSLuaFile()

SWEP.Base      = "weapon_base"
SWEP.PrintName = "Hands"
SWEP.Author    = "Flex"
SWEP.Purpose   = ""

SWEP.Slot    = 1
SWEP.SlotPos = 0

SWEP.Spawnable = true
SWEP.Category 				= "BaseWars"

SWEP.ViewModel    = "models/weapons/c_arms.mdl"
SWEP.WorldModel   = ""
SWEP.ViewModelFOV = 90
SWEP.UseHands     = true

SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo        = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.DrawAmmo = false

SWEP._firstrun = false

local function Lockable(ply, ent)
	local eyes = ply:EyePos()
	local class = ent:GetClass()

	return IsValid(ent) and eyes:Distance(ent:GetPos()) < 65 and class:find("door")
end

function SWEP:DrawWeaponSelection(x,y,w,h,a)
	y = y + 10
	x = x + 10
	w = w - 20

	draw.DrawText("C","CreditsLogo",x+w/2,y,Color(255,220,0,a),TEXT_ALIGN_CENTER)
end

function SWEP:Initialize()
	self:SetHoldType( "normal" )
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:Deploy()
	if not self._firstrun then
		local vm = self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence("seq_admire"))
		self._firstrun = true
	end
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	local trace = ply:GetEyeTrace()

	local Ent = trace.Entity
	if not Ent or not Ent:IsValid() or not Lockable(ply, Ent) then return end

	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)

	if CLIENT then return end

	Ent:Fire("lock")
	ply:EmitSound("npc/metropolice/gear" .. math.random(1,6) .. ".wav")
end

function SWEP:SecondaryAttack()
	local ply = self:GetOwner()
    local trace = ply:GetEyeTrace()

	local Ent = trace.Entity
   if not Ent or not Ent:IsValid() or not Lockable(ply, Ent) then return end

    self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)

    if CLIENT then return end

    Ent:Fire("unlock")
	ply:EmitSound("npc/metropolice/gear" .. math.random(1,6) .. ".wav")
end
