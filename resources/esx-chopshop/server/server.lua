-- Leaked By: Leaking Hub | J. Snow | leakinghub.com

ESX = nil
local CarList                         = {
    --  [Car Model]                     = Price Of Chopping Car  --
        [1]                      = 'rebel',
        [2]                     = 'sadler',
        [3]                     = 'sandking',
        [4]                    = 'sultan',
        [5]                    = 'sanchez',
        [6]                    = 'emperor',
        [7]                    = 'voodoo2',
        [8]                    = 'surfer2',
        [9]                    = 'bison',
        [10]                    = 'blazer',
        [11]                    = 'regina',
        [12]                    = 'phoenix',
        [13]                    = 'bfinjection',
        [14]                    = 'patriot',
        [15]                    = 'buccaneer2'
}
local carsToChop = {}
local ids = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- RegisterServerEvent('esx-chopshop:addCash')
-- AddEventHandler('esx-chopshop:addCash', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
-- 	local randomChance = math.random(0, 2)
-- 	local money = 1)
-- 	local payout = math.random(2,4)
-- 	if xPlayer ~= nil then	
-- 		if randomChance == 0 then
-- 			Citizen.Wait(5)
-- 			TriggerClientEvent('player:receiveItem', _source,'', payout)
-- 			TriggerClientEvent('player:receiveItem', _source, '', payout)
-- 			xPlayer.addMoney(money)
-- 		elseif randomChance == 1 then
-- 			Citizen.Wait(5)
-- 			TriggerClientEvent('player:receiveItem', _source, '', payout)
-- 			TriggerClientEvent('player:receiveItem', _source, '', payout)
-- 			TriggerClientEvent('player:receiveItem', _source, '', payout)
-- 			xPlayer.addMoney(money)
-- 		elseif randomChance == 2 then
-- 			TriggerClientEvent('player:receiveItem', _source, '', payout)
-- 			TriggerClientEvent('player:receiveItem', _source, '', payout)
-- 			TriggerClientEvent('player:receiveItem', _source, '', payout)
-- 			xPlayer.addMoney(money)
-- 		end
-- 	end
-- end)

RegisterServerEvent('esx-chopshop:addCash')
AddEventHandler('esx-chopshop:addCash', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.addInventoryItem('aluminium', 3)
    xPlayer.addInventoryItem("copper", 2)
	xPlayer.addInventoryItem('electronics', 5)
    xPlayer.addInventoryItem("plastic", 4)
	xPlayer.addInventoryItem('steel', 6)
    xPlayer.addInventoryItem("glass", 2)
	xPlayer.addInventoryItem('scrapmetal', 7)
    xPlayer.addInventoryItem("rubber", 6)
end)

RegisterServerEvent("get:PackedMeal")
AddEventHandler("get:PackedMeal", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('aluminium', 3)
	xPlayer.removeInventoryItem('copper', 4)
	xPlayer.removeInventoryItem('electronics', 4)
	xPlayer.removeInventoryItem('plastic', 4)
	xPlayer.removeInventoryItem('steel', 4)
	xPlayer.removeInventoryItem('glass', 4)
	xPlayer.removeInventoryItem('scrapmetal', 4)
	xPlayer.removeInventoryItem('rubber', 4)
	xPlayer.addMoney(33000)
end)

ESX.RegisterServerCallback('chopshop:grabList', function(source, cb)
	local id = source
	table.insert(ids, id)
	if carsToChop[1] ~= nil then 
		cb(carsToChop)
	else
		local random = math.random(1,15)
		local random2 = math.random(1,15)
		while random == random2 do 
			random2 = math.random(1,15)
		end
		local random3 = math.random(1,15)
		while random2 == random3 or random == random3 do 
			random3 = math.random(1,15)
		end
		local random4 = math.random(1,15)
		while random3 == random4 or random == random4 or random2 == random4  do 
			random4 = math.random(1,15)
		end
		carsToChop = {CarList[random],CarList[random2],CarList[random3],CarList[random4]}	
		cb(carsToChop)
	end
end)

RegisterNetEvent('chopshop:updateList')
AddEventHandler('chopshop:updateList', function(index)
	carsToChop[index]= ''
	for _, id in pairs(ids) do
		TriggerClientEvent('chopshop:getList', id)
	end
end)