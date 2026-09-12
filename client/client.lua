local isOpen = false
local isTextUIShowing = false
local PlayerData = {}
local targetZonesCreated = false

local function GetFramework()
    return Bridge.GetFramework()
end

local function Notify(message, notifyType)
    local notify = Bridge.GetNotify()
    if notify then
        notify.Send(message, notifyType)
    end
end

local function OpenBossMenu()
    if isOpen then return end
    
    local fw = GetFramework()
    if not PlayerData or not PlayerData.job then
        PlayerData = fw.GetPlayerData()
    end

    if not PlayerData or not PlayerData.job then return end

    if Config.CheckBoss and not fw.IsBoss(PlayerData.job) then
        Notify(_U('not_boss'), 'error')
        return
    end

    local jobName = PlayerData.job.name
    local jobLabel = PlayerData.job.label or jobName

    isOpen = true
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        action = "open",
        jobLabel = jobLabel,
        currency = Config.Currency or "$"
    })
    
    TriggerServerEvent('g6-bossmenu:server:requestData', jobName)
end

local function SetupTargetZones()
    if targetZonesCreated then return end
    local target = Bridge.GetTarget()
    if not target then return end

    for index, location in ipairs(Config.BossMenuLocations) do
        target.AddBossZone(index, location.coords, location.job, location.label, function()
            OpenBossMenu()
        end)
    end
    targetZonesCreated = true
end

local function CleanupTargetZones()
    if not targetZonesCreated then return end
    local target = Bridge.GetTarget()
    if not target then return end

    for index, _ in ipairs(Config.BossMenuLocations) do
        target.RemoveBossZone(index)
    end
    targetZonesCreated = false
end

CreateThread(function()
    while true do
        local fw = GetFramework()
        if fw and fw.GetPlayerData then
            PlayerData = fw.GetPlayerData()
            if PlayerData and PlayerData.job then
                break
            end
        end
        Wait(500)
    end

    if Config.InteractionType == 'target' then
        SetupTargetZones()
    end
end)

local fw = GetFramework()
if fw then
    fw.OnPlayerLoaded(function(data)
        PlayerData = data
        if Config.InteractionType == 'target' then
            SetupTargetZones()
        end
    end)

    fw.OnJobUpdate(function(job)
        PlayerData.job = job
        if Config.InteractionType == 'target' then
            SetupTargetZones()
        end
    end)
end

if Config.OpenCommand and Config.OpenCommand ~= "" then
    RegisterCommand(Config.OpenCommand, function()
        OpenBossMenu()
    end, false)
end

RegisterNetEvent('g6-bossmenu:client:openMenu', function()
    OpenBossMenu()
end)

RegisterNetEvent('g6-bossmenu:client:refresh', function()
    if isOpen and PlayerData and PlayerData.job then
        TriggerServerEvent('g6-bossmenu:server:requestData', PlayerData.job.name)
    end
end)

RegisterNetEvent('g6-bossmenu:client:receiveData', function(employees, balance, nearbyPlayers, grades)
    if not isOpen then return end
    SendNUIMessage({
        action = "updateData",
        employees = employees or {},
        balance = balance or 0,
        nearbyPlayers = nearbyPlayers or {},
        grades = grades or {}
    })
end)

RegisterNUICallback('close', function(_, cb)
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "close"
    })
    cb('ok')
end)

RegisterNUICallback('hirePlayer', function(data, cb)
    if not PlayerData or not PlayerData.job then return cb('error') end
    TriggerServerEvent('g6-bossmenu:server:hirePlayer', data.playerId, data.grade, PlayerData.job.name)
    cb('ok')
end)

RegisterNUICallback('fireEmployee', function(data, cb)
    TriggerServerEvent('g6-bossmenu:server:fireEmployee', data.citizenId)
    cb('ok')
end)

RegisterNUICallback('setGrade', function(data, cb)
    TriggerServerEvent('g6-bossmenu:server:setGrade', data.citizenId, data.grade)
    cb('ok')
end)

RegisterNUICallback('depositMoney', function(data, cb)
    local amount = math.floor(tonumber(data.amount) or 0)
    if amount > 0 then
        TriggerServerEvent('g6-bossmenu:server:depositMoney', amount)
    else
        Notify(_U('invalid_amount'), 'error')
    end
    cb('ok')
end)

RegisterNUICallback('withdrawMoney', function(data, cb)
    local amount = math.floor(tonumber(data.amount) or 0)
    if amount > 0 then
        TriggerServerEvent('g6-bossmenu:server:withdrawMoney', amount)
    else
        Notify(_U('invalid_amount'), 'error')
    end
    cb('ok')
end)

CreateThread(function()
    if Config.InteractionType == 'target' then return end

    local textUI = Bridge.GetTextUI()

    while true do
        local sleep = 1500
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local inRange = false

        if PlayerData and PlayerData.job then
            local isBoss = not Config.CheckBoss or GetFramework().IsBoss(PlayerData.job)
            
            if isBoss then
                for _, location in ipairs(Config.BossMenuLocations) do
                    if PlayerData.job.name == location.job then
                        local distance = #(coords - location.coords)

                        if distance < 10.0 then
                            sleep = 0
                            DrawMarker(21, location.coords.x, location.coords.y, location.coords.z - 0.2, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0.3, 0.3, 50, 150, 255, 150, false, true, 2, false, nil, nil, false)

                            if distance < 1.5 then
                                inRange = true

                                if not isTextUIShowing then
                                    if textUI and not textUI.Is3D then
                                        textUI.Show(_U('interact_text'))
                                    end
                                    isTextUIShowing = true
                                end

                                if textUI and textUI.Is3D then
                                    textUI.Show(_U('interact_text'), location.coords)
                                end

                                if IsControlJustReleased(0, 38) then
                                    OpenBossMenu()
                                end
                            end
                        end
                    end
                end
            end
        end

        if not inRange and isTextUIShowing then
            if textUI and not textUI.Is3D then
                textUI.Hide()
            end
            isTextUIShowing = false
        end

        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if isOpen then
        SetNuiFocus(false, false)
    end
    if isTextUIShowing then
        local textUI = Bridge.GetTextUI()
        if textUI and not textUI.Is3D then
            textUI.Hide()
        end
    end
    CleanupTargetZones()
end)