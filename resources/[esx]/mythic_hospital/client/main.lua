ESX = nil
local hospitalCheckin = { x = -436.2, y = -325.72, z = 34.91, h = 331.78 }
local pillboxTeleports = {
    { x = 325.48892211914, y = -598.75372314453, z = 43.291839599609, h = 64.513374328613, text = 'Press ~INPUT_CONTEXT~ ~s~to go to lower Pillbox Entrance' },
    { x = 355.47183227539, y = -596.26495361328, z = 28.773477554321, h = 245.85662841797, text = 'Press ~INPUT_CONTEXT~ ~s~to enter Pillbox Hospital' },
    { x = 359.57849121094, y = -584.90911865234, z = 28.817169189453, h = 245.85662841797, text = 'Press ~INPUT_CONTEXT~ ~s~to enter Pillbox Hospital' },
}

local bedOccupying = nil
local bedOccupyingData = nil

local inBedDict = 'savecouch@'
local inBedAnim = 't_sleep_loop_couch'
local getOutAnim = 'sleep_getup_rubeyes'
local clockedIn = false
local notify = false
function PrintHelpText(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function LeaveBed()
    TaskPlayAnim(PlayerPedId(), inBedDict , getOutAnim ,8.0, -8.0, -1, 0, 0, false, false, false )
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent('mythic_hospital:server:LeaveBed', bedOccupying)

    bedOccupying = nil
    bedOccupyingData = nil
end

RegisterNetEvent('mythic_hospital:client:RPCheckPos')
AddEventHandler('mythic_hospital:client:RPCheckPos', function()
    TriggerServerEvent('mythic_hospital:server:RPRequestBed', GetEntityCoords(PlayerPedId()))
end)

RegisterNetEvent('mythic_hospital:client:RPSendToBed')
AddEventHandler('mythic_hospital:client:RPSendToBed', function(id, data)
    bedOccupying = id
    bedOccupyingData = data

    SetEntityCoords(PlayerPedId(), data.x, data.y, data.z - 2.0)
    RequestAnimDict(inBedDict)
    while not HasAnimDictLoaded(inBedDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), inBedDict , inBedAnim ,8.0, -8.0, -1, 1, 0, false, false, false )
    SetEntityHeading(PlayerPedId(), data.h - 90.0)

    Citizen.CreateThread(function()
        while bedOccupyingData ~= nil do
            Citizen.Wait(1)
            --PrintHelpText('Press ~INPUT_VEH_DUCK~ to get up')
            exports["np-ui"]:showInteraction('[X] To Get Up!')
            notify = true
            if IsControlJustReleased(0, 73) then
                --LeaveBed()
                exports["np-ui"]:hideInteraction()
                TriggerServerEvent('mythic_hospital:server:EnteredBed')
                bedOccupyingData = nil
            end
        end
    end)
end)

RegisterNetEvent('mythic_hospital:client:SendToBed')
AddEventHandler('mythic_hospital:client:SendToBed', function(id, data)
    bedOccupying = id
    bedOccupyingData = data
    print(data.z)
    SetEntityCoords(PlayerPedId(), data.x, data.y, data.z - 2.0)
    RequestAnimDict(inBedDict)
    while not HasAnimDictLoaded(inBedDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), inBedDict , inBedAnim ,8.0, -8.0, -1, 1, 0, false, false, false )
    SetEntityHeading(PlayerPedId(), data.h - 90.0)

    Citizen.CreateThread(function ()
        Citizen.Wait(5)
        local player = PlayerPedId()

        exports['mythic_notify']:DoHudText('inform', 'Doctors Are Treating You')
        Citizen.Wait(5000)
        TriggerServerEvent('mythic_hospital:server:EnteredBed')
    end)
end)

RegisterNetEvent('mythic_hospital:client:FinishServices')
AddEventHandler('mythic_hospital:client:FinishServices', function()
    if IsEntityDead(PlayerPedId()) then
        TriggerEvent("esx_ambulancejob:revive")
        TriggerEvent('mythic_hospital:client:RemoveBleed')
        TriggerEvent('mythic_hospital:client:ResetLimbs')
        exports['mythic_notify']:DoHudText('inform', 'You\'ve Been Treated & Billed')
        LeaveBed()
    else
        --SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
        TriggerEvent("esx_ambulancejob:revive")
        TriggerEvent('mythic_hospital:client:RemoveBleed')
        TriggerEvent('mythic_hospital:client:ResetLimbs')
        exports['mythic_notify']:DoHudText('inform', 'You\'ve Been Treated & Billed')
        LeaveBed()
    end
end)

RegisterNetEvent('mythic_hospital:client:ForceLeaveBed')
AddEventHandler('mythic_hospital:client:ForceLeaveBed', function()
    LeaveBed()
end)

RegisterNetEvent('mythic_hospital:client:clockIn')
AddEventHandler('mythic_hospital:client:clockIn', function()
    local awaitService
	ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
		if not isInService then
				ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
					if not canTakeService then
						ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
					else
						awaitService = true
						clockedIn = true
						exports['mythic_notify']:DoHudText('inform', 'You have clocked in')
					end
				end, 'mount_zonah')
		else
			TriggerServerEvent('esx_service:disableService', 'mount_zonah')
			exports['mythic_notify']:DoHudText('inform', 'you have clocked out')
			awaitService = true
		end
	end, 'mount_zonah')

	while awaitService == nil do
		Citizen.Wait(5)
	end

	-- if we couldn't enter service don't let the player get changed
	if not awaitService then
		return
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        --if not exports['mythic_base']:GetIfChoosing() then
            local plyCoords = GetEntityCoords(PlayerPedId(), 0)
            local distance = #(vector3(hospitalCheckin.x, hospitalCheckin.y, hospitalCheckin.z) - plyCoords)
            if distance < 10 then
                DrawMarker(27, hospitalCheckin.x, hospitalCheckin.y, hospitalCheckin.z - 0.99, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.0, 1, 157, 0, 155, false, false, 2, false, false, false, false)

                if not IsPedInAnyVehicle(PlayerPedId(), true) then
                    if distance < 1 then
                        --PrintHelpText('Press ~INPUT_CONTEXT~ ~s~to check in')
                        exports["np-ui"]:showInteraction('[E] To check in')
                        notify = true
                        if IsControlJustReleased(0, 54) then
                            exports["np-ui"]:hideInteraction()
                            notify = false
                            if (GetEntityHealth(PlayerPedId()) < 200) or (IsInjuredOrBleeding()) then
                                        DetachEntity(PlayerPedId(), true, true)
                                        TriggerServerEvent('mythic_hospital:server:RequestBed')          
                            else
                                exports['mythic_notify']:DoHudText('error', 'You do not need medical attention')
                            end
                        end
                    end
                end
            else
                if notify then 
                    exports["np-ui"]:hideInteraction()
                    notify = false
                end
                Citizen.Wait(1000)
            end
        --end
    end
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(
            "esx:getSharedObject",
            function(obj)
                ESX = obj
            end
        )
        Citizen.Wait(0)
    end
    exports["bt-target"]:AddBoxZone("MountZonahClockIn", vector3(-432.63,-318.2,34.91), 0.4, 0.6, {
		name="MountZonahClockIn",
		heading=28.36,
		debugPoly=true,
		minZ=33.75,
		maxZ=35.91

		}, {
			options = {
				{
					event = "mythic_hospital:client:clockIn",
					icon = "far fa-clipboard",
					label = "Sign In/Out",
				},
			},
			job = {"mount_zonah"},
			distance = 1.5
	})
    TriggerServerEvent('esx_service:activateService', 'mount_zonah', 20)
end)