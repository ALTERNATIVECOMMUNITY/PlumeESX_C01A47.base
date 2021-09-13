bMenuOpen = false 
local plyData = nil
local plyName = nil

Citizen.CreateThread(function()
    while (true) do
        ESX.TriggerServerCallback('TropixRP:GetPlayerName', function(data)
            plyName = data
        end)
        Wait(20000)
    end
end)

function ToggleUI()
    bMenuOpen = not bMenuOpen

    if (not bMenuOpen) then
        SetNuiFocus(false, false)
        ESX.UI.Menu.CloseAll()
    else
        ESX.TriggerServerCallback("TropixRP:GetBankData", function(data, friends, transactions)
            local PlayerBanks = json.encode(data)
            local FriendsData = {}

            if (friends and #friends >= 1) then
                FriendsData = friends
            end

            SetNuiFocus(true, true)
            SendNUIMessage({type = 'OpenUI', accounts = PlayerBanks, friends = json.encode(FriendsData), transactions = json.encode(transactions), name = plyName})
        end)
    end
end

RegisterNUICallback("CloseATM", function()
    ToggleUI()
end)

RegisterNUICallback("DepositCash", function(data, cb)
    if (not data or not data.account or not data.amount) then
        return
    end

    if (tonumber(data.amount) <= 0) then
        return
    end

    if (data.account == "friend" and not data.steamid) then
        return
    end


    TriggerServerEvent("TropixRP:Bank:Deposit", data.account, data.amount, (data.note ~= nil and data.note or ""), (data.steamid ~= nil and data.steamid or ""))
end)

RegisterNUICallback("WithdrawCash", function(data, cb)
    if (not data or not data.account or not data.amount) then
        return
    end

    if(tonumber(data.amount) <= 0) then
        return
    end

    if (data.account == "friend" and not data.steamid) then
        return
    end

    TriggerServerEvent("TropixRP:Bank:Withdraw", data.account, data.amount, (data.note ~= nil and data.note or ""), (data.steamid ~= nil and data.steamid or ""))
end)

RegisterNUICallback("TransferCash", function(data, cb)
    if (not data or not data.account or not data.amount or not data.target) then
        return
    end

    if(tonumber(data.amount) <= 0) then
        return
    end

    if(tonumber(data.target) <= 0) then
        return
    end

    TriggerServerEvent("TropixRP:Bank:Transfer", data.target, data.account, data.amount, (data.note ~= nil and data.note or ""), (data.steamid ~= nil and data.steamid or ""))
end)

RegisterNUICallback("RemoveAccess", function(data, cb)
    if (not data or not data.target or not data.player) then
        return
    end

    TriggerServerEvent("TropixRP:Bank:RemoveAccess", data.target, data.player)
end)

RegisterNUICallback("EditAccount", function(data, cb)
    ESX.TriggerServerCallback("TropixRP:Bank:GetBankAuths", function(auths)

        if (auths and #auths >= 1) then
            SendNUIMessage({type = 'edit_account', auths = json.encode(auths)})
        else
            SendNUIMessage({type = 'notification', msg_type = "error", message = "Nobody has access to your bank account!"})
        end
    end, "personal")
end)


--// Net Events \\--
RegisterNetEvent("TropixRP:Bank:Notify")
AddEventHandler("TropixRP:Bank:Notify", function(type, msg)
    if (bMenuOpen) then
        SendNUIMessage({type = 'notification', msg_type = type, message = msg})
    end
end)

RegisterNetEvent("TropixRP:Bank:UpdateTransactions")
AddEventHandler("TropixRP:Bank:UpdateTransactions", function(transactions)
    if (bMenuOpen) then
        print("Sent update")
        SendNUIMessage({type = 'update_transactions', transactions = json.encode(transactions)})
        --SendNUIMessage({type = "refresh_accounts"})

        ESX.TriggerServerCallback("TropixRP:GetBankData", function(data, friends, transactions)
            local PlayerBanks = json.encode(data)

            local FriendsData = {}

            if (friends and #friends >= 1) then
                FriendsData = friends
            end

            SendNUIMessage({type = "refresh_balances", accounts = PlayerBanks, friends = json.encode(FriendsData)})
        end)
    end
end)


RegisterNetEvent("TropixRP:Bank:RefreshAccounts")
AddEventHandler("TropixRP:Bank:RefreshAccounts", function()
    SendNUIMessage({type = "refresh_accounts"})
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    SendNUIMessage({type = "refresh_accounts"})
end)