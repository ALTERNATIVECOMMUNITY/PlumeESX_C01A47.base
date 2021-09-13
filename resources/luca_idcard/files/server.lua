print("^0-------------------------------------------------------^7")
print("^6Author ^0- ^6Luca845LP^7")
print("^4Version ^0- ^41.0.0^7")
print("^2Resource Name ^0- ^2luca_idcard^7")
print("^1Support ^0- ^1discord.gg/HaWdXdSmtg^7")
print("^0-------------------------------------------------------^7")

local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('luca_idcard:open')
AddEventHandler('luca_idcard:open', function(ID, targetID, type)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source
	local show       = false

	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = identifier},
			function (licenses)
					for i=1, #licenses, 1 do
						for k,v in ipairs(Licenses) do
							if type == v.Type then
							  if v.Needed then
								if licenses[i].type == v.Needed1 or licenses[i].type == v.Needed2 or licenses[i].type == v.Needed3 then
									show = true
									local arrays = {
										user = user,
										licenses = licenses,
										background = v.Background
									}
									TriggerClientEvent('luca_idcard:open', _source, arrays, type)
								end
							  else
								show = true
								local arrays = {
									user = user,
									licenses = licenses,
									background = v.Background
								}
								TriggerClientEvent('luca_idcard:open', _source, arrays, type)
							  end
							end
						end
					end

				if show then
				else
					TriggerClientEvent('esx:showNotification', _source, Config.NoLicense)
				end
			end)
		end
	end)
end)
