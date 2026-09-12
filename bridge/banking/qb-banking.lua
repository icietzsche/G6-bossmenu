if not IsDuplicityVersion() then return end

Bridge.Banking['qb-banking'] = {
    GetAccountBalance = function(accountName)
        local balance = 0
        local success, res = pcall(function()
            if exports['qb-banking'] and exports['qb-banking'].GetAccountBalance then
                return exports['qb-banking']:GetAccountBalance(accountName)
            elseif exports['qb-management'] and exports['qb-management'].GetAccount then
                return exports['qb-management']:GetAccount(accountName)
            end
            return 0
        end)
        if success and res then balance = tonumber(res) or 0 end
        return balance
    end,

    AddMoney = function(accountName, amount, reason)
        local success = false
        pcall(function()
            if exports['qb-banking'] and exports['qb-banking'].AddMoney then
                exports['qb-banking']:AddMoney(accountName, amount, reason or "Boss Deposit")
                success = true
            elseif exports['qb-management'] and exports['qb-management'].AddMoney then
                exports['qb-management']:AddMoney(accountName, amount)
                success = true
            end
        end)
        return success
    end,

    RemoveMoney = function(accountName, amount, reason)
        local success = false
        pcall(function()
            if exports['qb-banking'] and exports['qb-banking'].RemoveMoney then
                exports['qb-banking']:RemoveMoney(accountName, amount, reason or "Boss Withdraw")
                success = true
            elseif exports['qb-management'] and exports['qb-management'].RemoveMoney then
                exports['qb-management']:RemoveMoney(accountName, amount)
                success = true
            end
        end)
        return success
    end
}
