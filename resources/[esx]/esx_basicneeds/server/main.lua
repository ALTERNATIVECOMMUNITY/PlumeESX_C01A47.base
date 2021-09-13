ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	xPlayer.showNotification(_U('used_bread'))
end)

ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	xPlayer.showNotification(_U('used_water'))
end)

-- Burger Shot Stuff
ESX.RegisterUsableItem('moneyshot', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('moneyshot', 1)
    TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
    TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('fries', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('fries', 1)
    TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
    TriggerClientEvent('esx_status:add', source, 'thirst', -50000)
    TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('bleeder', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('bleeder', 1)
    TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
    TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('heartstopper', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('thermite', 1)
    TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
end)

ESX.RegisterUsableItem('thermite', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx_thermite:onUse', source)
end)

ESX.RegisterUsableItem('lockpick', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx_lockpick:onUse', source)
    TriggerClientEvent('houseRobberies:attempt', source, 1)
end)

ESX.RegisterUsableItem('laptop', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('laptop', 1)
    TriggerClientEvent('aw3-fleeca:useLatop', source)
end)

ESX.RegisterUsableItem('armor', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('armor', 1)
    TriggerClientEvent('esx_ambulancejob:givePedArmor', source, 30)
end)

ESX.RegisterUsableItem('idcard', function(source)
   TriggerClientEvent('luca_idcard:useId', source)
end)

ESX.RegisterCommand('heal', 'admin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx_basicneeds:healPlayer')
	args.playerId.triggerEvent('chat:addMessage', {args = {'^5HEAL', 'You have been healed.'}})
end, true, {help = 'Heal a player, or yourself - restores thirst, hunger and health.', validate = true, arguments = {
	{name = 'playerId', help = 'the player id', type = 'player'}
}})
