AddCSLuaFile()

SWEP.PrintName    = "Laser Gun"
SWEP.Author       = "Ghosty"
SWEP.Instructions = "Left-click to shoot\nRight-click to shoot\nHold reload to charge an attack"
SWEP.Purpose      = "Shoot things"
SWEP.Slot         = 2

SWEP.ViewModel    = "models/weapons/c_irifle.mdl"
SWEP.WorldModel   = "models/weapons/w_irifle.mdl"

SWEP.UseHands     = true

SWEP.Primary = {
	Ammo        = "",
	DefaultClip = -1,
	ClipSize    = -1,
	Automatic   = true,
}

SWEP.Secondary = {
	Ammo        = "",
	DefaultClip = -1,
	ClipSize    = -1,
	Automatic   = false,
}

local function rand_from_tbl(tbl)
	return tbl[math.random(1, #tbl)]
end

local shoot_sound        = Sound("ui/hitsound_space.wav")
local blitzer_sounds      = {Sound("weapons/bison_main_shot_01.wav"), Sound("weapons/bison_main_shot_02.wav")}
local blitzer_sound_extra = Sound("weapons/bumper_car_hit_ball.wav")
local shotgun_sounds     = {Sound("weapons/3rd_degree_hit_01.wav"), Sound("weapons/3rd_degree_hit_02.wav"), Sound("weapons/3rd_degree_hit_03.wav"), Sound("weapons/3rd_degree_hit_04.wav")}

local cannon_charge_sound = Sound("ambient/machines/combine_shield_touch_loop1.wav")
local cannon_sounds       = {Sound("weapons/airstrike_fire_01.wav"), Sound("weapons/airstrike_fire_02.wav"), Sound("weapons/airstrike_fire_03.wav")}
local cannon_fail_sound   = Sound("buttons/combine_button2.wav")

local fire_mode_change_sound = Sound("buttons/button14.wav")

local loud = 120
local ears = 180

function SWEP:Initialize()
	if SERVER then
		self:SetNW2Float("Start", CurTime())
		self:SetNW2Float("timer_blitzer", CurTime())

		self.ChargeSound = CreateSound(self.Weapon, cannon_charge_sound)
		self.ChargeSound:SetSoundLevel(ears)
		self.ChargeSound:ChangeVolume(1)
		self.ChargeSound:Stop()
	end

	self:SetHoldType("ar2")
end

function SWEP:Trace(distance, spread, i)
	local filter = self.Owner
	local start  = filter:GetShootPos()
	local ang    = filter:EyeAngles()

	math.randomseed(CurTime() + i)
	ang:RotateAroundAxis(ang:Right(), math.random(-spread, spread))
	math.randomseed(CurTime() + 2 * i)
	ang:RotateAroundAxis(ang:Up(), math.random(-spread, spread))

	local endpos = start + ang:Forward() * distance

	local tr = util.TraceLine {start = start, endpos = endpos, filter = filter}

	return tr, SERVER and (1 - (start:Distance(tr.HitPos) / start:Distance(endpos))) or 0
end

function SWEP:ShootEffects(tr, green, explosion)
	if not IsFirstTimePredicted() then return end

	local ef = EffectData()
	ef:SetStart(self.Owner:GetShootPos())
	ef:SetOrigin(tr.HitPos)
	ef:SetAttachment(1)
	ef:SetEntity(self)

	util.Effect("ToolTracer", ef)

	if green then
		util.Effect("LaserTracer", ef)
	end

	if explosion then
		local data1 = EffectData()
		data1:SetOrigin(self.Owner:GetShootPos())
		util.Effect("cball_bounce", data1)

		if IsValid(tr.Entity) then
			local data2 = EffectData()
			data2:SetOrigin(tr.Entity:GetPos())
			util.Effect("HelicopterMegaBomb", data2)
		end
	end
end

local function is_valid(ent)
	if not isentity(ent) then return end
	if ent == NULL then return end
	return ent:IsValid()
end

function SWEP:Shoot(...)
	local owner, wep = self.Owner, self
	for _, laser in pairs {...} do
		local n, damage, spread, range = laser.Num or 1, laser.Damage, laser.Spread, laser.Range
		local green, expl = laser.Green, laser.Explosion
		for i = 1, n do
			local tr, fallout = self:Trace(range, spread, i)
			if not tr then continue end

			self:ShootEffects(tr, green, expl)

			if SERVER and is_valid(tr.Entity) then
				local dmg = DamageInfo()
				dmg:SetDamage(damage * fallout)
				dmg:SetDamageType(DMG_ENERGYBEAM)
				dmg:SetDamagePosition(tr.HitPos)
				dmg:SetAttacker(owner)
				dmg:SetInflictor(wep)

				tr.Entity:TakeDamageInfo(dmg)
			end
		end
	end
end

function SWEP:ShootPistol()
	local laser = {}

	laser.Num    = 1
	laser.Damage = 10
	laser.Spread = 0.05
	laser.Range  = 9000

	self:Shoot(laser)
	self:EmitSound(shoot_sound, loud, math.random(90, 110))
end

function SWEP:ShootBlitzer(charge)
	charge = math.min(charge - 0.5, 5)

	local ls1 = {}

	ls1.Num    = math.floor(math.max(charge * 0.5, 1))
	ls1.Damage = charge * 4
	ls1.Spread = 1
	ls1.Range  = 6000

	local ls2 = {}

	ls2.Green  = ls1.Num >= 2
	ls2.Num    = math.floor(math.max(charge * 4, 1))
	ls2.Damage = charge * 0.1
	ls2.Spread = 9
	ls2.Range  = 12000

	self:Shoot(ls1, ls2)
	self:EmitSound(shoot_sound, loud, math.random(90, 110), 1, CHAN_AUTO)
	self:EmitSound(rand_from_tbl(blitzer_sounds), loud, math.random(90, 110), charge * 0.15, CHAN_AUTO)
	self:EmitSound(blitzer_sound_extra, loud, math.random(90, 110), charge * 0.2, CHAN_AUTO)
end

function SWEP:ShootCannon(charge)
	charge = math.min(charge, 5)

	local ls1 = {}

	ls1.Green     = true
	ls1.Explosion = true
	ls1.Num       = 3
	ls1.Damage    = charge * 6
	ls1.Spread    = 0.5
	ls1.Range     = 1000 + charge * 200

	local ls2 = {}

	ls2.Green  = true
	ls2.Num    = 5 + charge * 5
	ls2.Damage = charge * 0.2
	ls2.Spread = 8
	ls2.Range  = 7000 + charge * 100

	local ls3

	if charge >= 3 then
		ls3 = {}
		ls3.Green  = true
		ls3.Num    = charge * 6
		ls3.Damage = charge
		ls3.Spread = 10
		ls3.Range  = 5000
	end

	self:Shoot(ls1, ls2, ls3)
	self:EmitSound(shoot_sound, ears, math.random(90, 110), 1, CHAN_AUTO)
	self:EmitSound(rand_from_tbl(cannon_sounds), ears, math.random(90, 110), charge * 0.2, CHAN_AUTO)
	self:EmitSound(rand_from_tbl(cannon_sounds), ears, math.random(70, 80), charge * 0.2, CHAN_AUTO)
	self:EmitSound(blitzer_sound_extra, ears, math.random(90, 110), math.min(charge * 0.4, 1), CHAN_AUTO)
end

function SWEP:PrimaryAttack()
	self:ShootPistol()
	self:SetNextPrimaryFire(CurTime() + 0.35)
end

function SWEP:SecondaryAttack()
	local charge = CurTime() - self:GetNW2Float("timer_blitzer")
	self:ShootBlitzer(charge)
	self:SetNW2Float("timer_blitzer", CurTime())
	self:SetNextSecondaryFire(CurTime() + 0.75)
end

function SWEP:ChargeCannon()
	local f = math.Clamp(CurTime() - self:GetNW2Float("Start"), 0, 5)

	if SERVER then
		if not self.ChargeSound:IsPlaying() then self.ChargeSound:Play() end
		self.ChargeSound:ChangePitch(50 + f * 16)
	end

	self.Owner:ViewPunch(AngleRand() * (0.0001 + f ^ 2 / 13000))
end

function SWEP:Think()
	if not IsFirstTimePredicted() then return end

	if self.Owner:KeyDown(IN_RELOAD) then
		self.Charging = true
		self:ChargeCannon()
	else
		if self.Charging then
			local f = math.Clamp(CurTime() - self:GetNW2Float("Start"), 0, 5)

			if f < 1 then
				self:EmitSound(cannon_fail_sound, ears)
			else
				self:ShootCannon(f)
			end

			self.Charging = nil

			if SERVER then
				self.ChargeSound:Stop()
			end
		end

		if SERVER then
			self:SetNW2Float("Start", CurTime())
		end
	end
end

function SWEP:OnRemove()
	if self.ChargeSound then self.ChargeSound:Stop() end
end

if CLIENT then
	----- PASTED CODE INCOMING !!!!!!!!!

	local cos, sin, abs, max, rad1, log, pow = math.cos, math.sin, math.abs, math.max, math.rad, math.log, math.pow

	local mat = CreateMaterial("amd", "UnlitGeneric", {
		["$nocull"] = "1",
	})
	local mat2 = CreateMaterial("amd2", "UnlitGeneric", {
		["$nocull"] = "1",
		["$alpha"] = "0.35"
	})	

	local function make_arc(cx, cy, radius, thickness, startang, endang, roughness)
		local triarc = {}

		local roughness = math.max(roughness or 1, 1)
		local step = roughness
		
		local startang, endang = startang or 0, endang or 0
		
		if startang > endang then
			step = math.abs(step) * -1
		end
		
		local inner = {}
		local r = radius - thickness
		for deg = startang, endang, step do
			local rad = math.rad(deg)
			local ox, oy = cx + (math.cos(rad) * r), cy + (-math.sin(rad) * r)
			inner[#inner + 1] = {
				x = ox,
				y = oy,
				u = (ox - cx) / radius + 0.5,
				v = (oy - cy) / radius + 0.5,
			}
		end

		local outer = {}
		for deg = startang, endang, step do
			local rad = math.rad(deg)
			local ox, oy = cx + (math.cos(rad) * radius), cy + (-math.sin(rad) * radius)
			outer[#outer + 1] = {
				x = ox,
				y = oy,
				u = (ox - cx) / radius + 0.5,
				v = (oy - cy) / radius + 0.5,
			}
		end

		for tri = 1, #inner * 2 do
			local p1, p2, p3
			p1 = outer[math.floor(tri / 2) + 1]
			p3 = inner[math.floor((tri + 1) / 2) + 1]
			if tri % 2 == 0 then
				p2 = outer[math.floor((tri + 1) / 2)]
			else
				p2 = inner[math.floor((tri + 1) / 2)]
			end
		
			triarc[#triarc + 1] = {p1, p2, p3}
		end
		
		return triarc	
	end

	local function draw_arc(cx,cy,radius,thickness,startang,endang,roughness,color)
		surface.SetMaterial(color and mat2 or mat)
		local polys = make_arc(cx, cy, radius, thickness, startang, endang, roughness)
		for _, poly in pairs(polys) do
		    surface.DrawPoly(poly)
		end
	end

	function SWEP:DrawHUD()
        if self.Owner:InVehicle() and not self.Owner:GetAllowWeaponsInVehicle() then return end

		draw_arc(ScrW() / 2, ScrH() / 2, 24, 2, 0, 360, 1, true)
		if LocalPlayer():KeyDown(IN_RELOAD) then
			local f = math.Clamp(CurTime() - self:GetNW2Float("Start"), 0, 5) * 72
			draw_arc(ScrW() / 2, ScrH() / 2, 24, 2, 0, f, 1)
		end
	end
end
