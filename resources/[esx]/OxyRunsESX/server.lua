ESX = nil
TriggerEvent("esx:getSharedObject",function(obj)
    ESX = obj
end)


RegisterServerEvent('esxoxy:serverPay')
AddEventHandler('esxoxy:serverPay', function(money)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount('black_money').money >= 1500 then
        xPlayer.removeAccountMoney('black_money', money)
        TriggerClientEvent("oxyrunesx:startOxyRun", source)
    else
       xPlayer.showNotification("You dont have enough ~r~Dirty Money ~w~for this!") 
    end
end)

RegisterServerEvent('esxoxy:moneyforPackage')
AddEventHandler('esxoxy:moneyforPackage', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = math.random(Config.MinAmount, Config.MaxAmount)
    xPlayer.addMoney(amount)

end)

RegisterServerEvent('esxoxy:givePackage')
AddEventHandler('esxoxy:givePackage', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('suspicious_box', 1)
end)

RegisterServerEvent('esxoxy:removePackage')
AddEventHandler('esxoxy:removePackage', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('suspicious_box', 1)
end)

RegisterServerEvent('esxoxy:pedSpawned')
AddEventHandler('esxoxy:pedSpawned', function(value)
    TriggerClientEvent('oxyrunesx:setPedSpawned', -1, value)
end)

