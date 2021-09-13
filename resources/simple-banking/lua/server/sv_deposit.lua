RegisterServerEvent('TropixRP:Bank:Deposit')
AddEventHandler('TropixRP:Bank:Deposit', function(account, amount, note, fSteamID)
    local source = source
    local ply = ESX.GetPlayerFromId(source)

    if(not ply or ply == -1) then
        return
    end

    if(not amount or tonumber(amount) <= 0) then
        TriggerClientEvent("TropixRP:Bank:Notify", source, "error", "Invalid Amount!") 
        return
    end

    amount = tonumber(amount)
    if(math.floor(amount) > ply.getMoney()) then
        TriggerClientEvent("TropixRP:Bank:Notify", source, "error", "You can't afford this!") 
        return
    end

    if(account == "personal") then
        local amt = math.floor(amount)

        ply.removeMoney(amt)
        Wait(500)
        ply.addAccountMoney("bank", amt)
        RefreshTransactions(source)
        TriggerClientEvent("TropixRP:Bank:Notify", source, "info", "You have deposited $"..format_int(amount)) 
        TriggerEvent("TropixRP:AddToMoneyLog", source, "personal", amount, "deposit", "N/A", (note ~= "" and note or "Deposited $"..format_int(amount).." cash."))
        return
    end

    if(account == "business") then
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
            local society_name = r.account

            TriggerEvent('esx_addonaccount:getSharedAccount', society_name, function(society)
                ply.removeMoney(math.floor(amount))
                TriggerClientEvent("TropixRP:Bank:Notify", source, "info", "You have deposited $"..format_int(amount).." into ".. r.label.."'s business account.") 
                TriggerEvent("TropixRP:AddToMoneyLog", source, "business", amount, "deposit", r.label, (note ~= "" and note or "Deposited $"..format_int(amount).." cash into ".. r.label .."'s business account."))
                society.addMoney(math.floor(amount))
            end)
        end)
    end


    if(account == "friend") then
        if (not fSteamID) then
            return
        end

        --local myHexID = PlayerIdentifier('steam', source)
        --local mySteamID = HexIdToSteamId(myHexID)

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
        until
            fChecked

        if (not hasAccess) then
            return
        end

        local realTarget = ESX.GetPlayerFromIdentifier(account_id)

        if (realTarget) then
            local friendsName = realTarget.getName()

            ply.removeMoney(math.floor(amount))
            realTarget.addAccountMoney("bank", math.floor(amount))
            ESX.SavePlayer(realTarget)
            ESX.SavePlayer(ply)
            TriggerClientEvent("TropixRP:Bank:Notify", source, "info", "You have deposited $"..format_int(amount).." into "..friendsName.."'s account") 
            TriggerEvent("TropixRP:AddToMoneyLog", source, "friend", amount, "deposit", friendsName, (note ~= "" and note or "Deposited $"..format_int(amount).." cash into "..friendsName.."'s account"))
            TriggerEvent("TropixRP:AddToMoneyLog", realTarget.playerId, "friend", amount, "deposit", ply.getName(), (note ~= "" and note or ply.getName().." has deposited $"..format_int(amount).." cash into your personal account"))
        else
            -- this is not cool
            local accountJson = {}
            local accountsRan = false
            local friendsName = ""

            MySQL.Async.fetchAll("SELECT `accounts`, `firstname`, `lastname` FROM `users` WHERE `identifier` = @account_id",
            {
                ["@account_id"] = account_id
            }, function(data)
                if (data and #data >= 1) then
                    accountsJson = json.decode(data[1].accounts)
                    friendsName = data[1].firstname.." "..data[1].lastname
                    accountsRan = true
                else
                    return
                end
            end)

            repeat
                Wait(0)
            until
                accountsRan
            
            if (accountsRan) then
                accountsJson["bank"] = accountsJson["bank"] + math.floor(amount)

                local newJson = json.encode(accountsJson)

                MySQL.Async.execute("UPDATE `users` SET `accounts` = @newAccount WHERE `identifier` = @account_id",
                {
                    ["@newAccount"] = newJson,
                    ["@account_id"] = account_id
                }, function(r)
                    if (r and r >= 1) then
                        ply.removeMoney(math.floor(amount))
                        RefreshTransactions(source)
                        TriggerClientEvent("TropixRP:Bank:Notify", source, "info", "You have deposited $"..format_int(amount).." into "..friendsName.."'s account") 
                        TriggerEvent("TropixRP:AddToMoneyLog", source, "friend", amount, "deposit", friendsName, (note ~= "" and note or "Deposited $"..format_int(amount).." cash into "..friendsName.."'s account"))
                        AddOfflineTransaction(fSteamID,  "friend", amount, "deposit", ply.getName(), (note ~= "" and note or ply.getName().." has deposited $"..format_int(amount).." cash into your personal account"))
                        return
                    end
                end)
            end
        end

        return
    end
end)