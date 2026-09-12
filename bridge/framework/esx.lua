local isServer = IsDuplicityVersion()

local FW = {}
Bridge.Framework['esx'] = FW

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
    function FW.GetPlayerData()
        local esxObj = GetESX()
        if not esxObj then return {} end
        local pData = esxObj.GetPlayerData()
        if pData and pData.job then
            pData.job.isboss = (pData.job.grade_name == 'boss' or pData.job.isboss == true)
        end
        return pData
    end

    function FW.IsBoss(job)
        if not job then
            local esxObj = GetESX()
            local pData = esxObj and esxObj.GetPlayerData()
            job = pData and pData.job
        end
        return job and (job.grade_name == 'boss' or job.isboss == true)
    end

    function FW.OnPlayerLoaded(cb)
        RegisterNetEvent('esx:playerLoaded', function(xPlayer)
            if xPlayer and xPlayer.job then
                xPlayer.job.isboss = (xPlayer.job.grade_name == 'boss' or xPlayer.job.isboss == true)
            end
            cb(xPlayer)
        end)
    end

    function FW.OnJobUpdate(cb)
        RegisterNetEvent('esx:setJob', function(job)
            if job then
                job.isboss = (job.grade_name == 'boss' or job.isboss == true)
            end
            cb(job)
        end)
    end
else
    function FW.GetPlayer(src)
        local esxObj = GetESX()
        if not esxObj then return nil end

        local xPlayer = esxObj.GetPlayerFromId(src)
        if not xPlayer then return nil end

        local job = xPlayer.getJob() or xPlayer.job
        local isBoss = job and (job.grade_name == 'boss' or job.isboss == true)
        local fullName = xPlayer.getName and xPlayer.getName() or (xPlayer.get('firstName') or "") .. " " .. (xPlayer.get('lastName') or "")

        return {
            source = src,
            citizenid = xPlayer.identifier,
            name = fullName ~= " " and fullName or ("Oyuncu " .. tostring(src)),
            job = job,
            isBoss = isBoss,
            getBank = function()
                local acc = xPlayer.getAccount('bank')
                return acc and acc.money or 0
            end,
            addBank = function(amount, reason)
                xPlayer.addAccountMoney('bank', amount, reason)
                return true
            end,
            removeBank = function(amount, reason)
                local current = xPlayer.getAccount('bank')
                if current and current.money >= amount then
                    xPlayer.removeAccountMoney('bank', amount, reason)
                    return true
                end
                return false
            end,
            setJob = function(jobName, gradeLevel)
                xPlayer.setJob(jobName, gradeLevel)
                return true
            end
        }
    end

    function FW.GetPlayerByCitizenId(citizenId)
        local esxObj = GetESX()
        if not esxObj then return nil end

        local xPlayer = esxObj.GetPlayerFromIdentifier(citizenId)
        if not xPlayer then return nil end
        return FW.GetPlayer(xPlayer.source)
    end

    function FW.GetJobGrades(jobName)
        local gradesArray = {}
        local esxObj = GetESX()
        local jobs = esxObj and esxObj.GetJobs and esxObj.GetJobs() or {}
        local jobInfo = jobs[jobName]
        if jobInfo and jobInfo.grades then
            for gradeLevel, gradeData in pairs(jobInfo.grades) do
                table.insert(gradesArray, {
                    level = tonumber(gradeData.grade or gradeLevel) or 0,
                    name = gradeData.label or gradeData.name or "Grade " .. tostring(gradeLevel)
                })
            end
            table.sort(gradesArray, function(a, b) return a.level < b.level end)
        else
            local result = MySQL.query.await('SELECT grade, label, name FROM job_grades WHERE job_name = ? ORDER BY grade ASC', {jobName})
            if result then
                for _, row in ipairs(result) do
                    table.insert(gradesArray, {
                        level = tonumber(row.grade) or 0,
                        name = row.label or row.name or "Grade " .. tostring(row.grade)
                    })
                end
            end
        end
        return gradesArray
    end

    function FW.GetEmployees(jobName, cb)
        MySQL.query('SELECT identifier, firstname, lastname, job_grade FROM users WHERE job = ?', {jobName}, function(result)
            local employees = {}
            local esxObj = GetESX()
            local jobs = esxObj and esxObj.GetJobs and esxObj.GetJobs() or {}
            local jobInfo = jobs[jobName]

            if result and #result > 0 then
                for _, v in ipairs(result) do
                    local gradeLevel = tostring(v.job_grade)
                    local gradeLabel = "Bilinmiyor"
                    
                    if jobInfo and jobInfo.grades and jobInfo.grades[gradeLevel] then
                        gradeLabel = jobInfo.grades[gradeLevel].label or jobInfo.grades[gradeLevel].name
                    else
                        gradeLabel = "Rütbe " .. gradeLevel
                    end

                    local fullName = ((v.firstname or "") .. " " .. (v.lastname or "")):gsub("^%s*(.-)%s*$", "%1")
                    if fullName == "" then fullName = "Oyuncu (" .. string.sub(v.identifier, 1, 8) .. ")" end

                    table.insert(employees, {
                        name = fullName,
                        citizenid = v.identifier,
                        gradeLabel = gradeLabel
                    })
                end
            end
            cb(employees)
        end)
    end

    function FW.FireEmployee(citizenId, cb)
        local target = FW.GetPlayerByCitizenId(citizenId)

        if target then
            target.setJob("unemployed", 0)
            MySQL.update('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {
                "unemployed", 0, citizenId
            }, function()
                cb(true, true)
            end)
        else
            MySQL.update('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {
                "unemployed", 0, citizenId
            }, function(affected)
                cb(affected and affected > 0, false)
            end)
        end
    end

    function FW.SetGrade(citizenId, gradeLevel, jobName, cb)
        local target = FW.GetPlayerByCitizenId(citizenId)
        local grade = tonumber(gradeLevel) or 0

        if target then
            local success = target.setJob(jobName or target.job.name, grade)
            cb(success, true)
        else
            MySQL.update('UPDATE users SET job_grade = ? WHERE identifier = ?', {
                grade,
                citizenId
            }, function(affected)
                cb(affected and affected > 0, false)
            end)
        end
    end
end
