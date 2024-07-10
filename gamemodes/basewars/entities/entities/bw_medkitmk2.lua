AddCSLuaFile()

ENT.Base = "base_anim"

ENT.PrintName = "Medkit MK2"
ENT.Author = "Frumorn"
ENT.Information = "A medkit when used, gives 75 health after 7 seconds"
ENT.Category = "BaseWars"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/Items/battery.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
		self:Activate()
		self:SetUseType(SIMPLE_USE)
	end
	
	function ENT:Use(act)
    	if not act:IsPlayer() then return end
    	if act._MedkitCooldown then return act:ChatPrint(string.format(BaseWars.LANG.OnItemCoolDown, self.PrintName)) end 
    	
    	local maxhealth = act:GetMaxHealth()
    
    	if act:Health() < maxhealth then
    	    act._MedkitCooldown = true
    	    
    		self:EmitSound("items/battery_pickup.wav")
    		self:Remove()
    
    		timer.Simple(1, function()
    			if IsValid(act) and act:Alive() then
    				act:EmitSound("HL1/fvox/medical_repaired.wav")
    			end
    		end)

			timer.Simple(5, function()
				if IsValid(act) and act:Alive() then
					act:EmitSound("HL1/fvox/morphine_shot.wav")
				end
			end)
    
    		timer.Simple(7, function()
    			if IsValid(act) then
    				if not act:Alive() then act._MedkitCooldown = nil return end
    				act:SetHealth(math.Clamp(act:Health() + 75, 0, maxhealth))
    				act:EmitSound("items/suitchargeok1.wav")
    				act._MedkitCooldown = nil
    			end
    		end)
        end
    end

else
    function ENT:Draw()
    	self:DrawModel()
    end
end