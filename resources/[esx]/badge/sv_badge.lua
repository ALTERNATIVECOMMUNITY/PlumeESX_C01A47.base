local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('badge:open')
AddEventHandler('badge:open', function(ID, targetID, type)

	local xPlayer = ESX.GetPlayerFromId(ID)
	local name = xPlayer.getName()
	print(xPlayer.get('dateofbirth'))
	local data = {
		name = name,
		dob = tostring(xPlayer.get('dateofbirth'))
	}

	TriggerClientEvent('badge:open', targetID, data)
	TriggerClientEvent('badge:shot', targetID, source )
end)
--[[
WSCore.Functions.CreateUseableItem('badge', function(source, item)
  local Player = WSCore.Functions.GetPlayer(source)
  if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
    TriggerClientEvent('badge:openPD', source, true)
  else
	TriggerClientEvent('WSCore:Notify', source,"You are not a police!", "error")
  end
end)
]]--
ESX.RegisterUsableItem('badge', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local job = xPlayer.getJob()
	if (job.name == "police") then
		TriggerClientEvent('badge:openPD', source, true)
	else
		print('not an officer')
	end
	
	
end)