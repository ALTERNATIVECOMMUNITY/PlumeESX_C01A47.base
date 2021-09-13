local deadPeds = {}
local shopkeepers = {}
local shopkeepersState = {}
local registerOpened = {}
local safeOpened = {}
local SafeCodes = {}
local canRob = {}
local canRobList = {}
randomKeyGen = math.random(100000000,999999999) 

Citizen.CreateThread(function()

        for v = 1, #Config.Shops do
            shopkeepers[v] = math.random(1, #Config.Shopkeepers)
            deadPeds[v] = false
            canRobList[v] = true
            shopkeepersState[v] = true
        end

        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(Config.ShopkeeperResetTime)

                for v = 1, #Config.Shops do
                    shopkeepers[v] = math.random(1, #Config.Shopkeepers)
                    shopkeepersState[v] = true
                end

                TriggerClientEvent('storeRobberies:client:shopkeeperStateUpdate', -1, shopkeepersState)
                TriggerClientEvent('storeRobberies:client:shopkeeperReset', -1, shopkeepers)
            end
        end)
end)

RegisterServerEvent('storeRobberies:server:shopkeeperUpdate')
AddEventHandler('storeRobberies:server:shopkeeperUpdate', function(source)
    while checker do
        checker = false
        for v = 1, #Config.Shops do
            if(shopkeepers[v] == nil)then
                checker = true
            end
        end
    end

    
    TriggerClientEvent('storeRobberies:client:shopkeeperUpdate', source, shopkeepers)
end)

RegisterServerEvent('storeRobberies:server:shopkeeperStateUpdate')
AddEventHandler('storeRobberies:server:shopkeeperStateUpdate', function(source)
    TriggerClientEvent('storeRobberies:client:shopkeeperStateUpdate', source, shopkeepersState)
end)

RegisterServerEvent('storeRobberies:server:randomKeyGen')
AddEventHandler('storeRobberies:server:randomKeyGen', function(source)
    TriggerClientEvent('storeRobberies:client:randomKeyGen', source, randomKeyGen)
end)

RegisterServerEvent('storeRobberies:server:fightBack')
AddEventHandler('storeRobberies:server:fightBack', function(store, safe, ped)
    TriggerClientEvent('storeRobberies:client:fightBack', -1, store, safe, ped)
end)

RegisterServerEvent('storeRobberies:server:registerOpenedUpdate')
AddEventHandler('storeRobberies:server:registerOpenedUpdate', function(source)

    for v = 1, #Config.Shops do
        registerOpened[v] = false
    end

    TriggerClientEvent('storeRobberies:client:registerOpenedUpdate', source, registerOpened)
end)

RegisterServerEvent('storeRobberies:server:safeOpenedUpdate')
AddEventHandler('storeRobberies:server:safeOpenedUpdate', function(source)

    for v = 1, #Config.Shops do
        safeOpened[v] = false
    end

    TriggerClientEvent('storeRobberies:client:safeOpenedUpdate', source, safeOpened)
end)

RegisterServerEvent('storeRobberies:server:animator')
AddEventHandler('storeRobberies:server:animator', function(number, dict, anim, time)
    TriggerClientEvent('storeRobberies:client:animator', -1, number, dict, anim, time)
end)

Citizen.CreateThread(function()
    while true do 
        for v = 1, #Config.Shops do

            if(Config.Shops[v].safeType == "keypad")then
                SafeCodes[v] = math.random(1000, 9999)
            else
                SafeCodes[v] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)}
            end
        end
        TriggerClientEvent("storeRobberies:client:safeCodeUpdate", -1, SafeCodes)
        Citizen.Wait((1000 * 60) * 30)
    end
end)

RegisterServerEvent('storeRobberies:server:safeCodeUpdate')
AddEventHandler('storeRobberies:server:safeCodeUpdate', function(source)
    TriggerClientEvent('storeRobberies:client:safeCodeUpdate', source, SafeCodes)
end)

RegisterServerEvent('storeRobberies:server:canRobUpdater')
AddEventHandler('storeRobberies:server:canRobUpdater', function(source)
    TriggerClientEvent('storeRobberies:client:canRobUpdater', source, canRobList)
end)

RegisterServerEvent('storeRobberies:server:canRobRunning')
AddEventHandler('storeRobberies:server:canRobRunning', function(store,state)
    canRobList[store] = state
    TriggerClientEvent('storeRobberies:client:canRobRunning', -1, store, canRobList[store])
end)

RegisterServerEvent('storeRobberies:server:pedDead')
AddEventHandler('storeRobberies:server:pedDead', function(store)
    if not deadPeds[store] then
        deadPeds[store] = true
        shopkeepersState[store] = false
        TriggerClientEvent('storeRobberies:client:onPedDeath', -1, store)
        local second = 1000
        local minute = 60 * second
        local hour = 60 * minute
        local cooldown = Config.Shops[store].cooldown
        local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
        Citizen.CreateThread(function()
            Wait(wait)
            if not Config.Shops[store].registerOpened then
                for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
                TriggerClientEvent('storeRobberies:client:resetStore', -1, store)
                deadPeds[store] = false
            end
            shopkeepersState[store] = true
        end)
    end
end)

RegisterServerEvent('storeRobberies:server:registerOpen')
AddEventHandler('storeRobberies:server:registerOpen', function(store)
    local src = source
    Config.Shops[store].registerOpened = true
    TriggerClientEvent('storeRobberies:client:registerOpen', -1, store, true)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local cooldown = Config.Shops[store].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
    Wait(wait)
    Citizen.CreateThread(function()
        Config.Shops[store].registerOpened = false
        TriggerClientEvent('storeRobberies:client:registerOpen', -1, store, false)
        for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
        TriggerClientEvent('voxlar_robbery:resetStore', -1, store)
    end)
end)

RegisterServerEvent('storeRobberies:server:safeOpen')
AddEventHandler('storeRobberies:server:safeOpen', function(store)
    local src = source
    Config.Shops[store].safeOpened = true
    TriggerClientEvent('storeRobberies:client:safeOpen', -1, store, true)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local cooldown = Config.Shops[store].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
    Wait(wait)
    Citizen.CreateThread(function()
        Config.Shops[store].safeOpened = false
        TriggerClientEvent('storeRobberies:client:registerOpen', -1, store, false)
        for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
        TriggerClientEvent('voxlar_robbery:resetStore', -1, store)
    end)
end)