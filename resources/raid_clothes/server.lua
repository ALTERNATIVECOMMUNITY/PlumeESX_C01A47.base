ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('raid_clothes:save')
AddEventHandler('raid_clothes:save', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET `skin` = @data WHERE identifier = @identifier',
	{
		['@data']       = json.encode(data),
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('raid_clothes:loadclothes')
AddEventHandler('raid_clothes:loadclothes', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user = users[1]
		local skin = nil

		if user.skin ~= nil then
			skin = json.decode(user.skin)
		end

		TriggerClientEvent('raid_clothes:loadclothes', skin)
	end)


end)

RegisterServerEvent('raid_clothes:sendRemove')
AddEventHandler('raid_clothes:sendRemove', function(id)
	TriggerClientEvent('raid_clothes:policeRemoveProps', id)
end)

ESX.RegisterServerCallback('raid_clothes:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user = users[1]
		local skin = nil


		if user.skin ~= nil then
			skin = json.decode(user.skin)
		end

		cb(skin)
	end)
end)
--added below this-----
ESX.RegisterServerCallback('raid_clothes:getOutfits', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local savedOutfits = {}
	MySQL.Async.fetchAll('SELECT * FROM outfits WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(outfits)
		for i ,v in pairs(outfits) do
			local skin = json.decode(v.skin)
			skin['name'] = v.name
			table.insert(savedOutfits, skin)
		end
		cb(savedOutfits)
	end)
end)

RegisterServerEvent('raid_clothes:outfitsDelete')
AddEventHandler('raid_clothes:outfitsDelete', function(name)
	print(name)
	local xPlayer = ESX.GetPlayerFromId(source)
	print(xPlayer.identifier)
	MySQL.Async.execute('DELETE FROM outfits WHERE name = @name AND identifier = @owner', {
		['@owner'] = xPlayer.identifier,
		['@name'] = name
	}, function(rowsChanged)
		print('deleted outfit')
	end)	
end)

RegisterServerEvent('raid_clothes:saveOutfit')
AddEventHandler('raid_clothes:saveOutfit', function(outfit)
	print(outfit.model)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('INSERT INTO outfits (identifier, skin, name) VALUES (@owner, @outfit, @name)', {
		['@owner'] = xPlayer.identifier,
		['@outfit'] = json.encode({model = outfit.model, hairColor = outfit.hairColor, headOverlay = outfit.headOverlay, headStructure = outfit.headStructure, drawables = outfit.drawables, props = outfit.props, drawtextures = outfit.drawtextures, proptextures = outfit.proptextures}),
		['@name'] = outfit.name
	}, function(rowsChanged)
		xPlayer.showNotification('Saved outfit!')
	end)
end)

function MySQLAsyncExecute(query)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll(query, {}, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end


