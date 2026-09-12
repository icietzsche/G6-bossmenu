local actionCooldowns = {}

local function GetFramework()
    return Bridge.GetFramework()
end

local function GetBanking()
    return Bridge.GetBanking()
end

local function Notify(src, message, notifyType)
    local notify = Bridge.GetNotify()
    if notify then
        notify.Send(src, message, notifyType)
    end
end

local function DebugLog(...)
    if Config and Config.Debug then
        print('^3[G6-bossmenu DEBUG]^7', ...)
    end
end

local function SendDiscordWebhook(title, description, color)
    if not Config or not Config.WebhookURL or Config.WebhookURL == "" then return end

    local embed = {
        {
            ["title"] = title,
            ["description"] = description,
            ["type"] = "rich",
            ["color"] = color or 3447003,
            ["footer"] = {
                ["text"] = "G6 Studio • Boss Menu Logs"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({
        username = "G6 Boss Menu",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

local function CheckCooldown(src)
    local now = GetGameTimer()
    if actionCooldowns[src] and (now - actionCooldowns[src]) < 1000 then
        return false
    end
    actionCooldowns[src] = now
    return true
end

RegisterNetEvent('g6-bossmenu:server:requestData', function(jobName)
    local src = source
    local fw = GetFramework()
    local player = fw.GetPlayer(src)

    if not player or player.job.name ~= jobName then return end

    if Config.CheckBoss and not player.isBoss then
        Notify(src, _U('not_boss'), 'error')
        return
    end

    local gradesArray = fw.GetJobGrades(jobName)
    local nearbyPlayers = {}
    local srcPed = GetPlayerPed(src)
    local srcCoords = GetEntityCoords(srcPed)

    for _, pSrcStr in ipairs(GetPlayers()) do
        local pSrc = tonumber(pSrcStr)
        if pSrc and pSrc ~= src then
            local targetPed = GetPlayerPed(pSrc)
            local targetCoords = GetEntityCoords(targetPed)
            
            if #(srcCoords - targetCoords) <= 10.0 then
                local targetPlayer = fw.GetPlayer(pSrc)
                if targetPlayer then
                    table.insert(nearbyPlayers, {
                        name = targetPlayer.name,
                        playerId = pSrc
                    })
                end
            end
        end
    end

    local banking = GetBanking()
    local balance = banking.GetAccountBalance(jobName)

    fw.GetEmployees(jobName, function(employees)
        TriggerClientEvent('g6-bossmenu:client:receiveData', src, employees, balance, nearbyPlayers, gradesArray)
    end)
end)

RegisterNetEvent('g6-bossmenu:server:hirePlayer', function(playerId, grade, jobName)
    local src = source
    if not CheckCooldown(src) then return end

    local fw = GetFramework()
    local bossPlayer = fw.GetPlayer(src)
    if not bossPlayer or bossPlayer.job.name ~= jobName then return end

    if Config.CheckBoss and not bossPlayer.isBoss then
        Notify(src, _U('unauthorized'), 'error')
        return
    end

    local targetId = tonumber(playerId)
    if not targetId or targetId == src then
        Notify(src, _U('cannot_target_self'), 'error')
        return
    end

    local targetPlayer = fw.GetPlayer(targetId)
    if not targetPlayer then
        Notify(src, _U('player_not_found'), 'error')
        return
    end

    local bossPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetId)
    local distance = #(GetEntityCoords(bossPed) - GetEntityCoords(targetPed))

    if distance > (Config.HireDistance or 5.0) then
        Notify(src, _U('player_too_far'), 'error')
        return
    end

    local gradeLevel = tonumber(grade) or 0
    if targetPlayer.setJob(jobName, gradeLevel) then
        Notify(src, _U('hire_success', targetPlayer.name), 'success')
        Notify(targetId, _U('hired_notification'), 'success')
        TriggerClientEvent('g6-bossmenu:client:refresh', src)

        DebugLog(string.format("Player %s (%s) hired %s (%s) to %s (Grade %s)", bossPlayer.name, src, targetPlayer.name, targetId, jobName, gradeLevel))
        SendDiscordWebhook(_U('webhook_hire'), _U('webhook_desc_hire', bossPlayer.name, bossPlayer.citizenid, targetPlayer.name, targetPlayer.citizenid, jobName, gradeLevel), 3066993)
    end
end)

RegisterNetEvent('g6-bossmenu:server:fireEmployee', function(citizenId)
    local src = source
    if not CheckCooldown(src) then return end

    local fw = GetFramework()
    local bossPlayer = fw.GetPlayer(src)
    if not bossPlayer then return end

    if Config.CheckBoss and not bossPlayer.isBoss then
        Notify(src, _U('unauthorized'), 'error')
        return
    end

    if bossPlayer.citizenid == citizenId then
        Notify(src, _U('cannot_target_self'), 'error')
        return
    end

    local jobName = bossPlayer.job.name

    fw.FireEmployee(citizenId, function(success, isOnline)
        if success then
            if isOnline then
                local target = fw.GetPlayerByCitizenId(citizenId)
                if target then
                    Notify(target.source, _U('fired_notification'), 'error')
                end
                Notify(src, _U('employee_fired'), 'success')
            else
                Notify(src, _U('offline_employee_fired'), 'primary')
            end
            TriggerClientEvent('g6-bossmenu:client:refresh', src)

            DebugLog(string.format("Player %s (%s) fired employee %s from %s", bossPlayer.name, src, citizenId, jobName))
            SendDiscordWebhook(_U('webhook_fire'), _U('webhook_desc_fire', bossPlayer.name, bossPlayer.citizenid, citizenId, jobName), 15158332)
        end
    end)
end)

RegisterNetEvent('g6-bossmenu:server:setGrade', function(citizenId, grade)
    local src = source
    if not CheckCooldown(src) then return end

    local fw = GetFramework()
    local bossPlayer = fw.GetPlayer(src)
    if not bossPlayer then return end

    if Config.CheckBoss and not bossPlayer.isBoss then
        Notify(src, _U('unauthorized'), 'error')
        return
    end

    if bossPlayer.citizenid == citizenId then
        Notify(src, _U('cannot_target_self'), 'error')
        return
    end

    local jobName = bossPlayer.job.name
    local gradeLevel = tonumber(grade) or 0

    fw.SetGrade(citizenId, gradeLevel, jobName, function(success, isOnline)
        if success then
            if isOnline then
                Notify(src, _U('grade_updated'), 'success')
            else
                Notify(src, _U('offline_grade_updated'), 'primary')
            end
            TriggerClientEvent('g6-bossmenu:client:refresh', src)

            DebugLog(string.format("Player %s (%s) updated employee %s grade to %s in %s", bossPlayer.name, src, citizenId, gradeLevel, jobName))
            SendDiscordWebhook(_U('webhook_grade'), _U('webhook_desc_grade', bossPlayer.name, bossPlayer.citizenid, citizenId, jobName, gradeLevel), 3447003)
        end
    end)
end)

RegisterNetEvent('g6-bossmenu:server:depositMoney', function(amount)
    local src = source
    if not CheckCooldown(src) then return end

    local fw = GetFramework()
    local player = fw.GetPlayer(src)
    if not player then return end

    if Config.CheckBoss and not player.isBoss then
        Notify(src, _U('unauthorized'), 'error')
        return
    end

    local depositAmt = math.floor(tonumber(amount) or 0)
    if depositAmt <= 0 then
        Notify(src, _U('invalid_amount'), 'error')
        return
    end

    local jobName = player.job.name
    local playerBank = player.getBank()

    if playerBank < depositAmt then
        Notify(src, _U('not_enough_money'), 'error')
        return
    end

    if player.removeBank(depositAmt, "Boss Deposit: " .. jobName) then
        local banking = GetBanking()
        local success = banking.AddMoney(jobName, depositAmt, "Boss Deposit by " .. player.name)

        if success then
            Notify(src, _U('deposit_success', depositAmt), 'success')
            TriggerClientEvent('g6-bossmenu:client:refresh', src)

            DebugLog(string.format("Player %s (%s) deposited $%s to %s", player.name, src, depositAmt, jobName))
            SendDiscordWebhook(_U('webhook_deposit'), _U('webhook_desc_deposit', player.name, player.citizenid, jobName, depositAmt), 15844367)
        else
            player.addBank(depositAmt, "Refund Boss Deposit")
            Notify(src, _U('bank_error'), 'error')
        end
    else
        Notify(src, _U('not_enough_money'), 'error')
    end
end)

RegisterNetEvent('g6-bossmenu:server:withdrawMoney', function(amount)
    local src = source
    if not CheckCooldown(src) then return end

    local fw = GetFramework()
    local player = fw.GetPlayer(src)
    if not player then return end

    if Config.CheckBoss and not player.isBoss then
        Notify(src, _U('unauthorized'), 'error')
        return
    end

    local withdrawAmt = math.floor(tonumber(amount) or 0)
    if withdrawAmt <= 0 then
        Notify(src, _U('invalid_amount'), 'error')
        return
    end

    local jobName = player.job.name
    local banking = GetBanking()
    local societyBalance = banking.GetAccountBalance(jobName)

    if societyBalance < withdrawAmt then
        Notify(src, _U('not_enough_society_money'), 'error')
        return
    end

    local success = banking.RemoveMoney(jobName, withdrawAmt, "Boss Withdraw by " .. player.name)
    if success then
        player.addBank(withdrawAmt, "Boss Withdraw: " .. jobName)
        Notify(src, _U('withdraw_success', withdrawAmt), 'success')
        TriggerClientEvent('g6-bossmenu:client:refresh', src)

        DebugLog(string.format("Player %s (%s) withdrew $%s from %s", player.name, src, withdrawAmt, jobName))
        SendDiscordWebhook(_U('webhook_withdraw'), _U('webhook_desc_withdraw', player.name, player.citizenid, jobName, withdrawAmt), 10181046)
    else
        Notify(src, _U('bank_error'), 'error')
    end
end)