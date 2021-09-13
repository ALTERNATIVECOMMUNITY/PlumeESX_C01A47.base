ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- sell chips
RegisterServerEvent('casino:deposit')
AddEventHandler('casino:deposit', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem('casino_chips').count
	if amount == nil or amount <= 0 or amount > item then
        -- error notification
		TriggerClientEvent('t-notify:client:Custom', _source, {
			style = 'success',
			message = 'Casino: You don\'t have that many chips to sell!',
			duration = 5500,
			sound = true
		})
	else
		xPlayer.removeInventoryItem('casino_chips',amount)
		xPlayer.addAccountMoney(Config.dollar, tonumber(amount))
        -- success notification
		TriggerClientEvent('okokNotify:Alert', _source, 'Casino:', 'you sold '..amount..' chips' , 6000, 'success')
	end
end)

-- buy chips
RegisterServerEvent('casino:withdraw')
AddEventHandler('casino:withdraw', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.getAccount(Config.dollar).money
	if amount == nil or amount <= 0 or amount > base then
        -- error notification
		TriggerClientEvent('okokNotify:Alert', _source, 'Casino:', 'You don\'t have enough money to buy that many chips!', 6000, 'error')
	else
		xPlayer.addInventoryItem('casino_chips',amount)
		xPlayer.removeAccountMoney(Config.dollar, amount)
        -- success notification
		TriggerClientEvent('okokNotify:Alert', _source, 'Casino:', 'you purchased '..amount..' chips', 6000, 'success')
	end
end)

-- buy ticket
RegisterServerEvent('casino:ticket')
AddEventHandler('casino:ticket', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local funds = 0
	tickets = tonumber(amount)
	ticket_cost = (tickets * Config.ticket)
	funds = xPlayer.getAccount(Config.dollar).money
	if funds == nil or funds <= 0 or ticket_cost > funds then
        -- error notification
		TriggerClientEvent('okokNotify:Alert', _source, 'Casino:', 'You don\'t have enough money to buy tickets!', 6000, 'error')
	else
		xPlayer.addInventoryItem('casino_ticket',amount)
		xPlayer.removeAccountMoney(Config.dollar, ticket_cost)
        -- success notification
		TriggerClientEvent('okokNotify:Alert', _source, 'Casino:', 'you purchased '..amount..' Lucky Wheel Tickets for $'..ticket_cost, 6000, 'success')
	end
end)

RegisterServerEvent('casino:balance')
AddEventHandler('casino:balance', function()

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getInventoryItem('casino_chips').count
	TriggerClientEvent('chips_currentbalance1', _source, balance)
	
end)