// lua/autorun/random name.lua
// Discord GCA: https://discord.gg/gca
// Web GCA: https://g-ca.fr

local meta = FindMetaTable("Player")

if DarkRP and not BaseWars then return end


DarkRP = {}

if SERVER then
    function meta:addMoney(amount)
        self:GiveMoney(amount)
    end

    function meta:setDarkRPVar(var, value)
        if var == "money" then
            self:SetMoney(value)
        else
            print("[DarkRP TO BaseWars] "..var.." not config!")
        end
    end
end

function meta:getDarkRPVar(var)
    if var == "money" then
        return self:GetMoney()
    else
        print("[DarkRP TO BaseWars] "..var.." not config!")
    end
end

local function attachCurrency(str)
    local currency = "$"  -- Défaut : symbole dollar ($)

    if BaseWars.LANG and BaseWars.LANG.__LANGUAGELOOK and BASEWARS_CHOSEN_LANGUAGE then
        local chosenCurrency = BaseWars.LANG.__LANGUAGELOOK[BASEWARS_CHOSEN_LANGUAGE].CURRENCY
        
        if chosenCurrency == "£" or chosenCurrency == "€" or chosenCurrency == "₽" or chosenCurrency == "₩" then
            currency = chosenCurrency
        end
    end
    
    return str..currency
end


function DarkRP.formatMoney(n)
    if not n then return attachCurrency("0") end

    if n >= 1e14 then return attachCurrency(tostring(n)) end
    if n <= -1e14 then return "-" .. attachCurrency(tostring(math.abs(n))) end

    local negative = n < 0

    n = tostring(math.abs(n))
    local sep = sep or ","
    local dp = string.find(n, "%.") or #n + 1

    for i = dp - 4, 1, -3 do
        n = n:sub(1, i) .. sep .. n:sub(i + 1)
    end

    return (negative and "-" or "") .. attachCurrency(n)
end