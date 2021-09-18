ESX = nil
local PlayerData = {}

local isAllowedToTow = true
local vehicleOnTowTruck = 0
local impoundList = {}
local xoffset = 0.0
local yoffset = 0.0
local zoffset = 0.0
local clockedIn = false

local playerped = PlayerPedId()
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
                   
        end)
        Citizen.Wait(1)
    end
    ESX.UI.HUD.SetDisplay(0)
    PlayerData = ESX.GetPlayerData()
    calculateAccess()
    TriggerServerEvent('esx_service:activateService', 'towing', 10)
end)

Citizen.CreateThread(function()
	exports["bt-target"]:AddBoxZone("TowDuty", vector3(-192.54, -1161.95, 23.2), 0.4, 0.6, {
		name="TowDuty",
		heading=83.71,
		debugPoly=false,
		minZ=23.3,
		maxZ=23.7
		}, {
			options = {
				{
					event = "erp_towscript:clockIn",
					icon = "far fa-clipboard",
					label = "Sign In/Out",
				},
			},
			job = {"towing"},
			distance = 3.0
	})
    exports["bt-target"]:AddBoxZone("TowInventory", vector3(-183.8, -1166.5, 23.67), 0.4, 1.0, {
		name="TowInventory",
		heading=269.1,
		debugPoly=false,
		minZ=23.3,
		maxZ=24.2
		}, {
			options = {
				{
					event = "erp_towscript:openStorage",
					icon = "fas fa-box-open",
					label = "Open Storage",
				},
			},
			job = {"towing"},
			distance = 3.0
	})
end)

RegisterCommand("tow", function()
    TriggerEvent("erp_towscript:tow")
end, false)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    calculateAccess()
end)

RegisterNetEvent('erp_towscript:openStorage')
AddEventHandler('erp_towscript:openStorage', function(job)
    exports["mf-inventory"]:openOtherInventory('elitetowStorage')
end)

function calculateAccess()
    if Config.JobRestriction then
        if PlayerData.job.name:lower() == 'towing' then
            isAllowedToTow = true
        else
            isAllowedToTow = false
        end
    else 
        isAllowedToTow = true
    end
end

RegisterNetEvent('erp_towscript:clockIn')
AddEventHandler('erp_towscript:clockIn', function()
    local awaitService
	ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
		if not isInService then

			if Config.MaxInService == -1 then
				ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
					if not canTakeService then
						ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
					else
						awaitService = true
						clockedIn = true
						TriggerEvent('esx_policejob:updateBlip')
						exports['mythic_notify']:DoHudText('inform', 'You clocked-in')
					end
				end, 'towing')
			else 
				ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
					if not canTakeService then
						ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
					else
						awaitService = true
						clockedIn = true
						TriggerEvent('esx_policejob:updateBlip')
						exports['mythic_notify']:DoHudText('inform', 'You clocked-in')
					end
				end, 'towing')
			end

		else
			TriggerServerEvent('esx_service:disableService', 'towing')
			exports['mythic_notify']:DoHudText('inform', 'You clocked-out')
			awaitService = true
            clockedIn = false
		end
	end, 'towing')

	while awaitService == nil do
		Citizen.Wait(5)
	end

	-- if we couldn't enter service don't let the player get changed
	if not awaitService then
		return
	end
end)

RegisterNetEvent('erp_towscript:addToList')
AddEventHandler('erp_towscript:addToList', function(name, plate, loc)
    vehicle = {name = name, loc = loc, plate = plate}
    table.insert(impoundList, vehicle)
end)

RegisterNetEvent('erp_towscript:depositRadial')
AddEventHandler('erp_towscript:depositRadial', function()
    
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player)
    local plate = GetVehicleNumberPlateText(vehicle)
    local owned = false
    local await = true
    if vehicle ~= nil and clockedIn then
        ESX.TriggerServerCallback('esx_advancedgarage:isVehicleOwned', function(isOwned)
            print('made it')
            if isOwned then
                exports['progressBars']:startUI(3000, "Impounding Vehicle")
                Citizen.Wait(3000)
                ESX.Game.DeleteVehicle(vehicle)
                TriggerServerEvent('erp_towscript:payPlayer', 250)
                exports['mythic_notify']:DoHudText('success', 'Vehicle Impounded')
                owned = true   
            end
            await = false
        end, plate, 'impoundParking')
        while await do
            print('waiting')
            Citizen.Wait(200)
        end
        if not owned then
            exports['progressBars']:startUI(3000, "Impounding Vehicle")
            Citizen.Wait(3000)
            exports['mythic_notify']:DoHudText('success', 'Vehicle Impounded')
            ESX.Game.DeleteVehicle(vehicle)
            TriggerServerEvent('erp_towscript:payPlayer', 200) 
        end
    end
end)



RegisterNetEvent('erp_towscript:tow')
AddEventHandler('erp_towscript:tow', function()
    print('triggered')
    if isAllowedToTow and clockedIn then

        local vehicle = GetLastDrivenVehicle()

        
        if isThisAFlatbed(vehicle) then

            local coordA = GetEntityCoords(playerped)
            local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, Config.VehicleRange, 0.0)
            local targetVehicle = ESX.Game.GetClosestVehicle(coordA)
            

            if vehicleOnTowTruck == 0 or vehicleOnTowTruck == nil then
                
                    if targetVehicle ~= 0 and targetVehicle ~= nil then
                        if vehicle ~= targetVehicle then
                            if not isThisVehicleBlacklisted(targetVehicle) then
                                --if not IsEntityUpsidedown(targetVehicle) then
                                exports["onyxLocksystem"]:givePlayerKeys(GetVehicleNumberPlateText(targetVehicle))
                                    if GetPedInVehicleSeat(targetVehicle, -1) == 0 and
                                        GetPedInVehicleSeat(targetVehicle, 0) == 0 and
                                        GetPedInVehicleSeat(targetVehicle, 1) == 0 and
                                        GetPedInVehicleSeat(targetVehicle, 2) == 0 then
                                        local distanceBetweenVehicles =
                                            GetDistanceBetweenCoords(GetEntityCoords(targetVehicle),
                                                GetEntityCoords(vehicle), false)

                                        if distanceBetweenVehicles <= Config.VehicleRange then
                                            if Config.OnlyStoppedEngines and IsVehicleStopped(targetVehicle) then

                                                NetworkRequestControlOfEntity(targetVehicle)
                                                while not NetworkHasControlOfEntity(targetVehicle) do
                                                    Citizen.Wait(5)
                                                end
                                                NetworkRequestControlOfEntity(vehicle)
                                                while not NetworkHasControlOfEntity(vehicle) do
                                                    Citizen.Wait(5)
                                                end

                                                AttachEntityToEntity(targetVehicle, vehicle,
                                                    GetEntityBoneIndexByName(vehicle, 'bodyshell'), xoffset, yoffset,
                                                    zoffset, 0, 0, 0, 1, 1, 0, 1, 0, 1)
                                                    vehicleOnTowTruck = NetworkGetNetworkIdFromEntity(targetVehicle)

                                                ESX.ShowNotification(_U('vehicle_attached'))

                                            elseif Config.OnlyStoppedEngines and not IsVehicleStopped(targetVehicle) then
                                                ESX.ShowNotification(_U('engine_not_stopped'))
                                            else
                                                NetworkRequestControlOfEntity(targetVehicle)
                                                while not NetworkHasControlOfEntity(targetVehicle) do
                                                    Citizen.Wait(5)
                                                end
                                                NetworkRequestControlOfEntity(vehicle)
                                                while not NetworkHasControlOfEntity(vehicle) do
                                                    Citizen.Wait(5)
                                                end

                                                AttachEntityToEntity(targetVehicle, vehicle,
                                                    GetEntityBoneIndexByName(vehicle, 'bodyshell'), xoffset, yoffset,
                                                    zoffset, 0, 0, 0, 1, 1, 1, 0, 0, 1)
                                                    vehicleOnTowTruck = NetworkGetNetworkIdFromEntity(targetVehicle)
                                                ESX.ShowNotification(_U('vehicle_attached'))
                                            end
                                        else
                                            ESX.ShowNotification(_U('vehicle_to_far_away'))
                                        end
                                    else
                                        ESX.ShowNotification(_U('vehicle_not_empty'))
                                    end
                                --else
                                    --ESX.ShowNotification(_U('vehicle_flipped'))
                                --end
                            else
                                ESX.ShowNotification(_U('vehicle_blacklisted'))
                            end
                        else
                            ESX.ShowNotification(_U('cant_tow_yourself'))
                        end
                    else
                        ESX.ShowNotification(_U('no_vehicle_found'))
                    end
               
            else

                if GetVehiclePedIsIn(PlayerPedId(), false) then 
                if isThisAFlatbed(GetVehiclePedIsIn(PlayerPedId(), false)) then 
                vehicleOnTowTruck = NetworkGetEntityFromNetworkId(vehicleOnTowTruck)

                NetworkRequestControlOfEntity(vehicle)
                while not NetworkHasControlOfEntity(vehicle) do
                    Citizen.Wait(5)
                end
                NetworkRequestControlOfEntity(vehicleOnTowTruck)
                while not NetworkHasControlOfEntity(vehicleOnTowTruck) do
                    Citizen.Wait(5)
                end

                DetachEntity(vehicleOnTowTruck)

                local newVehiclesCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, Config.FlatbedDistance, 0.0)
                SetEntityCoords(vehicleOnTowTruck, newVehiclesCoords["x"], newVehiclesCoords["y"], newVehiclesCoords["z"], 1, 0, 0, 1)
                SetVehicleOnGroundProperly(vehicleOnTowTruck)

                ESX.ShowNotification(_U('vehicle_detached'))

                vehicleOnTowTruck = 0
            else 
                ESX.ShowNotification(_U('not_a_towtruck'))
            end
        else 
            ESX.ShowNotification(_U('not_a_towtruck'))
        end
            end

        else
            ESX.ShowNotification(_U('not_a_towtruck'))

        end
    else
        ESX.ShowNotification(_U('no_permissions'))
    end
end)

function getVehicleInDirection(coordFrom, coordTo)
    
        local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z,10, PlayerPedId(), 0)
        local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        return vehicle
    
end

function isThisAFlatbed(vehicle)
    local isValid = false
    for model, posOffset in pairs(Config.Flatbeds) do
       
        if IsVehicleModel(vehicle, model) then
            
            xoffset = posOffset.x
            yoffset = posOffset.y
            zoffset = posOffset.z
            isValid = true
            break
        end
    end
    return isValid
end

function isThisVehicleBlacklisted(vehicle)
    local isBlacklisted = false
    for model in pairs(Config.TowBlacklist) do
        if GetHashKey(model) == GetHashKey(vehicle) then
            isBlacklisted = true
            break
        end
    end
    return isBlacklisted
end
