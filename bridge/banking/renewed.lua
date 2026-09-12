if not IsDuplicityVersion() then return end

local RenewedHandler = {
    GetAccountBalance = function(accountName)
        local balance = 0
        local success, res = pcall(function()
            if exports['Renewed-Banking'] and exports['Renewed-Banking'].getAccountMoney then
                return exports['Renewed-Banking']:getAccountMoney(accountName)
            end
            return 0
        end)
        if success and res then balance = tonumber(res) or 0 end
        return balance
    end,

    AddMoney = function(accountName, amount, reason)
        local success = false
        pcall(function()
            if exports['Renewed-Banking'] and exports['Renewed-Banking'].addAccountMoney then
                exports['Renewed-Banking']:addAccountMoney(accountName, amount)
                success = true
            end
        end)
        return success
    end,

    RemoveMoney = function(accountName, amount, reason)
        local success = false
        pcall(function()
            if exports['Renewed-Banking'] and exports['Renewed-Banking'].removeAccountMoney then
                exports['Renewed-Banking']:removeAccountMoney(accountName, amount)
                success = true
            end
        end)
        return success
    end
}

Bridge.Banking['renewed'] = RenewedHandler
Bridge.Banking['Renewed-Banking'] = RenewedHandler
