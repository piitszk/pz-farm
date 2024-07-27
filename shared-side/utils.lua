
if not IsDuplicityVersion() then
    function DrawText2D(X, Y, Scale, Text, R, G, B, A)
        SetTextFont(4)
        SetTextScale(Scale,Scale)
        SetTextColour(R, G, B, A)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(Text)
        DrawText(X,Y)
    end
    
    function DrawText3D(X, Y, Z, Text)
        local Visible, DisplayX, DisplayY = GetScreenCoordFromWorldCoord(X, Y, Z)
    
        if Visible then
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringKeyboardDisplay(Text)
            SetTextColour(255,255,255,150)
            SetTextScale(0.35,0.35)
            SetTextFont(4)
            SetTextCentre(1)
            EndTextCommandDisplayText(DisplayX, DisplayY)
        end
    end

    function CreateBlip(Coords)
        if DoesBlipExist(Blip) then
            RemoveBlip(Blip)
        end

        Blip = AddBlipForCoord(Coords[1], Coords[2], Coords[3])
        SetBlipSprite(Blip,Blips["Sprite"])
        SetBlipColour(Blip,Blips["Color"])
        SetBlipScale(Blip,Blips["Scale"])
        SetBlipAsShortRange(Blip,false)
        SetBlipRoute(Blip,true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Blips["Name"])
        EndTextCommandSetBlipName(Blip)
    end

    function GetMinimapAnchor()
        local safezone = GetSafeZoneSize()
        local safezone_x = 1.0 / 20.0
        local safezone_y = 1.0 / 20.0

        local aspect_ratio = GetAspectRatio(0)
        local res_x, res_y = GetActiveScreenResolution()

        local xscale = 1.0 / res_x
        local yscale = 1.0 / res_y
        
        local Minimap = {}

        Minimap.width = xscale * (res_x / (4 * aspect_ratio))
        Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
        Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
        Minimap.right_x = Minimap.left_x + Minimap.width
        
        return Minimap
    end
end