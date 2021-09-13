function RefreshTransactions(source)
    if (not source) then return end

    local ply = ESX.GetPlayerFromId(source)

    if (not ply) then return end

    local plyID = ply.getIdentifier()

    MySQL.Async.fetchAll("SELECT * FROM `transaction_history` WHERE `identifier` = @myID AND DATE(date) > (NOW() - INTERVAL "..SimpleBanking.Config["Days_Transaction_History"].." DAY) ORDER BY `id` ASC;",
    {
        ["@myID"] = plyID
    }, function(data)
        if (not data) then return end

        TriggerClientEvent("TropixRP:Bank:UpdateTransactions", source, data)
    end)
end

--// Callback to open server menu \\--
ESX.RegisterServerCallback("TropixRP:GetBankData", function(source, cb)
    if (not source) then return end

    local ply = ESX.GetPlayerFromId(source)

    if (not ply) then return end

    local plyBank = ply.getAccount("bank").money or 0
    local plyID = ply.getIdentifier()

    local TransactionHistory = {}
    local TransactionRan = false
    local FriendAccounts = {}
    local FriendAccountsRan = false
    local tbl = {}

    tbl[1] = {
        type = "personal",
        amount = plyBank
    }

    local job = ply.getJob()

    if (job and job.grade_label) then
        if(SimpleBanking.Config["business_ranks"][string.lower(job.grade_label)] or SimpleBanking.Config["business_ranks_overrides"][string.lower(job.name)] and SimpleBanking.Config["business_ranks_overrides"][string.lower(job.name)][string.lower(job.grade_label)]) then
            TriggerEvent('esx_society:getSociety', job.name, function(data)
                TriggerEvent('esx_addonaccount:getSharedAccount', data.account, function(r)
                    tbl[#tbl + 1] = {
                        type = "business",
                        name = job.label,
                        amount = r.money or 0
                    }
                end)
            end)
        end
    end

    MySQL.Async.fetchAll("SELECT * FROM `banking_access` WHERE `target_identifier` = @myID", {
        ["@myID"] = plyID
    }, function(data)
        if (data and #data >= 1) then

            for k,v in pairs(data) do
                local amountRan, amountQuery = GetBankByID(v.owner_identifier)

                repeat
                    Wait(0)
                until
                    amountRan
                
                FriendAccounts[#FriendAccounts + 1] = {
                    type = "friend",
                    id = v.owner_identifier,
                    amount = amountQuery,
                    owner = v.owner_name
                } 
            end
        end

        FriendAccountsRan = true
    end)

    repeat
        Wait(0)
    until
        FriendAccountsRan

    MySQL.Async.fetchAll("SELECT * FROM `transaction_history` WHERE `identifier` = @myID AND DATE(date) > (NOW() - INTERVAL "..SimpleBanking.Config["Days_Transaction_History"].." DAY) ORDER BY `id` ASC;", {
        ["@myID"] = plyID,
    }, function(data)
        TransactionRan = true
        TransactionHistory = data
    end)

    repeat
        Wait(0)
    until 
        TransactionRan

    cb(tbl, FriendAccounts, TransactionHistory)
end)

ESX.RegisterServerCallback("TropixRP:Bank:GetBankAuths", function(source, cb, account)
    local source = source

    local ply = ESX.GetPlayerFromId(source)
    local plyID = ply.getIdentifier()

    if (not account or account ~= "personal") then
        TriggerClientEvent("TropixRP:Bank:Notify", source, "error", "You can only edit your own bank!")
        return 
    end
    
    MySQL.Async.fetchAll("SELECT * FROM `banking_access` WHERE `owner_identifier` = @myID", {
        ["@myID"] = plyID
    }, function(data)
        cb(data)
    end)
end)

ESX.RegisterServerCallback("TropixRP:GetPlayerName", function(source, cb) 
    local source = source
    local ply = ESX.GetPlayerFromId(source)

    local name = (ply ~= nil and ply.getName() or "John Doe")
    cb(name)
end)