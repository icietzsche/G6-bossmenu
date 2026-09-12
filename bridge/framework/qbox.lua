local isServer = IsDuplicityVersion()

local FW = {}
Bridge.Framework['qbox'] = FW

if not isServer then
    function FW.GetPlayerData()
        return exports.qbx_core:GetPlayerData()
    end

    function FW.IsBoss(job)
        if not job then
            local pData = exports.qbx_core:GetPlayerData()
            job = pData and pData.job
        end
        return job and job.isboss == true
    end

    function FW.OnPlayerLoaded(cb)
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
            cb(exports.qbx_core:GetPlayerData())
        end)
        RegisterNetEvent('qbx_core:client:playerLoaded', function()
            cb(exports.qbx_core:GetPlayerData())
        end)
    end

    function FW.OnJobUpdate(cb)
        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(jobInfo)
            cb(jobInfo)
        end)
        RegisterNetEvent('qbx_core:client:onJobUpdate', function(jobInfo)
            cb(jobInfo)
        end)
    end
else
    function FW.GetPlayer(src)
        local xPlayer = exports.qbx_core:GetPlayer(src)
        if not xPlayer then return nil end

        return {
            source = src,
            citizenid = xPlayer.PlayerData.citizenid,
            name = (xPlayer.PlayerData.charinfo.firstname or "") .. " " .. (xPlayer.PlayerData.charinfo.lastname or ""),
            job = xPlayer.PlayerData.job,
            isBoss = xPlayer.PlayerData.job and xPlayer.PlayerData.job.isboss == true,
            getBank = function()
                return xPlayer.PlayerData.money['bank'] or 0
            end,
            addBank = function(amount, reason)
                return xPlayer.Functions.AddMoney('bank', amount, reason or "Boss Action")
            end,
            removeBank = function(amount, reason)
                return xPlayer.Functions.RemoveMoney('bank', amount, reason or "Boss Action")
            end,
            setJob = function(jobName, gradeLevel)
                return xPlayer.Functions.SetJob(jobName, gradeLevel)
            end
        }
    end

    function FW.GetPlayerByCitizenId(citizenId)
        local xPlayer = exports.qbx_core:GetPlayerByCitizenId(citizenId)
        if not xPlayer then return nil end
        return FW.GetPlayer(xPlayer.PlayerData.source)
    end

    function FW.GetJobGrades(jobName)
        local gradesArray = {}
        local jobInfo = exports.qbx_core:GetJob(jobName) or (exports.qbx_core:GetJobs() and exports.qbx_core:GetJobs()[jobName])
        if jobInfo and jobInfo.grades then
            for gradeLevel, gradeData in pairs(jobInfo.grades) do
                table.insert(gradesArray, {
                    level = tonumber(gradeLevel) or 0,
                    name = gradeData.name or gradeData.label or "Grade " .. tostring(gradeLevel)
                })
            end
            table.sort(gradesArray, function(a, b) return a.level < b.level end)
        end
        return gradesArray
    end

    function FW.GetEmployees(jobName, cb)
        MySQL.query('SELECT citizenid, charinfo, job FROM players WHERE JSON_EXTRACT(job, "$.name") = ?', {jobName}, function(result)
            local employees = {}
            local jobInfo = exports.qbx_core:GetJob(jobName) or (exports.qbx_core:GetJobs() and exports.qbx_core:GetJobs()[jobName])

            if result and #result > 0 then
                for _, v in ipairs(result) do
                    local charInfo = v.charinfo and json.decode(v.charinfo) or nil
                    local jobData = v.job and json.decode(v.job) or nil
                    
                    if charInfo and jobData and jobData.grade then
                        local gradeLevel = tostring(jobData.grade.level)
                        local label = "Bilinmiyor"
                        
                        if jobInfo and jobInfo.grades and jobInfo.grades[gradeLevel] then
                            label = jobInfo.grades[gradeLevel].name or jobInfo.grades[gradeLevel].label
                        elseif jobData.grade.name then
                            label = jobData.grade.name
                        end

                        table.insert(employees, {
                            name = (charInfo.firstname or "İsimsiz") .. " " .. (charInfo.lastname or "Oyuncu"),
                            citizenid = v.citizenid,
                            gradeLabel = label
                        })
                    end
                end
            end
            cb(employees)
        end)
    end

    function FW.FireEmployee(citizenId, cb)
        local target = FW.GetPlayerByCitizenId(citizenId)
        local defaultJob = {name = "unemployed", label = "Civilian", payment = 10, isboss = false, grade = {name = "Freelancer", level = 0}}

        if target then
            target.setJob("unemployed", 0)
            MySQL.update('UPDATE players SET job = ? WHERE citizenid = ?', {
                json.encode(defaultJob),
                citizenId
            }, function()
                cb(true, true)
            end)
        else
            MySQL.update('UPDATE players SET job = ? WHERE citizenid = ?', {
                json.encode(defaultJob),
                citizenId
            }, function(affected)
                cb(affected and affected > 0, false)
            end)
        end
    end

    function FW.SetGrade(citizenId, gradeLevel, jobName, cb)
        local target = FW.GetPlayerByCitizenId(citizenId)
        local grade = tonumber(gradeLevel) or 0

        if target then
            local success = target.setJob(target.job.name, grade)
            cb(success, true)
        else
            MySQL.update('UPDATE players SET job = JSON_SET(job, "$.grade.level", ?) WHERE citizenid = ?', {
                grade,
                citizenId
            }, function(affected)
                cb(affected and affected > 0, false)
            end)
        end
    end
end
