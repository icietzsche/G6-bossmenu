local isServer = IsDuplicityVersion()

local NotifyModule = {}
Bridge.Notify['esx'] = NotifyModule

local ESX = nil
local function GetESX()
    if ESX then return ESX end
    if GetResourceState('es_extended') == 'started' then
        local ok, obj = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)
        if ok and obj then ESX = obj end
    end
    return ESX
end

if not isServer then
    function NotifyModule.Send(message, notifyType)
        local esxObj = GetESX()
        local nType = notifyType or 'info'
        if nType == 'primary' then nType = 'info' end
        if esxObj and esxObj.ShowNotification then
            esxObj.ShowNotification(message, nType)
        else
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName(message)
            EndTextCommandThefeedPostTicker(false, true)
        end
    end
else
    function NotifyModule.Send(src, message, notifyType)
        local nType = notifyType or 'info'
        if nType == 'primary' then nType = 'info' end
        TriggerClientEvent('esx:showNotification', src, message, nType)
    end
end
