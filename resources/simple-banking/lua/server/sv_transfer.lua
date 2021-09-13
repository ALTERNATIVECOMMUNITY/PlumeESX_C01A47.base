RegisterServerEvent('TropixRP:Bank:Transfer')

AddEventHandler('TropixRP:Bank:Transfer', function(target, account, amount, note, fSteamID)
    local source = source
    local ply = ESX.GetPlayerFromId(source)

    target = (target ~= nil and tonumber(target) or nil)
    if (not target or target <= 0 or target == source) then
        return
    end

    target = tonumber(target)
    amount = tonumber(amount)
    local targetPly = ESX.GetPlayerFromId(target)

    if (not targetPly or targetPly == -1) then
        return
    end

    if (target == source) then
        return
    end

    if (not amount or amount <= 0) then
        return
    end

    if (account == "personal") then
        local balance = ply.getAccount("bank").money

        if (amount > balance) then
            return
        end

        ply.removeAccountMoney('bank', math.floor(amount))
        targetPly.addAccountMoney('bank', math.floor(amount))
        TriggerClientEvent("TropixRP:Bank:Notify", source, "info", "You have transfered $" .. format_int(amount) .. " to " .. targetPly.getName() .. "'s account")
        TriggerEvent("TropixRP:AddToMoneyLog", source, "personal", -amount, "transfer", targetPly.getName(), "Transfered $" .. format_int(amount) .. " to " .. targetPly.getName())
        TriggerEvent("TropixRP:AddToMoneyLog", target, "personal", amount, "transfer", ply.getName(), "Received $" .. format_int(amount) .. " from " .. ply.getName())
    end

    if (account == "business") then
        local job = ply.getJob()
        local job_grade = job.grade_label

        if (not SimpleBanking.Config["business_ranks"][string.lower(job_grade)] and not SimpleBanking.Config["business_ranks_overrides"][string.lower(job.name)]) then
            return
        end

        local low = string.lower(job.name)
        local grade = string.lower(job.grade_label)

        if (SimpleBanking.Config["business_ranks_overrides"][low] and not SimpleBanking.Config["business_ranks_overrides"][low][grade]) then
            return
        end

        TriggerEvent("esx_society:getSociety", job.name, function(r)
            if (not r) then
                return
            end

            local society_name = r.account

            TriggerEvent('esx_addonaccount:getSharedAccount', society_name, function(society)
                local societyMoney = society.money

                if (amount >= societyMoney) then
                    return
                end

                society.removeMoney(amount)
                Wait(50)
                targetPly.addAccountMoney('money', amount)
                TriggerClientEvent("TropixRP:Bank:Notify", source, "info", "You have transfered $" .. format_int(amount) .. " from " .. r.label .. "'s account")
                TriggerEvent("TropixRP:AddToMoneyLog", source, "personal", -amount, "transfer", targetPly.getName(), "Transfered $" .. format_int(amount) .. " to " .. targetPly.getName() .. " from " .. r.label .. "'s account")
                TriggerEvent("TropixRP:AddToMoneyLog", target, "personal", amount, "transfer", ply.getName(), "Received $" .. format_int(amount) .. " from " .. ply.getName() .. " of " .. r.label)
            end)
        end)
    end

    if (account == "friend") then
        if (not fSteamID) then return end
        
        local plyID = ply.getIdentifier()

        local fChecked = false
        local hasAccess = false
        local fAmount = 0
        local account_id = ""

        --// Check if they have access to the account first. \\--
        MySQL.Async.fetchAll("SELECT * FROM `banking_access` WHERE `target_identifier` = @myID AND `owner_identifier` = @ownerID", {
            ["@myID"] = plyID,
            ["@ownerID"] = fSteamID,
        }, function(data)
            if (data and #data >= 1) then
                hasAccess = true
                account_id = data[1].owner_identifier
            end

            fChecked = true
        end)

        repeat
            Wait(0)
        until fChecked

        if (not hasAccess) then
            return
        end

        if (account_id == fSteamID) then
            TriggerClientEvent("TropixRP:Bank:ExtNotify", source, "You can't transfer from the owner to the owner!")
            return
        end

        local realTarget = ESX.GetPlayerFromIdentifier(account_id)

        if (realTarget) then
            local friendsName = realTarget.getName()
            targetPly.addAccountMoney("bank", math.floor(amount))
            realTarget.removeAccountMoney("bank", math.floor(amount))
            ESX.SavePlayer(realTarget)
            TriggerClientEvent("TropixRP:Bank:Notify", source, "info", "You have transfered $" .. format_int(amount) .. " into " .. targetPly.getName() .. "'s account from "..friendsName)
            TriggerEvent("TropixRP:AddToMoneyLog", target, "personal", amount, "transfer", ply.getName(), "Received $" .. format_int(amount) .. " from " .. ply.getName())
            TriggerEvent("TropixRP:AddToMoneyLog", source, "friend", amount, "transfer", friendsName, (note ~= "" and note or "Transfered $" .. format_int(amount) .. " to " .. targetPly.getName().." from "..friendsName .. "'s account"))
            TriggerEvent("TropixRP:AddToMoneyLog", realTarget.playerId, "friend", -amount, "transfer", ply.getName(), (note ~= "" and note or ply.getName() .. " has transfered $" .. format_int(amount) .. " to "..targetPly.getName()))
        else
            -- this is not cool
            local accountJson = {}
            local accountsRan = false
            local friendsName = ""

            MySQL.Async.fetchAll("SELECT `accounts`, `firstname`, `lastname` FROM `users` WHERE `identifier` = @account_id", {
                ["@account_id"] = account_id
            }, function(data)
                if (data and #data >= 1) then
                    accountsJson = json.decode(data[1].accounts)
                    friendsName = data[1].firstname .. " " .. data[1].lastname
                    accountsRan = true
                else
                    return
                end
            end)

            repeat
                Wait(0)
            until accountsRan

            if (accountsRan) then

                if (math.floor(tonumber(accountsJson["bank"])) < math.floor(amount)) then
                    return
                end

                accountsJson["bank"] = accountsJson["bank"] - math.floor(amount)
                local newJson = json.encode(accountsJson)

                MySQL.Async.execute("UPDATE `users` SET `accounts` = @newAccount WHERE `identifier` = @account_id", {
                    ["@newAccount"] = newJson,
                    ["@account_id"] = account_id
                }, function(r)
                    if (r and r >= 1) then
                        targetPly.addAccountMoney("bank", amount)
                        TriggerClientEvent("TropixRP:Bank:Notify", source, "info", "You have transfered $" .. format_int(amount) .. " into " .. targetPly.getName() .. "'s account from "..friendsName)
                        TriggerEvent("TropixRP:AddToMoneyLog", target, "personal", amount, "transfer", ply.getName(), "Received $" .. format_int(amount) .. " from " .. ply.getName())
                        TriggerEvent("TropixRP:AddToMoneyLog", source, "friend", amount, "transfer", friendsName, (note ~= "" and note or "Transfered $" .. format_int(amount) .. " to " .. targetPly.getName().." from "..friendsName .. "'s account"))
                        AddOfflineTransaction(fSteamID, "friend", -amount, "transfer", ply.getName(), (note ~= "" and note or ply.getName() .. " has transfered $" .. format_int(amount) .. " to "..targetPly.getName()))
                        return
                    end
                end)
            end
        end
    end
end)