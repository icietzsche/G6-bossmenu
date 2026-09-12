local isServer = IsDuplicityVersion()

local NotifyModule = {}
Bridge.Notify['ox_lib'] = NotifyModule

if not isServer then
    function NotifyModule.Send(message, notifyType)
        local nType = notifyType or 'info'
        if nType == 'primary' then nType = 'info' end
        lib.notify({
            title = 'G6 Boss Menu',
            description = message,
            type = nType
        })
    end
else
    function NotifyModule.Send(src, message, notifyType)
        local nType = notifyType or 'info'
        if nType == 'primary' then nType = 'info' end
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'G6 Boss Menu',
            description = message,
            type = nType
        })
    end
end
