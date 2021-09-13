ESX = nil
local availableJobs = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT name, label FROM jobs WHERE whitelisted = @whitelisted', {
		['@whitelisted'] = false
	}, function(result)
		for i=1, #result, 1 do
			table.insert(availableJobs, {
				job = result[i].name,
				label = result[i].label
			})
		end
	end)
end)



ESX.RegisterServerCallback('esx_joblisting:getJobsList', function(source, cb)
	cb(availableJobs)
end)

TriggerEvent('es:addGroupCommand', 'setjob2', 'admin', function(source, args, user)
	if ESX.DoesJobExist(args[1], args[2]) then
		TriggerEvent('esx_joblisting:setJobPlayer', args[1], args[3], args[2], false)
	end
end)

RegisterServerEvent('esx_joblisting:setJob')
AddEventHandler('esx_joblisting:setJob', function(job)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		for k,v in ipairs(availableJobs) do
			if v.job == job then
				xPlayer.setJob(job, 0)
				break
			end
		end
	end
end)
--[[
TriggerEvent('es:addGroupCommand', 'setjob', 'admin', function(source, args, user)
	if ESX.DoesJobExist(args[1], args[2]) then
		TriggerEvent('esx_joblisting:setJobPlayer', args[1], args[3], args[2], false)
	end
end)
]]--
RegisterServerEvent('esx_joblisting:setJobPlayer')
AddEventHandler('esx_joblisting:setJobPlayer', function(job, player, grade, fire)
	local xPlayer = ESX.GetPlayerFromId(tonumber(player))
	print(xPlayer)
	if xPlayer then
		if fire ~= true then
			if grade == nil then
				xPlayer.setJob(job, 0)
			else
				xPlayer.setJob(job, grade)
			end	
			TriggerClientEvent('okokNotify:Alert', tonumber(player), job, "You have been hired!", 10000, 'success')
			TriggerClientEvent('okokNotify:Alert', source, job, "You have hired an employee!", 10000, 'success')	
		else
			if xPlayer.getJob().name == job then
				xPlayer.setJob('unemployed', 0)
				TriggerClientEvent('okokNotify:Alert', tonumber(player), job, "You have been fired!", 10000, 'warning')
				TriggerClientEvent('okokNotify:Alert', source, job, "You have fired an employee!", 10000, 'success')		
			end
		end
	end
end)

RegisterServerEvent('esx_joblisting:promotePlayer')
AddEventHandler('esx_joblisting:promotePlayer', function(job, player, grade)
	local xPlayer = ESX.GetPlayerFromId(tonumber(player))
	if xPlayer then
		xPlayer.setJob(job, grade)
		TriggerClientEvent('okokNotify:Alert', tonumber(player), job, "You have been promoted!", 10000, 'success')
		TriggerClientEvent('okokNotify:Alert', source, job, "You have promoted an employee!", 10000, 'success')	
	end
end)
