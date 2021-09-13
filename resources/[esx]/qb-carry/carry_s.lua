ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('carryped', function(source)
    TriggerClientEvent("carryAI", source)
end)

RegisterCommand('carry', function(source)
    TriggerClientEvent('carry:command', source)
end)

RegisterCommand('dice', function(source, args)
    if args[1] and args[1] ~= "" then
        TriggerClientEvent("roll", source,args[1],6)
    else
        TriggerClientEvent("roll", source,1,6)
    end
end)

RegisterServerEvent("showRoll")
AddEventHandler('showRoll', function(str)
    TriggerClientEvent("showRoll", -1, source, str)
end)

RegisterServerEvent('carry:sync')
AddEventHandler('carry:sync', function(target)
	TriggerClientEvent('carry:syncTarget', target, source)
	TriggerClientEvent('carry:syncMe', source)
end)

RegisterServerEvent('carry:stop')
AddEventHandler('carry:stop', function(target, putInVeh)
	TriggerClientEvent('carry:stop', target, putInVeh)
end)
