hook.Add("EntityTakeDamage", "XP_OnKill", function(cible, infosDommage)
    if not cible:IsPlayer() and not cible:IsNPC() then return end
    local attaquant = infosDommage:GetAttacker()
    
    if IsValid(attaquant) and attaquant:IsPlayer() then
        local XP = attaquant:GetXP()
        local XPProchainNiveau = attaquant:GetXPNextLevel()
        local XPToAdd = 0
        
        if cible:IsPlayer() and cible:Health() - infosDommage:GetDamage() <= 0 then
            XPToAdd = 100
            -- Write the message "+100 XP Player killed" or "+200 XP Player killed" on the player's screen when they kill another player.
            local message = "+100 XP Player killed"
            -- Add the user group that gives access to the XP multiplier, for example if the player is a VIP, he will earn x2 XP if he kills a player.
            if attaquant:IsUserGroup("VIP") or attaquant:IsUserGroup("Mod") or attaquant:IsUserGroup("Mods") or attaquant:IsUserGroup("admin") or attaquant:IsUserGroup("superadmin") then
                XPToAdd = XPToAdd * 2 -- Multiply XP by two - you can increase or decrease this value
                message = "+200 XP Player killed"
            end
            net.Start("XP_Notification")
            net.WriteString(message)
            net.Send(attaquant)
        elseif cible:IsNPC() and cible:Health() - infosDommage:GetDamage() <= 0 then
            XPToAdd = 50
            -- Write the message "+100 XP Player killed" or "+200 XP Player killed" on the player's screen when they kill an NPC.
            local message = "+50 XP NPC killed"
            -- Add the user group that gives access to the XP multiplier, for example if the player is a VIP, he will earn x2 XP if he kills a NPC.
            if attaquant:IsUserGroup("VIP") or attaquant:IsUserGroup("Ancien") or attaquant:IsUserGroup("Moderateur") or attaquant:IsUserGroup("admin") or attaquant:IsUserGroup("superadmin") then
                XPToAdd = XPToAdd * 2 -- Multiply XP by two - you can increase or decrease this value
                message = "+100 XP NPC killed"
            end
            net.Start("XP_Notification")
            net.WriteString(message)
            net.Send(attaquant)
        end
        
        attaquant:SetXP(math.min(XP + XPToAdd, XPProchainNiveau))
    end
end)

util.AddNetworkString("XP_Notification")