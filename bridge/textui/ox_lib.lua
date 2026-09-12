if IsDuplicityVersion() then return end

Bridge.TextUI['ox_lib'] = {
    Show = function(text)
        lib.showTextUI(text, {
            position = "right-center"
        })
    end,
    Hide = function()
        lib.hideTextUI()
    end,
    Is3D = false
}
