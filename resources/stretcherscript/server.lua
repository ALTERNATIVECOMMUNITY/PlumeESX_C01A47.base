local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('stretcher:sendTo')
AddEventHandler('stretcher:sendTo', function(player)
    TriggerClientEvent('stretcher:putOn', player)
end)

