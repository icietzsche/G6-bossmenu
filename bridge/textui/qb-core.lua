if IsDuplicityVersion() then return end

Bridge.TextUI['qb-core'] = {
    Show = function(text)
        exports['qb-core']:DrawText(text, 'left')
    end,
    Hide = function()
        exports['qb-core']:HideText()
    end,
    Is3D = false
}
