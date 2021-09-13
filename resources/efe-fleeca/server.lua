ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("aw3-fleeca:startcheck")
AddEventHandler("aw3-fleeca:startcheck", function(bank)
    local _source = source
    local copcount = 2
    local Players = ESX.GetPlayers()

    for i = 1, #Players, 1 do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer.job.name == "police" then
            copcount = copcount + 1
        end
    end
    local xPlayer = ESX.GetPlayerFromId(_source)

    if copcount >= fleeca.mincops then
        if not fleeca.Banks[bank].onaction == true then
            if (os.time() - fleeca.cooldown) > fleeca.Banks[bank].lastrobbed then
                fleeca.Banks[bank].onaction = true

                TriggerClientEvent("aw3-fleeca:outcome", _source, true, bank)
                TriggerClientEvent("aw3-fleeca:policenotify", -1, bank)
                TriggerClientEvent('np-dispatch:bankrobbery', -1)
                    return
                else
                    TriggerClientEvent("aw3-fleeca:outcome", _source, false, "This bank has already been robbed. Time to wait: "..math.floor((fleeca.cooldown - (os.time() - fleeca.Banks[bank].lastrobbed)) / 60)..":"..math.fmod((fleeca.cooldown - (os.time() - fleeca.Banks[bank].lastrobbed)), 60))
                end
            else
            TriggerClientEvent("aw3-fleeca:outcome", _source, false, "This bank has already been robbed.")
        end
    else
        TriggerClientEvent("aw3-fleeca:outcome", _source, false, "There are not enough police in the city.")
    end
end)

RegisterServerEvent("aw3-fleeca:lootup")
AddEventHandler("aw3-fleeca:lootup", function(var, var2)
    TriggerClientEvent("aw3-fleeca:lootup_c", -1, var, var2)
end)

RegisterServerEvent("aw3-fleeca:openDoor")
AddEventHandler("aw3-fleeca:openDoor", function(coords, method)
    TriggerClientEvent("aw3-fleeca:openDoor_c", -1, coords, method)
end)

RegisterServerEvent("aw3-fleeca:startLoot")
AddEventHandler("aw3-fleeca:startLoot", function(data, name, players)
    local _source = source

    for i = 1, #players, 1 do
        TriggerClientEvent("aw3-fleeca:startLoot_c", players[i], data, name)
    end
    TriggerClientEvent("aw3-fleeca:startLoot_c", _source, data, name)
end)

RegisterServerEvent("aw3-fleeca:stopHeist")
AddEventHandler("aw3-fleeca:stopHeist", function(name)
    TriggerClientEvent("aw3-fleeca:stopHeist_c", -1, name)
end)

RegisterServerEvent("aw3-fleeca:rewardCash")
AddEventHandler("aw3-fleeca:rewardCash", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local payout = math.random(4,5)
    --TriggerClientEvent('player:receiveItem', source, 'markedbills', payout)
    xPlayer.addAccountMoney('black_money', payout)
end)

RegisterServerEvent("aw3-fleeca:setCooldown")
AddEventHandler("aw3-fleeca:setCooldown", function(name)
    fleeca.Banks[name].lastrobbed = os.time()
    fleeca.Banks[name].onaction = false
    TriggerClientEvent("aw3-fleeca:resetDoorState", -1, name)
end)

ESX.RegisterServerCallback("aw3-fleeca:getBanks", function(source, cb)
    cb(fleeca.Banks)
end)