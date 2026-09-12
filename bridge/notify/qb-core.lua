local isServer = IsDuplicityVersion()

local NotifyModule = {}
Bridge.Notify['qb-core'] = NotifyModule

local QBCore = nil
local function GetQBCore()
    if QBCore then return QBCore end
    if GetResourceState('qb-core') == 'started' then
        local ok, obj = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if ok and obj then QBCore = obj end
    end
    return QBCore
end

if not isServer then
    function NotifyModule.Send(message, notifyType)
        local qb = GetQBCore()
        local nType = notifyType or 'primary'
        if nType == 'info' then nType = 'primary' end
        if qb and qb.Functions and qb.Functions.Notify then
            qb.Functions.Notify(message, nType)
        else
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName(message)
            EndTextCommandThefeedPostTicker(false, true)
        end
    end
else
    function NotifyModule.Send(src, message, notifyType)
        local nType = notifyType or 'primary'
        if nType == 'info' then nType = 'primary' end
        TriggerClientEvent('QBCore:Notify', src, message, nType)
    end
end
