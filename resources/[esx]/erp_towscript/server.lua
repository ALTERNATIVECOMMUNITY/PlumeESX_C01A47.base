ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('erp_towscript:payPlayer')
AddEventHandler('erp_towscript:payPlayer', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addAccountMoney('money', amount)
end)