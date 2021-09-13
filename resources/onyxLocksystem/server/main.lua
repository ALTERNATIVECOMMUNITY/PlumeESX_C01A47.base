ESX = nil
local pID, vPlate
local stolenVehicles = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('onyx:updateSearchedVehTable')
AddEventHandler('onyx:updateSearchedVehTable', function(plate)
    local _source = source
    local vehPlate = plate

    TriggerClientEvent('onyx:returnSearchedVehTable', -1, vehPlate)
end)

RegisterServerEvent('onyx:reqHotwiring')
AddEventHandler('onyx:reqHotwiring', function(plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.getInventoryItem('lockpick').count > 0 then
        TriggerClientEvent('onyx:beginHotwire', source, plate)
        local rnd = math.random(1, 25)
        if rnd == 20 then
            xPlayer.removeInventoryItem('lockpick', 1)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'error', text = 'Your lockpick has broken'})
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'error', text = 'You have no lockpicks'})
    end
end)

RegisterServerEvent('onyx:addToStolen')
AddEventHandler('onyx:addToStolen', function(plate)
    table.insert(stolenVehicles, plate)
end)

ESX.RegisterServerCallback('onyx:isStolen', function(source, cb, plate)
    local found = false
    for _, v in pairs(stolenVehicles) do
        if v == plate then
            found = true
        end
    end
    cb(found)
end)

--function givePLayerKeysbyID(plate, id)
    --local pID = id
    --local vPlate = plate
    --print(pID)
    --print(vPlate)
    --TriggerClientEvent('onyx:updatePlates', pID, vPlate)
    
--end

RegisterServerEvent('onyx:sendKeys')
AddEventHandler('onyx:sendKeys', function(plate, id)
    pID = id
    vPlate = plate
    TriggerClientEvent('onyx:updatePlates', pID, vPlate)
end)

RegisterCommand("givekeys", function(source, args, rawCommand)
        local _source2 = source
        TriggerClientEvent('onyx:checkKeys', _source2)
end, false)