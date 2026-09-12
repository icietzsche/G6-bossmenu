if IsDuplicityVersion() then return end

local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 20, 20, 20, 150)
    end
end

Bridge.TextUI['drawtext3d'] = {
    Show = function(text, coords)
        if coords then
            DrawText3D(coords.x, coords.y, coords.z + 0.3, text)
        end
    end,
    Hide = function()
    end,
    Is3D = true
}
