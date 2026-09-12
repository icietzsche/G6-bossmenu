if IsDuplicityVersion() then return end

local zones = {}

Bridge.Target['qb-target'] = {
    AddBossZone = function(index, coords, job, label, onSelect)
        local zoneName = 'g6_bossmenu_' .. tostring(index)
        exports['qb-target']:AddCircleZone(zoneName, coords, 1.5, {
            name = zoneName,
            debugPoly = Config and Config.Debug or false,
            useZ = true,
        }, {
            options = {
                {
                    num = 1,
                    icon = 'fas fa-briefcase',
                    label = label or _U('target_label'),
                    job = job,
                    action = function()
                        if onSelect then onSelect() end
                    end,
                    canInteract = function()
                        local fw = Bridge.GetFramework()
                        local pData = fw and fw.GetPlayerData()
                        if not pData or not pData.job then return false end
                        if pData.job.name ~= job then return false end
                        if Config and Config.CheckBoss and not fw.IsBoss(pData.job) then
                            return false
                        end
                        return true
                    end
                }
            },
            distance = 2.0
        })
        zones[index] = zoneName
    end,

    RemoveBossZone = function(index)
        if zones[index] then
            exports['qb-target']:RemoveZone(zones[index])
            zones[index] = nil
        end
    end
}
