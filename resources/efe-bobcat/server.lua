ESX = nil
local lootTable = {[1] = {
					weapons = {'WEAPON_STICKYBOMB', 'WEAPON_PISTOL50', 'WEAPON_HEAVYSNIPER', 'disc_ammo_snp_large'},
					count = {4, 2, 1, 2}
}
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('efe:bobcatpolice', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	CopsConnected = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end
	cb(CopsConnected)
end)

RegisterServerEvent("efe:syncPedsSV")
AddEventHandler("efe:syncPedsSV", function(peds, players)

    for _, p in pairs(players) do
		print(p)
		xPlayer = ESX.GetPlayerFromId(tonumber(p))
		TriggerClientEvent('efe:syncPeds',tonumber(p), peds)
	end
end)


RegisterServerEvent("efe:particleserver")
AddEventHandler("efe:particleserver", function(method)
    TriggerClientEvent("efe:ptfxparticle", -1, method)
end)

RegisterServerEvent("efe:particleserversec")
AddEventHandler("efe:particleserversec", function(method)
    TriggerClientEvent("efe:ptfxparticlesec", -1, method)
end)

RegisterServerEvent("efe:silahverSV")
AddEventHandler("efe:silahverSV", function(number)
	xPlayer = ESX.GetPlayerFromId(source)
	for i, v in pairs(lootTable[number].weapons) do
		xPlayer.addInventoryItem(v,lootTable[number].count[i])
	end
	
end)

