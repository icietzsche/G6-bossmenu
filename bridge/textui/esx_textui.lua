if IsDuplicityVersion() then return end

Bridge.TextUI['esx_textui'] = {
    Show = function(text)
        if ESX and ESX.TextUI then
            ESX.TextUI(text)
        elseif exports['esx_textui'] then
            exports['esx_textui']:TextUI(text)
        end
    end,
    Hide = function()
        if ESX and ESX.HideUI then
            ESX.HideUI()
        elseif exports['esx_textui'] then
            exports['esx_textui']:HideUI()
        end
    end,
    Is3D = false
}
