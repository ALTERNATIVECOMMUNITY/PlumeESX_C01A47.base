RegisterNetEvent("TropixRP:AddToMoneyLog")
AddEventHandler("TropixRP:AddToMoneyLog", function(source, sAccount, iAmount, sType, sReceiver, sMessage, cb)
    local ply = ESX.GetPlayerFromId(source)
    local plyID = ply.getIdentifier()

    local iTransactionID = math.random(1000, 100000)

    MySQL.Async.execute("INSERT INTO `transaction_history` (`identifier`, `trans_id`, `account`, `amount`, `trans_type`, `receiver`, `message`) VALUES(@myID, @transid, @account, @amount, @type, @receiver, @message);", {
        ["@myID"] = plyID,
        ["@transid"] = iTransactionID,
        ["@account"] = sAccount,
        ["@amount"] = iAmount,
        ["@type"] = sType,
        ["@receiver"] = sReceiver,
        ["@message"] = sMessage
    }, function()
        RefreshTransactions(source)
    end)
end)

function GetBankByID(id)
    local queryRan, queryValue = false, 0

    MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @id",
    {
        ["@id"] = id
    }, function(data)
        if (data and #data >= 1) then
            local accounts = json.decode(data[1].accounts)

            for k,v in pairs(accounts) do
                if (k == "bank") then
                    queryValue = v
                end
            end
        end

        queryRan = true
    end)

    repeat
        Wait(0)
    until
        queryRan

    return queryRan, queryValue 
end

function AddOfflineTransaction(sID, sAccount, iAmount, sType, sReceiver, sMessage)
    local iTransactionID = math.random(1000, 100000)
    
    MySQL.Async.execute("INSERT INTO `transaction_history` (`identifier`, `trans_id`, `account`, `amount`, `trans_type`, `receiver`, `message`) VALUES(@tIdentifier, @transid, @account, @amount, @type, @receiver, @message);", {
        ["@tIdentifier"] = sID,
        ["@transid"] = iTransactionID,
        ["@account"] = sAccount,
        ["@amount"] = iAmount,
        ["@type"] = sType,
        ["@receiver"] = sReceiver,
        ["@message"] = sMessage
    })
end