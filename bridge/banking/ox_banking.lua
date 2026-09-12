if not IsDuplicityVersion() then return end

Bridge.Banking['ox_banking'] = {
    GetAccountBalance = function(accountName)
        local balance = 0
        local success, res = pcall(function()
            if exports.ox_banking and exports.ox_banking.getAccountBalance then
                return exports.ox_banking:getAccountBalance(accountName)
            elseif exports.ox_banking and exports.ox_banking.getAccount then
                local acc = exports.ox_banking:getAccount(accountName)
                return acc and acc.balance or 0
            end
            return 0
        end)
        if success and res then balance = tonumber(res) or 0 end
        return balance
    end,

    AddMoney = function(accountName, amount, reason)
        local success = false
        pcall(function()
            if exports.ox_banking and exports.ox_banking.addBalance then
                success = exports.ox_banking:addBalance({
                    to = accountName,
                    amount = amount,
                    message = reason or "Boss Deposit"
                })
            end
        end)
        return success
    end,

    RemoveMoney = function(accountName, amount, reason)
        local success = false
        pcall(function()
            if exports.ox_banking and exports.ox_banking.removeBalance then
                success = exports.ox_banking:removeBalance({
                    from = accountName,
                    amount = amount,
                    message = reason or "Boss Withdraw"
                })
            end
        end)
        return success
    end
}
