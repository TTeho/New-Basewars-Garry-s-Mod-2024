net.Receive("XP_Notification", function()
    local message = net.ReadString()
    local fadeTime = 1 -- Durée du fondu, en secondes
    
    -- Fonction pour dessiner le texte avec un fondu d'apparition et de disparition
    local function DrawNotificationText()
        local curTime = CurTime()
        local alpha
        
        -- Calculer l'opacité pour le fondu d'apparition
        if curTime < fadeTime then
            alpha = math.Clamp((curTime / fadeTime) * 255, 0, 255)
        end
        
        -- Calculer l'opacité pour le fondu de disparition
        if curTime > fadeTime and curTime < fadeTime * 2 then
            alpha = math.Clamp(((fadeTime * 2 - curTime) / fadeTime) * 255, 0, 255)
        end
        
        surface.SetFont("DermaDefaultBold")
        local textWidth, textHeight = surface.GetTextSize(message)
        
        local x = (ScrW() - textWidth) / 2
        local y = ScrH() / 2
        
        -- Dessiner le texte au milieu de l'écran avec le fondu approprié
        draw.SimpleText(message, "DermaDefaultBold", x, y, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    
    -- Ajouter le dessin du texte à la fonction de rendu
    hook.Add("HUDPaint", "DrawNotificationText", DrawNotificationText)
    
    -- Supprimer le dessin du texte après la durée du fondu
    timer.Simple(fadeTime * 2, function()
        hook.Remove("HUDPaint", "DrawNotificationText")
    end)
end)