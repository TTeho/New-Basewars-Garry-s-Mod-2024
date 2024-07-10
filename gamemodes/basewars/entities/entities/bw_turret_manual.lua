--easylua.StartEntity( "bw_manual_turret2" )
AddCSLuaFile()

ENT.Base = "bw_base_electronics"
ENT.Type = "anim"

ENT.PrintName = "Controllable turret"
ENT.Model = "models/props_combine/combine_barricade_short02a.mdl"

ENT.GunModel = "models/weapons/w_mach_m249para.mdl"
ENT.GunOffset = Vector( 0, 0, 13 )
ENT.Gun = nil

ENT.UsedBy = nil
ENT.Used = false

ENT.OldAng = Angle( 0, 0, 0 )
ENT.LerpSpeed = 0.8

ENT.Damage = 34
ENT.Spread = 18
ENT.ShootAmt = 3
ENT.ShootDelay = 0

ENT.ShootPosOffset = Vector( 0, 0, 0 )

ENT.Sound = Sound("npc/turret_floor/shoot1.wav")

ENT.PresetMaxHealth = 2000

if SERVER then

function ENT:Init()

	self:SetModel(self.Model)
	self:GetPhysicsObject():EnableMotion( false )
    self.Turret = true

	timer.Simple( 0.1, function()
		if not IsValid(self) then return end

		self.Gun = ents.Create( "prop_physics" )
			self.Gun:SetModel( self.GunModel )
			self.Gun:SetPos( self:GetPos() + self.GunOffset)
			self.Gun:Spawn()
			self.Gun:GetPhysicsObject():EnableMotion( false )
			self.Gun:SetParent( self )
			self.Gun:SetSolid( 0 )
	end )

end

function ENT:ThinkFunc()
	if not self.UsedBy then return end

	local ply = self.UsedBy
	if not IsValid( ply ) then self.UsedBy = nil return end

	if not ply:Alive() then
		self.UsedBy:RemoveFlags( FL_ATCONTROLS )
		self.UsedBy:SetNW2Bool( "InTurret", false )
		self.UsedBy:SetNW2Entity( "Turret", nil )
		self.UsedBy = nil

		return
	end
	
	local targPos = ply:GetEyeTrace().HitPos
	local selfPos = self.Gun:GetPos()
	local ang = (targPos - selfPos):Angle()
	local lerped = LerpAngle( self.LerpSpeed, self.OldAng, ang )
	self.OldAng = lerped

	self.Gun:SetAngles( lerped )

	if ply:KeyDown( IN_ATTACK ) then
		if self.LastShoot and self.LastShoot + self.ShootDelay > CurTime() then return end
		self.ShootPosOffset = self.Gun:GetPos()
		self.LastShoot = CurTime()
		self:SpawnBullet( ply )
	end
end

function ENT:SpawnBullet( ply )
	local Bullet = self:GetBulletInfo( ply )

	for i = 1, self.ShootAmt do
		self.Gun:FireBullets( Bullet )
	end
	
    self:EmitSound(self.Sound)
end

function ENT:GetBulletInfo( ply )
	local bullet = {}
		bullet.Num = 1
		bullet.Damage = self.Damage
		bullet.Force = 1
		bullet.TracerName = "AR2Tracer"
		bullet.Spread = Vector(self.Spread, self.Spread, 0)
		bullet.Src = self.ShootPosOffset
		bullet.Dir = ply:GetEyeTrace().HitPos - self.Gun:GetPos()
		bullet.Attacker = ply

	return bullet
end

function ENT:Use( ply )
	self.Used = not self.Used

	if self.Used and not self.UsedBy then
		BaseWars.UTIL.Log( "ManualTurret: Used by " .. ply:Name() )

		self.UsedBy = ply
		self.UsedBy:SelectWeapon( "hands" )
		self.UsedBy:AddFlags( FL_ATCONTROLS )
		self.UsedBy:SetNW2Bool( "InTurret", true )
		self.UsedBy:SetNW2Entity( "Turret", self )

		timer.Simple( 0.2, function() if IsValid( self.UsedBy ) then self.UsedBy:SetPos( self:GetPos() - self:GetForward() * 30 + self:GetRight() * 15 - self:GetUp() * 28 ) end end )
		ply:ChatPrint( "You entered the turret (Press e on the barricade to leave)" )
	elseif ply == self.UsedBy then
		BaseWars.UTIL.Log( "ManualTurret: Ply " .. ply:Name() .. " left turret." )

		self.UsedBy:RemoveFlags( FL_ATCONTROLS )
		self.UsedBy:SetNW2Bool( "InTurret", false )
		self.UsedBy:SetNW2Entity( "Turret", nil )
		self.UsedBy = nil

		ply:ChatPrint( "You left the turret" )
	end
end

function ENT:OnRemove()
	SafeRemoveEntity( self.Gun )
end

end

--easylua.EndEntity( false, false )

if CLIENT then

hook.Add( "CreateMove", "ManualTurret", function( ucmd )
	if not LocalPlayer():GetNW2Bool( "InTurret", false ) then return end
	ucmd:SetButtons(bit.band(ucmd:GetButtons(), bit.bnot(IN_JUMP)))
end )

end

hook.Add( "PlayerSwitchWeapon", "ManualTurret", function( ply, oldweapon, newweapon )
	if not ply:GetNW2Bool( "InTurret", false ) then return end
	if newweapon ~= "hands" then return true end
end )

if SERVER then

local range = 300^2
hook.Add( "Think", "ManualTurret_Check", function()
    for _, ply in pairs( player.GetAll() ) do
		local turret = ply:GetNW2Entity( "Turret", nil )
        if ply:GetNW2Bool( "InTurret", false ) and (not IsValid(turret) or ply:GetPos():DistToSqr(turret:GetPos()) > range) then
            ply:SetNW2Bool( "InTurret", false )
            ply:SetNW2Entity( "Turret", nil )
            ply:RemoveFlags( FL_ATCONTROLS )
			
			if IsValid(turret) then
				turret.UsedBy = nil
				ply:ChatPrint( "You are too far from the turret!" )
			end
        end
    end
end )

hook.Add( "EntityTakeDamage", "ManualTurret", function( target, dmginfo )
    if target.Turret then
        if dmginfo:GetInflictor() == target.Gun then
            dmginfo:SetDamage( 0 )
        end
    end
end )

end
