if not IsDuplicityVersion() then return end

Bridge.Banking['okokBanking'] = {
    GetAccountBalance = function(accountName)
        local balance = 0
        local success, res = pcall(function()
            local accountData = exports['okokBanking']:GetAccount(accountName)
            if type(accountData) == "table" then
                return accountData.money or accountData.balance or 0
            else
                return tonumber(accountData) or 0
            end
        end)
        if success and res then balance = res end
        return balance
    end,

    AddMoney = function(accountName, amount, reason)
        local success = false
        pcall(function()
            exports['okokBanking']:AddMoney(accountName, amount)
            success = true
        end)
        return success
    end,

    RemoveMoney = function(accountName, amount, reason)
        local success = false
        pcall(function()
            exports['okokBanking']:RemoveMoney(accountName, amount)
            success = true
        end)
        return success
    end
}
