-----------------------------------------------------------------------------------------------------------------------------------------
-- HASPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Core.HasPermission(Permission)
    local Passport = vRPS.Passport(source)

    if Passport then
        return vRPS.HasGroup(Passport, Permission)
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Core.Request(Message)
    return vRPS.Request(source, "Rotas", Message)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Core.Payment(Name, Vehicle)
    local Source = source
    local Passport = vRPS.Passport(Source)

    if Passport then
        local Collected = false

        for Item, Amount in pairs(Farm[Name]["Give"]) do
            local Generate = math.random(Amount[1], Amount[2])

            if vRPS.HasGroup(Passport, Buff) then
                Generate += Increase
            end

            if not vRPS.CheckWeight(Passport, Item, Generate) then
                TriggerClientEvent("Notify",Source,"Mochila Sobrecarregada",ItemName(Item).." caiu no chão.","amarelo",5000)
                break
            end

            if not Vehicle or Vehicle == 0 then
                vRPC.playAnim(Source, false, { "pickup_object", "pickup_low" }, false)
            end

            vRPS.GiveItem(Passport, Item, Generate, true)
            Collected = true
        end

        return Collected
    end
end