-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Route = false
Name = false
Blip = false
Current = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Farm","farm","keyboard","E")
RegisterCommand("Farm",function(source,args,rawCommand)
	local Ped = PlayerPedId()

	if not IsPedInAnyVehicle(Ped) then
		local Coords = GetEntityCoords(Ped)

		for Name, Config in pairs(Farm) do
            local Distance = #(Coords - Config["Start"])

            if Distance <= 2.5 and Server.HasPermission(Config["Permission"]) then
                exports["dynamic"]:SubMenu("Farm","Escolha a rota.","farm")

                for Index, Zone in pairs(Config["Zones"]) do
                    local Label = (Zone == "South") and "Sul" or "Norte"
                    local Description = "Iniciar a rota no "..Label:lower()

                    exports["dynamic"]:AddButton(Label, Description, "Farm:Start", Name.."-"..Zone, "farm", false)
                end

                exports["dynamic"]:openMenu()
                break
            end
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARM:START
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Farm:Start", function(Data)
    if Route then return end

    Data = splitString(Data, "-")

    if Server.HasPermission(Farm[Data[1]]["Permission"]) then
        Name = Data[1]

        local Zone = Data[2]
        Route = (Routes[Name] and Routes[Name][Zone]) and Routes[Name][Zone] or Routes["Default"][Zone]

        if not Route or #Route == 0 then
            return TriggerEvent("Notify","Rota Indisponível", "Não há rotas disponíveis nessa zona.","amarelo",5000)
        end

        Current = math.random(1, #Route)
        CreateBlip(Route[Current])

        CreateThread(RouteThread)
        CreateThread(AnchorThread)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUTE THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
function RouteThread()
    local UseVehicle = Farm[Name]["UseVehicle"] or false

    while Route do
        local TimeDistance = 999
        
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        local Distance = #(Route[Current] - Coords)
        local Vehicle = GetVehiclePedIsIn(Ped)

        if Distance <= 20 then 
            TimeDistance = 1

            DrawMarker(0, Route[Current]["xy"], Route[Current]["z"] - 0.5, 0, 0, 0, 0, 0, 0, Markers["Scale"], Markers["Scale"], Markers["Scale"], Markers["Color"][1], Markers["Color"][2], Markers["Color"][3], Markers["Color"][4], 1, 1, 1, 1)
        
            if Distance <= 1.5 then
                DrawText3D(Route[Current]["x"],Route[Current]["y"],Route[Current]["z"], "[~g~H~w~] COLETAR")

                if IsControlJustPressed(1, 101) and ((not Vehicle or Vehicle == 0) or Vehicle and UseVehicle) then
                    if Server.Payment(Name, Vehicle) then
                        Current = (Route[Current + 1]) and Current + 1 or 1
                        CreateBlip(Route[Current])
                    end
                end 
            end
        end

        Wait(TimeDistance)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANCHOR THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
function AnchorThread()
    local Minimap = GetMinimapAnchor()

    while Route do
        DrawText2D(Minimap.right_x + 0.050, Minimap.bottom_y - 0.076, 0.35, "PRESSIONE ~r~F7 ~w~PARA CANCELAR A ROTA", 255, 255, 255, 150)

        if IsControlJustPressed(1, 168) then
            RemoveBlip(Blip)

            Route = false
            Name = false
            Blip = false
            Current = false
        end

        Wait(5)
    end
end