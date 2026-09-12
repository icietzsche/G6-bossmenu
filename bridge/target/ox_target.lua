if IsDuplicityVersion() then return end

local zones = {}

Bridge.Target['ox_target'] = {
    AddBossZone = function(index, coords, job, label, onSelect)
        local zoneId = exports.ox_target:addSphereZone({
            coords = coords,
            radius = 1.5,
            debug = Config and Config.Debug or false,
            options = {
                {
                    name = 'g6_bossmenu_' .. tostring(index),
                    icon = 'fa-solid fa-briefcase',
                    label = label or _U('target_label'),
                    groups = job,
                    onSelect = function()
                        if onSelect then onSelect() end
                    end,
                    canInteract = function(entity, distance, coords, name)
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
            }
        })
        zones[index] = zoneId
    end,

    RemoveBossZone = function(index)
        if zones[index] then
            exports.ox_target:removeZone(zones[index])
            zones[index] = nil
        end
    end
}
