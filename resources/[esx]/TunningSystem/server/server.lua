ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)

if Config.WebHook and Config.WebHook ~= "" then
	function sendToDiscord(name,message,color)
		local DiscordWebHook = Config.WebHook

		local embeds = {
			{
			  ["title"] = message,
			  ["type"] = "rich",
			  ["color"] = color,
			}
		}

	if message == nil or message == '' then return false end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers)end, 'POST', json.encode({ username = name,embeds = embeds}), {['Content-Type'] = 'application/json'})
	end
end

ESX.RegisterServerCallback('Bennys:Used', function(source,cb,id,netid)
	local enviar = false
	if not Config.TunningLocations[id].used then
		enviar = true
		if SendUsed then
			SendUsed(id,source)
		else
			print("TunningSystem: READ README, YOUR TRANSID IS INVALID, SCRIPT WON'T WORK")
		end
	end
    cb(enviar)
	while Config.TunningLocations[id].used do
		Wait(10000)
		if GetPlayerPing(source) <= 0 then
			DeleteEntity(NetworkGetEntityFromNetworkId(netid))
			if SendUsed then
				SendUsed(id,false)
			else
				print("TunningSystem: READ README, YOUR TRANSID IS INVALID, SCRIPT WON'T WORK")
			end
		end
	end
end)

RegisterServerEvent('Bennys:Used')
AddEventHandler('Bennys:Used', function(id)
	local _source = source
	if Config.TunningLocations[id].used == _source then
		if SendUsed then
			SendUsed(id,false)
		else
			print("TunningSystem: READ README, YOUR TRANSID IS INVALID, SCRIPT WON'T WORK")
		end
	else
		--cheateeer
	end
end)

RegisterServerEvent('Mechanic:PayModifications')
AddEventHandler('Mechanic:PayModifications', function(preco,id,vehprops)
	local config = Config.TunningLocations[id]
	local _source = source
	local pago = false
	local xPlayer = ESX.GetPlayerFromId(_source)
	if config.used == _source then
		local permitido = true
		if config.job then
			permitido = false
			if xPlayer.getJob().name == config.job then
				print('have mech job')
				permitido = true
			end
		end
		if permitido then
			if config.society and config.job then
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..config.job, function(account)
					if account.money >= preco then
						account.removeMoney(preco)
						if config.societypercentage then
							if config.societypercentage >= 0 or config.societypercentage < 100 then
								local playerpercentage = 1.0-(config.societypercentage/100)
								local playerwin = playerpercentage*preco
								if playerwin > 0 then
									xPlayer.addAccountMoney("bank",playerwin)
									--you won playerwin €
								end
							end
						end
						pago = true
					else
						print('no monies')--The society don't have money
					end
				end)
			else
				if xPlayer.getAccount("bank").money >= preco then
					pago = true
					xPlayer.removeAccountMoney("bank",preco)
				else
					print('no monies')--You don't have moneyyyyy
				end
			end
		else
			--cheater
		end
	else
		--cheater probably
	end
	if pago then
		SaveVehicle(vehprops)
		if Config.WebHook and Config.WebHook ~= "" then
			sendToDiscord('Mechanic Upgrade/Tuning Logs', "[Upgrade/Tuning Logs]\n\nTotal: ".. preco .."\n\nVehicle Plate Number: [".. vehprops.plate .."]\nMechanic that worked on the vehicle: " .. xPlayer.name, 11750815)
		end
	end
	TriggerClientEvent("Bennus:PayAfter",_source,pago)
end)

if Config.MysqlAsync then
	function SaveVehicle(vehprops)	
		MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
			['@plate'] = vehprops.plate
		}, function(result)
			if result[1] then
				local vehicle = json.decode(result[1].vehicle)

				if vehprops.model == vehicle.model then
					MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
						['@plate'] = vehprops.plate,
						['@vehicle'] = json.encode(vehprops)
					})
					print('triggered')
					TriggerEvent("esx_lscustom:refreshOwnedVehicle",vehprops)
				else
					--cheateeeer
				end
			end
		end)
	end
else
	function SaveVehicle(vehprops)	
		exports.ghmattimysql:execute('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
			['@plate'] = vehprops.plate
		}, function(result)
			if result[1] then
				local vehicle = json.decode(result[1].vehicle)

				if vehprops.model == vehicle.model then
					exports.ghmattimysql:execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
						['@plate'] = vehprops.plate,
						['@vehicle'] = json.encode(vehprops)
					})
					TriggerEvent("esx_lscustom:refreshOwnedVehicle",vehprops)
				else
					--cheateeeer
				end
			end
		end)
	end
end