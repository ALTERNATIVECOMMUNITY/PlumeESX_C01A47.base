local CurrentActionData, PlayerData, userProperties, this_Garage, vehInstance, BlipList, PrivateBlips, JobBlips = {}, {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker = false
local LastZone, CurrentAction, CurrentActionMsg
ESX = nil
local displayed = false
local vehToSpawn = {}
local pgarage = false
local supers = false
local totalCars 
local locBooleans = {policeGarage1= false, policeGarage2 = false, policeGarage3 = false, apartmentGarage1 = false, apartmentGarage2 = false, apartmentGarage3 = false, apartmentGarage4 = false,
elginGarage1 = false, elginGarage2 = false, elginGarage3 = false, elginGarage4 = false, paletoGarage1 = false, paletoGarage2 = false, paletoGarage3 = false, paletoGarage4 = false, sandyGarage1 = false,
sandyGarage2 = false, sandyGarage3 = false, sandyGarage4 = false, impoundParking1 = false, policeGarage1 = false, policeGarage2 = false, policeGarage3 = false, towGarage = false, ambulanceGarage1 = false, ambulanceGarage2 = false} --Table of loc booleans
local locSpawnTable = {policeGarage1= vector3(445.7275, -991.5033, 25.6908), policeGarage2 = vector3(445.9648,-988.9055,25.6908), policeGarage3 = vector3(446.2286,-994.2879,25.6908), 
apartmentGarage1 = vector3(-297.5900, -989.6500, 31.0800), apartmentGarage2 = vector3(-301.2132,-988.7868,31.06592), apartmentGarage3 = vector3(-304.7736,-987.5472,31.06592), 
apartmentGarage4 = vector3(-308.3736,-986.4132,31.06592), elginGarage1 = vector3(247.7143,-758.3735,30.4), elginGarage2 = vector3(251.3539, -759.1121, 30.4), 
elginGarage3 = vector3(254.2945,-760.9319,30.4), elginGarage4 = vector3(257.4857, -762, 30.4), paletoGarage1 = vector3(145.73, 6602.37, 31.8), paletoGarage2 = vector3(151.04, 6597.12, 31.84), 
paletoGarage3 = vector3(151.12, 6609.01, 31.87), paletoGarage4 = vector3(145.48, 6612.71, 31.82), sandyGarage1 = vector3(1949.47, 3759.19, 32.21), sandyGarage2 = vector3(1953.08, 3760.69,32.2), 
sandyGarage3 = vector3(1956.13, 3762.66, 32.2),sandyGarage4 = vector3(1959.19, 3764.9, 32.2), impoundParking1 = vector3(-152.44,-1169.88, 23.77), policeGarage1 = vector3(445.7275, -991.5033, 25.6908), 
policeGarage2 = vector3(445.9648,-988.9055,25.6908), policeGarage3 = vector3(446.2286,-994.2879,25.6908), towGarage = vector3(-209.75,-1169.98, 23.04), ambulanceGarage1 = vector3(-435.87,-350.545, 24.224), ambulanceGarage2 = vector3(-439.64,-352.10,24.22)}
local headingTable = {policeGarage1= 90.0, policeGarage2 = 90.0, policeGarage3 = 90.0, apartmentGarage1 = 158.0, apartmentGarage2 = 158.0, apartmentGarage3 = 158.0, apartmentGarage4 = 158.0,
elginGarage1 = 160.0, elginGarage2 = 160.0, elginGarage3 = 160.0, elginGarage4 = 160.0, paletoGarage1 = 0.0, paletoGarage2 = 0.0, paletoGarage3 = 180.0, paletoGarage4 = 180.0, sandyGarage1 = 210.0
, sandyGarage2 = 210.0, sandyGarage3 = 210.0, sandyGarage4= 210.0, impoundParking1 = 89.78,  policeGarage1 = 0.0, policeGarage2 = 0.0, policeGarage3 = 0.0, towGarage = 83.01, ambulanceGarage1 = 195.45, ambulanceGarage2 = 195.45}
local locToSpawn 
local headingToSpawn 
local locations = {policeGarage= 'policeGarage', apartmentGarage= 'apartmentGarage', elginGarage= 'elginGarage', paletoGarage= 'paletoGarage', sandyGarage= 'sandyGarage', impoundParking = 'impoundParking', towGarage = 'towGarage', ambulanceGarage = 'ambulanceGarage'}
local currentLoc
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	CreateBlips()
	RefreshJobBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	if Config.Pvt.Garages then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedProperties', function(properties)
			userProperties = properties
			DeletePrivateBlips()
			RefreshPrivateBlips()
		end)
	end

	ESX.PlayerData = xPlayer

	RefreshJobBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
	DeleteJobBlips()
	RefreshJobBlips()
end)

RegisterNetEvent('esx_advancedgarage:getPropertiesC')
AddEventHandler('esx_advancedgarage:getPropertiesC', function(xPlayer)
	if Config.Pvt.Garages then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedProperties', function(properties)
			userProperties = properties
			DeletePrivateBlips()
			RefreshPrivateBlips()
		end)

		ESX.ShowNotification(_U('get_properties'))
		TriggerServerEvent('esx_advancedgarage:printGetProperties')
	end
end)

RegisterNetEvent('bt-polyzone:enter')
AddEventHandler('bt-polyzone:enter', function(name)
	if locBooleans[name] ~= nil then
        locBooleans[name] = true
		locToSpawn = locSpawnTable[name]
		headingToSpawn = headingTable[name]
		local location = string.gsub(name, "%d", "")
		currentLoc = locations[location]
		print(locToSpawn)
    end
end)

RegisterNetEvent('bt-polyzone:exit')
AddEventHandler('bt-polyzone:exit', function(name)
	if locBooleans[name] ~= nil then
		locBooleans[name]=false
		locToSpawn = nil
		headingToSpawn = nil
    end
end)

local function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

function OpenAmbulanceGarageMenu()
	local elements = {}
	local NoCars, NoShared = true, true

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedAmbulanceCars)
		if #ownedAmbulanceCars > 0 then
			NoCars = false
		end
	end, 'mount_zonah', 'cars')

	ESX.TriggerServerCallback('esx_advancedgarage:getSharedVehicles', function(sharedAmbulanceCars)
		if #sharedAmbulanceCars > 0 then
			NoShared= false
		end
	end, 'mount_zonah', 'cars')
	Citizen.Wait(500)
	if NoCars and NoShared then
		ESX.UI.Menu.CloseAll()
		ESX.ShowNotification(_U('garage_no_veh'))
		print('triggered')
	else
		ESX.UI.Menu.CloseAll()
		
				totalCars = 0
				vehToSpawn = {}
				exports["br-menu"]:SetTitle("Ambulance Garage")
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedPoliceCars)
					if not displayed then
						for _,v in pairs(ownedPoliceCars) do
							local vehStored = _U('veh_loc_unknown')
							if v.stored then
								vehStored = _U('veh_loc_garage')
							else
								vehStored = _U('veh_loc_impound')
							end
							table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
							local a= {v.plate, v.vehName, vehStored, v.fuel, totalCars}
							vehToSpawn[totalCars] = v
							exports["br-menu"]:AddButton(v.plate , v.vehName ,'advancedGarage:SpawnCar' , a , 'owned')	
							totalCars = totalCars + 1
						end
					end
					
				end, 'mount_zonah', 'cars', currentLoc)
				ESX.TriggerServerCallback('esx_advancedgarage:getSharedVehicles', function(sharedPoliceCars)
					if not displayed then
						for _,v in pairs(sharedPoliceCars) do
							local vehStored = _U('veh_loc_unknown')
							if v.stored then
								vehStored = _U('veh_loc_garage')
							else
								vehStored = _U('veh_loc_impound')
							end
							table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
							local a= {v.plate, v.vehName, vehStored, v.fuel, totalCars}
							vehToSpawn[totalCars] = v
							exports["br-menu"]:AddButton(v.plate , v.vehName ,'advancedGarage:SpawnCar' , a , 'shared')	
							totalCars = totalCars + 1
						end
					end
					displayed = true
				end, 'mount_zonah', 'cars')

				if not noCars then 
					exports["br-menu"]:SubMenu('Owned Vehicles' , '' , 'owned')
				end
				exports["br-menu"]:SubMenu('Shared Vehicles' , '' , 'shared')
				
			
	end
end	

function StoreOwnedAmbulanceMenu()
	local playerPed  = GetPlayerPed(-1)

	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed = GetPlayerPed(-1)
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate = vehicleProps.plate

		ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
			if valid then
				if engineHealth < 990 then
					if Config.Main.DamageMult then
						local apprasial = math.floor((1000 - engineHealth)/1000*Config.Ambulance.PoundP*Config.Main.MultAmount)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					else
						local apprasial = math.floor((1000 - engineHealth)/1000*Config.Ambulance.PoundP)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					end
				else
					StoreVehicle(vehicle, vehicleProps)
				end	
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end
-- End of Ambulance Code
RegisterNetEvent('advancedGarage:OpenJobGarageRadial')
AddEventHandler('advancedGarage:OpenJobGarageRadial', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
		if not IsPedSittingInAnyVehicle(PlayerPedId()) then
			OpenPoliceGarageMenu()
			displayed = false
		end
	end
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'towing' then
		if not IsPedSittingInAnyVehicle(PlayerPedId()) then
			OpenTowingGarageMenu()
			displayed = false
		end
	end
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mount_zonah' then
		if not IsPedSittingInAnyVehicle(PlayerPedId()) then
			OpenAmbulanceGarageMenu()
			displayed = false
		end
	end
end)
--temp
RegisterCommand('getModel', function(source, args, raw)
	local veh = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1)))
	print(veh)
end)

RegisterNetEvent('advancedGarage:SpawnCar')
AddEventHandler('advancedGarage:SpawnCar', function(veh)
	displayed = false
	totalCars = 0
	local a = {}
	local counter = 1 
	for word in string.gmatch(veh, '([^,]+)') do
		a[counter]=word
		counter = counter +1
	end
	if a[3] == 'In Garage' then							
		SpawnVehicle(vehToSpawn[tonumber(a[5])].vehicle , a[1], a[4],locToSpawn, headingToSpawn)		
	else
		exports['mythic_notify']:DoHudText('error', 'Car is already out!')
	end	
end)

RegisterNetEvent('advancedGarage:SpawnCar2')
AddEventHandler('advancedGarage:SpawnCar2', function(veh)
	displayed = false
	totalCars = 0
	local a = {}
	local counter = 1
	for word in string.gmatch(veh, '([^,]+)') do
		a[counter]=word
		counter = counter +1
	end

	if a[4] == 'In Garage' then						
		SpawnVehicle(vehToSpawn[tonumber(a[5])].vehicle , a[2], a[3], locToSpawn, headingToSpawn)		
	else
		exports['mythic_notify']:DoHudText('error', 'Car is already out!')
	end	
end)

function checkPDGarage()
	if locBooleans.policeGarage1 or locBooleans.policeGarage2 or locBooleans.policeGarage3 then
		return true
	end
	return false	
end	

-- Start of Police Code heavily edited: Reworked to use br-menu, rework to configure for shared vehicles
function OpenPoliceGarageMenu()
	local elements = {}
	local NoCars, NoShared = true, true

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedPoliceCars)
		if #ownedPoliceCars > 0 then
			NoCars = false
			print('hasPoliceCar')
		end
	end, 'police', 'cars')

	ESX.TriggerServerCallback('esx_advancedgarage:getSharedVehicles', function(sharedPoliceCars)
		if #sharedPoliceCars > 0 then
			NoShared= false
		end
	end, 'police', 'cars')
	Citizen.Wait(500)
	if NoCars and NoShared then
		ESX.UI.Menu.CloseAll()
		ESX.ShowNotification(_U('garage_no_veh'))
	else
		ESX.UI.Menu.CloseAll()
			if checkPDGarage() then
				totalCars = 0
				vehToSpawn = {}
				exports["br-menu"]:SetTitle("Police Garage")
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedPoliceCars)
					if not displayed then
						for _,v in pairs(ownedPoliceCars) do
							local vehStored = _U('veh_loc_unknown')
							if v.stored then
								vehStored = _U('veh_loc_garage')
							else
								vehStored = _U('veh_loc_impound')
							end
							table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
							local a= {v.plate, v.vehName, vehStored, v.fuel, totalCars}
							vehToSpawn[totalCars] = v
							exports["br-menu"]:AddButton(v.plate , v.vehName ,'advancedGarage:SpawnCar' , a , 'owned')	
							totalCars = totalCars + 1
						end
					end
					
				end, 'police', 'cars', currentLoc)
				ESX.TriggerServerCallback('esx_advancedgarage:getSharedVehicles', function(sharedPoliceCars)
					if not displayed then
						for _,v in pairs(sharedPoliceCars) do
							local vehStored = _U('veh_loc_unknown')
							if v.stored then
								vehStored = _U('veh_loc_garage')
							else
								vehStored = _U('veh_loc_impound')
							end
							table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
							local a= {v.plate, v.vehName, vehStored, v.fuel, totalCars}
							vehToSpawn[totalCars] = v
							exports["br-menu"]:AddButton(v.plate , v.vehName ,'advancedGarage:SpawnCar' , a , 'shared')	
							totalCars = totalCars + 1
						end
					end
					displayed = true
				end, 'police', 'cars')

				if not noCars then 
					exports["br-menu"]:SubMenu('Owned Vehicles' , '' , 'owned')
				end
				exports["br-menu"]:SubMenu('Shared Vehicles' , '' , 'shared')
				
			end
	end
end				
			
--added: Triggers Radial menu Police garage
RegisterNetEvent('advancedGarage:StoreOwnedPoliceRadial')
AddEventHandler('advancedGarage:StoreOwnedPoliceRadial', function()
	StoreOwnedPoliceMenu()
end)

function StoreOwnedPoliceMenu()
	local playerPed  = GetPlayerPed(-1)

	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed = GetPlayerPed(-1)
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local plate = vehicleProps.plate
		local tyre = {IsVehicleTyreBurst(vehicle, 0, false),IsVehicleTyreBurst(vehicle, 1, false),IsVehicleTyreBurst(vehicle, 4, false),IsVehicleTyreBurst(vehicle, 5, false)}
		local doors = {IsVehicleDoorDamaged(vehicle, 0),IsVehicleDoorDamaged(vehicle, 1),IsVehicleDoorDamaged(vehicle, 2),IsVehicleDoorDamaged(vehicle, 3),IsVehicleDoorDamaged(vehicle, 4),IsVehicleDoorDamaged(vehicle, 5)}
		vehicleProps['tyre'] = tyre
		vehicleProps['doors'] = doors
		ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
			if valid then
					StoreVehicle(vehicle, vehicleProps, currentLoc)	
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end
-- End of Police Code
-- Start of towing code
function OpenTowingGarageMenu()
	local elements = {}
	local NoCars, NoShared = true, true

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedTowCars)
		if #ownedTowCars > 0 then
			NoCars = false
		end
	end, 'towing', 'trucks')

	ESX.TriggerServerCallback('esx_advancedgarage:getSharedVehicles', function(sharedTowCars)
		if #sharedPoliceCars > 0 then
			NoShared= false
		end
	end, 'towing', 'trucks')
	Citizen.Wait(500)
	if NoCars and NoShared then
		ESX.UI.Menu.CloseAll()
		ESX.ShowNotification(_U('garage_no_veh'))
	else
		ESX.UI.Menu.CloseAll()
			
				totalCars = 0
				vehToSpawn = {}
				exports["br-menu"]:SetTitle("Elite Towing Garage")
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedTowCars)
					if not displayed then
						for _,v in pairs(ownedTowCars) do
							local vehStored = _U('veh_loc_unknown')
							if v.stored then
								vehStored = _U('veh_loc_garage')
							else
								vehStored = _U('veh_loc_impound')
							end
							table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
							local a= {v.plate, v.vehName, vehStored, v.fuel, totalCars}
							vehToSpawn[totalCars] = v
							exports["br-menu"]:AddButton(v.plate , v.vehName ,'advancedGarage:SpawnCar' , a , 'owned')	
							totalCars = totalCars + 1
						end
					end
					
				end, 'towing', 'trucks', currentLoc)
				ESX.TriggerServerCallback('esx_advancedgarage:getSharedVehicles', function(sharedPoliceCars)
					if not displayed then
						for _,v in pairs(sharedPoliceCars) do
							local vehStored = _U('veh_loc_unknown')
							if v.stored then
								vehStored = _U('veh_loc_garage')
							else
								vehStored = _U('veh_loc_impound')
							end
							table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
							local a= {v.plate, v.vehName, vehStored, v.fuel, totalCars}
							vehToSpawn[totalCars] = v
							exports["br-menu"]:AddButton(v.plate , v.vehName ,'advancedGarage:SpawnCar' , a , 'shared')	
							totalCars = totalCars + 1
						end
					end
					displayed = true
				end, 'towing', 'trucks')

				if not noCars then 
					exports["br-menu"]:SubMenu('Owned Vehicles' , '' , 'owned')
				end
				exports["br-menu"]:SubMenu('Shared Vehicles' , '' , 'shared')
				
			
	end
end
-- Start of Mechanic Code
function OpenMechanicGarageMenu()
	local elements = {}
	local NoCars = true

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedMechanicCars)
		if #ownedMechanicCars > 0 then
			table.insert(elements, {label = _U('cars'), value = 'cars'})
			NoCars = false
		end
	end, 'mechanic', 'cars')
	Citizen.Wait(500)

	if NoCars then
		ESX.UI.Menu.CloseAll()
		ESX.ShowNotification(_U('garage_no_veh'))
	else
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanicgaragemenu', {
			title = _U('garage_menu'),
			align = GetConvar('esx_MenuAlign', 'top-left'),
			elements = elements
		}, function(data, menu)
			local action = data.current.value

			if action == 'cars' then
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedMechanicCars)
					for _,v in pairs(ownedMechanicCars) do
						local vehStored = _U('veh_loc_unknown')
						if v.stored then
							vehStored = _U('veh_loc_garage')
						else
							vehStored = _U('veh_loc_impound')
						end

						table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
					end

					ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'owned_vehicles_list', elements, function(data2, menu2)
						local vehVehicle, vehPlate, vehStored, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.stored, data2.data.fuel
						if data2.value == 'spawn' then
							if vehStored then
								if ESX.Game.IsSpawnPointClear(this_Garage.Spawner, 5.0) then
									SpawnVehicle(vehVehicle, vehPlate, vehFuel)
									ESX.UI.Menu.CloseAll()
								else
									ESX.ShowNotification(_U('spawnpoint_blocked'))
								end
							else
								ESX.ShowNotification(_U('veh_not_here'))
							end
						elseif data2.value == 'rename' then
							if Config.Main.RenameVehs then
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'renamevehicle', {
									title = _U('veh_rename', Config.Main.RenameMin, Config.Main.RenameMax - 1)
								}, function(data3, menu3)
									if string.len(data3.value) >= Config.Main.RenameMin and string.len(data3.value) < Config.Main.RenameMax then
										TriggerServerEvent('esx_advancedgarage:renameVehicle', vehPlate, data3.value)
										ESX.UI.Menu.CloseAll()
									else
										ESX.ShowNotification(_U('veh_rename_empty', Config.Main.RenameMin, Config.Main.RenameMax - 1))
									end
								end, function(data3, menu3)
									menu3.close()
								end)
							else
								ESX.ShowNotification(_U('veh_rename_no'))
							end
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end, 'mechanic', 'cars')
			end
		end, function(data, menu)
			menu.close()
		end)
	end
end

function StoreOwnedMechanicMenu()
	local playerPed  = GetPlayerPed(-1)

	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed = GetPlayerPed(-1)
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate = vehicleProps.plate

		ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
			if valid then
				if engineHealth < 990 then
					if Config.Main.DamageMult then
						local apprasial = math.floor((1000 - engineHealth)/1000*Config.Mechanic.PoundP*Config.Main.MultAmount)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					else
						local apprasial = math.floor((1000 - engineHealth)/1000*Config.Mechanic.PoundP)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					end
				else
					StoreVehicle(vehicle, vehicleProps)
				end	
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end
-- End of Mechanic Code

-- Start of Aircraft Code
function StoreOwnedAircraftMenu()
	local playerPed  = GetPlayerPed(-1)

	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed = GetPlayerPed(-1)
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate = vehicleProps.plate

		ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
			if valid then
				if engineHealth < 990 then
					if Config.Main.DamageMult then
						local apprasial = math.floor((1000 - engineHealth)/1000*Config.Aircrafts.PoundP*Config.Main.MultAmount)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					else
						local apprasial = math.floor((1000 - engineHealth)/1000*Config.Aircrafts.PoundP)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					end
				else
					StoreVehicle(vehicle, vehicleProps)
				end	
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end
-- End of Aircraft Code

-- Start of Boat Code
function OpenBoatGarageMenu()
	local elements = {}
	local NoBoats, NoSubs = true, true

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedBoats)
		if #ownedBoats > 0 then
			table.insert(elements, {label = _U('boats'), value = 'boats'})
			NoBoats = false
		end
	end, 'civ', 'boats')

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedSubs)
		if #ownedSubs > 0 then
			table.insert(elements, {label = _U('subs'), value = 'subs'})
			NoSubs = false
		end
	end, 'civ', 'subs')
	Citizen.Wait(500)

	if NoBoats and NoSubs then
		ESX.UI.Menu.CloseAll()
		ESX.ShowNotification(_U('garage_no_veh'))
	else
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boatgaragemenu', {
			title = _U('garage_menu'),
			align = GetConvar('esx_MenuAlign', 'top-left'),
			elements = elements
		}, function(data, menu)
			local action = data.current.value

			if action == 'boats' then
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedBoats)
					for _,v in pairs(ownedBoats) do
						local vehStored = _U('veh_loc_unknown')
						if v.stored then
							vehStored = _U('veh_loc_garage')
						else
							vehStored = _U('veh_loc_impound')
						end

						table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
					end

					ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'owned_vehicles_list', elements, function(data2, menu2)
						local vehVehicle, vehPlate, vehStored, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.stored, data2.data.fuel
						if data2.value == 'spawn' then
							if vehStored then
								if ESX.Game.IsSpawnPointClear(this_Garage.Spawner, 5.0) then
									SpawnVehicle(vehVehicle, vehPlate, vehFuel)
									ESX.UI.Menu.CloseAll()
								else
									ESX.ShowNotification(_U('spawnpoint_blocked'))
								end
							else
								ESX.ShowNotification(_U('veh_not_here'))
							end
						elseif data2.value == 'rename' then
							if Config.Main.RenameVehs then
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'renamevehicle', {
									title = _U('veh_rename', Config.Main.RenameMin, Config.Main.RenameMax - 1)
								}, function(data3, menu3)
									if string.len(data3.value) >= Config.Main.RenameMin and string.len(data3.value) < Config.Main.RenameMax then
										TriggerServerEvent('esx_advancedgarage:renameVehicle', vehPlate, data3.value)
										ESX.UI.Menu.CloseAll()
									else
										ESX.ShowNotification(_U('veh_rename_empty', Config.Main.RenameMin, Config.Main.RenameMax - 1))
									end
								end, function(data3, menu3)
									menu3.close()
								end)
							else
								ESX.ShowNotification(_U('veh_rename_no'))
							end
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end, 'civ', 'boats')
			elseif action == 'subs' then
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedSubs)
					for _,v in pairs(ownedSubs) do
						local vehStored = _U('veh_loc_unknown')
						if v.stored then
							vehStored = _U('veh_loc_garage')
						else
							vehStored = _U('veh_loc_impound')
						end

						table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
					end

					ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'owned_vehicles_list', elements, function(data2, menu2)
						local vehVehicle, vehPlate, vehStored, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.stored, data2.data.fuel
						if data2.value == 'spawn' then
							if vehStored then
								if ESX.Game.IsSpawnPointClear(this_Garage.Spawner, 5.0) then
									SpawnVehicle(vehVehicle, vehPlate, vehFuel)
									ESX.UI.Menu.CloseAll()
								else
									ESX.ShowNotification(_U('spawnpoint_blocked'))
								end
							else
								ESX.ShowNotification(_U('veh_not_here'))
							end
						elseif data2.value == 'rename' then
							if Config.Main.RenameVehs then
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'renamevehicle', {
									title = _U('veh_rename', Config.Main.RenameMin, Config.Main.RenameMax - 1)
								}, function(data3, menu3)
									if string.len(data3.value) >= Config.Main.RenameMin and string.len(data3.value) < Config.Main.RenameMax then
										TriggerServerEvent('esx_advancedgarage:renameVehicle', vehPlate, data3.value)
										ESX.UI.Menu.CloseAll()
									else
										ESX.ShowNotification(_U('veh_rename_empty', Config.Main.RenameMin, Config.Main.RenameMax - 1))
									end
								end, function(data3, menu3)
									menu3.close()
								end)
							else
								ESX.ShowNotification(_U('veh_rename_no'))
							end
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end, 'civ', 'subs')
			end
		end, function(data, menu)
			menu.close()
		end)
	end
end

function StoreOwnedBoatMenu()
	local playerPed  = GetPlayerPed(-1)

	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed = GetPlayerPed(-1)
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate = vehicleProps.plate

		ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
			if valid then
				if engineHealth < 990 then
					if Config.Main.DamageMult then
						local apprasial = math.floor((1000 - engineHealth)/1000*Config.Boats.PoundP*Config.Main.MultAmount)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					else
						local apprasial = math.floor((1000 - engineHealth)/1000*Config.Boats.PoundP)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					end
				else
					StoreVehicle(vehicle, vehicleProps)
				end	
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end
-- End of Boat Code

RegisterNetEvent('advancedGarage:OpenGarageCivRadial')
AddEventHandler('advancedGarage:OpenGarageCivRadial', function()
	if not IsPedSittingInAnyVehicle(PlayerPedId()) then
		OpenCarGarageMenu()
	end
	
end)
RegisterNetEvent('advancedGarage:OpenCarsSuper')
AddEventHandler('advancedGarage:OpenCarsSuper', function()
	supers = true
end)

-- Start of Car Code: Heavily edited to allow use of radial menu w/ polyzones
function OpenCarGarageMenu()
	local elements = {}
	local NoCycles, NoCompacts, NoCoupes, NoMotos, NoMuscles, NoOffs, NoSedans, NoSports, NoSportCs, NoSupers, NoSUVs, NoVans = true, true, true, true, true, true, true, true, true, true, true, true

	if Config.Main.TruckShop then
		table.insert(elements, {label = _U('large_trucks'), value = 'large_trucks'})
	end
	
	exports["br-menu"]:SetTitle("Garage")
	
		totalCars = 0
		local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
		
		--supers
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedSupers)
			for _,v in pairs(ownedSupers) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end
					vehToSpawn[totalCars] = v
					local a = {v, v.plate, v.fuel, vehStored, totalCars}
					
					exports["br-menu"]:AddButton(v.vehName,'Plate: '..v.plate..' 	Fuel: '..v.fuel..'%', 'advancedGarage:SpawnCar2' , a, "menuSupers")	
					totalCars = totalCars +1
			end
		end, 'civ', 'supers', currentLoc)
		
		--muscles
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedMuscles)
			for _,v in pairs(ownedMuscles) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end
					vehToSpawn[totalCars] = v
					local a = {v, v.plate, v.fuel, vehStored, totalCars}
					exports["br-menu"]:AddButton(v.vehName,'Plate: '..v.plate..' 	Fuel: '..v.fuel..'%','advancedGarage:SpawnCar2' , a, "menuMuscles")	
					totalCars = totalCars+1
			end
		end, 'civ', 'muscles', currentLoc)
	
		--cycles
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedCycles)
			for _,v in pairs(ownedCycles) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end
					vehToSpawn[totalCars] = v
					local a = {v, v.plate, v.fuel, vehStored, totalCars}
					exports["br-menu"]:AddButton(v.vehName,'Plate: '..v.plate..' 	Fuel: '..v.fuel..'%', 'advancedGarage:SpawnCar2' , a, "menuCycles")	
					totalCars = totalCars+1
			end
		end, 'civ', 'cycles', currentLoc)
		
		--compacts
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedCompacts)
			for _,v in pairs(ownedCompacts) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end
					vehToSpawn[totalCars] = v
					local a = {v, v.plate, v.fuel, vehStored, totalCars}
					exports["br-menu"]:AddButton(v.vehName,'Plate: '..v.plate..' 	Fuel: '..v.fuel..'%', 'advancedGarage:SpawnCar2' , a, "menuCompacts")	
					totalCars = totalCars+1
			end
		end, 'civ', 'compacts', currentLoc)
		--coupes
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedCoupes)
			for _,v in pairs(ownedCoupes) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end
					vehToSpawn[totalCars] = v
					local a = {v, v.plate, v.fuel, vehStored, totalCars}
					exports["br-menu"]:AddButton(v.vehName,'Plate: '..v.plate..' 	Fuel: '..v.fuel..'%','advancedGarage:SpawnCar2' , a, "menuCoupes")	
					totalCars = totalCars+1
			end
		end, 'civ', 'coupes', currentLoc)
		--motorcycles
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedMotorcycles)
			for _,v in pairs(ownedMotorcycles) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end
					vehToSpawn[totalCars] = v
					local a = {v, v.plate, v.fuel, vehStored, totalCars}
					exports["br-menu"]:AddButton(v.vehName,'Plate: '..v.plate..' 	Fuel: '..v.fuel..'%','advancedGarage:SpawnCar2' , a, "menuMotorcycles")	
					totalCars = totalCars+1
			end
		end, 'civ', 'motorcycles', currentLoc)
		--offroads
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedOffRoads)
			for _,v in pairs(ownedOffRoads) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end
					vehToSpawn[totalCars] = v
					local a = {v, v.plate, v.fuel, vehStored, totalCars}
					exports["br-menu"]:AddButton(v.vehName,'Plate: '..v.plate..' 	Fuel: '..v.fuel..'%','advancedGarage:SpawnCar2' , a, "menuOffRoads")	
					totalCars = totalCars+1
			end
		end, 'civ', 'offroads', currentLoc)
		--sedans
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedSedans)
			for _,v in pairs(ownedSedans) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end
					vehToSpawn[totalCars] = v
					local a = {v, v.plate, v.fuel, vehStored, totalCars}
					exports["br-menu"]:AddButton(v.vehName,'Plate: '..v.plate..' 	Fuel: '..v.fuel..'%','advancedGarage:SpawnCar2' , a, "menuSedans")	
					totalCars = totalCars+1
			end
		end, 'civ', 'sedans', currentLoc)
		--sports
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedSports)
			for _,v in pairs(ownedSports) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end
					vehToSpawn[totalCars] = v
					local a = {v, v.plate, v.fuel, vehStored, totalCars}
					exports["br-menu"]:AddButton(v.vehName,'Plate: '..v.plate..' 	Fuel: '..v.fuel..'%','advancedGarage:SpawnCar2' , a, "menuSports")	
					totalCars = totalCars+1	
			end
		end, 'civ', 'sports', currentLoc)
		--sportsclassics
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedSportsClassics)
			for _,v in pairs(ownedSportsClassics) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end
					vehToSpawn[totalCars] = v
					local a = {v, v.plate, v.fuel, vehStored, totalCars}
					exports["br-menu"]:AddButton(v.vehName,'Plate: '..v.plate..' 	Fuel: '..v.fuel..'%','advancedGarage:SpawnCar2' , a, "menuSportsClassics")	
					totalCars = totalCars+1	
			end
		end, 'civ', 'sportsclassics', currentLoc)
		--suvs
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedSUVs)
			for _,v in pairs(ownedSUVs) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end
					table.insert(elements.rows, {data = v, cols = {v.vehName, v.plate, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
					vehToSpawn[totalCars] = v
					local a = {v, v.plate, v.fuel, vehStored, totalCars}
					exports["br-menu"]:AddButton(v.vehName,'Plate: '..v.plate..' 	Fuel: '..v.fuel..'%','advancedGarage:SpawnCar2' , a, "menuSUVs")	
					totalCars = totalCars+1
			end
		end, 'civ', 'suvs', currentLoc)
		--vans
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVans)
			for _,v in pairs(ownedVans) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end
					table.insert(elements.rows, {data = v, cols = { v.vehName, v.plate, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
					vehToSpawn[totalCars] = v
					local a = {v, v.plate, v.fuel, vehStored, totalCars}
					exports["br-menu"]:AddButton(v.vehName,'Plate: '..v.plate..' 	Fuel: '..v.fuel..'%','advancedGarage:SpawnCar2' , a, "menuVans")	
					totalCars = totalCars+1
			end
		end, 'civ', 'vans', currentLoc)
		
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedCycles)
			if #ownedCycles > 0 then
				table.insert(elements, {label = _U('cycles'), value = 'cycles'})
				exports["br-menu"]:SubMenu('Cycles' , '' , 'menuCycles')
				NoCycles = false
			end
		end, 'civ', 'cycles', currentLoc)
	
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedCompacts)
			if #ownedCompacts > 0 then
				table.insert(elements, {label = _U('compacts'), value = 'compacts'})
				exports["br-menu"]:SubMenu('Compacts' , '', 'menuCompacts')
				NoCompacts = false
			end
		end, 'civ', 'compacts', currentLoc)
	
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedCoupes)
			if #ownedCoupes > 0 then
				table.insert(elements, {label = _U('coupes'), value = 'coupes'})
				exports["br-menu"]:SubMenu('Coupes' , '' , 'menuCoupes')
				NoCoupes = false
			end
		end, 'civ', 'coupes', currentLoc)
	
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedMotorcycles)
			if #ownedMotorcycles > 0 then
				table.insert(elements, {label = _U('motorcycles'), value = 'motorcycles'})
				exports["br-menu"]:SubMenu('Motorcyles' , '' , 'menuMotorcycles')
				NoMotos = false
			end
		end, 'civ', 'motorcycles', currentLoc)
	
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedMuscles)
			if #ownedMuscles > 0 then
				table.insert(elements, {label = _U('muscles'), value = 'muscles'})
				exports["br-menu"]:SubMenu('Muscles' , '', 'menuMuscles')
				NoMuscles = false
			end
		end, 'civ', 'muscles', currentLoc)
	
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedOffRoads)
			if #ownedOffRoads > 0 then
				table.insert(elements, {label = _U('offroads'), value = 'offroads'})
				exports["br-menu"]:SubMenu('Offroads' , '' , 'menuOffRoads')
				NoOffs = false
			end
		end, 'civ', 'offroads', currentLoc)
	
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedSedans)
			if #ownedSedans > 0 then
				table.insert(elements, {label = _U('sedans'), value = 'sedans'})
				exports["br-menu"]:SubMenu('Sedans' ,'' , 'menuSedans')
				NoSedans = false
			end
		end, 'civ', 'sedans', currentLoc)
	
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedSports)
			if #ownedSports > 0 then
				table.insert(elements, {label = _U('sports'), value = 'sports'})
				exports["br-menu"]:SubMenu('Sports' , '' , 'menuSports')
				NoSports = false
			end
		end, 'civ', 'sports', currentLoc)
	
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedSportsClassics)
			if #ownedSportsClassics > 0 then
				table.insert(elements, {label = _U('sportsclassics'), value = 'sportsclassics'})
				exports["br-menu"]:SubMenu('Sports Classics' , '' , 'menuSportsClassics')
				NoSportCs = false
			end
		end, 'civ', 'sportsclassics', currentLoc)
	
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedSupers)
			if #ownedSupers > 0 then
				table.insert(elements, {label = _U('supers'), value = 'supers'})
				exports["br-menu"]:SubMenu('Supers' , '' , "menuSupers")
				NoSupers = false
			end
		end, 'civ', 'supers', currentLoc)
	
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedSUVs)
			if #ownedSUVs > 0 then
				table.insert(elements, {label = _U('suvs'), value = 'suvs'})
				exports["br-menu"]:SubMenu('SUV' , '' , 'menuSUVs')
				NoSUVs = false
			end
		end, 'civ', 'suvs', currentLoc)
	
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVans)
			if #ownedVans > 0 then
				table.insert(elements, {label = _U('vans'), value = 'vans'})
				exports["br-menu"]:SubMenu('Vans' , '' , 'menuVans')
				NoVans = false
			end
		end, 'civ', 'vans', currentLoc)
		Citizen.Wait(1000)
	
end

function StoreOwnedCarMenu()
	local playerPed  = GetPlayerPed(-1)

	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed = GetPlayerPed(-1)
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate = vehicleProps.plate

		ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
			if valid then
				if engineHealth < 990 then
					if Config.Main.DamageMult then
						local apprasial = math.floor((1000 - engineHealth)/1000*Config.Cars.PoundP*Config.Main.MultAmount)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					else
						local apprasial = math.floor((1000 - engineHealth)/1000*Config.Cars.PoundP)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					end
				else
					StoreVehicle(vehicle, vehicleProps)
				end	
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end
-- End of Car Code

-- Store Vehicles
function StoreVehicle(vehicle, vehicleProps, location)
	for k,v in pairs (vehInstance) do
		if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehicleProps.plate) then
			table.remove(vehInstance, k)
		end
	end

	if Config.Main.LegacyFuel then
		currentFuel = exports['LegacyFuel']:GetFuel(vehicle)
		TriggerServerEvent('esx_advancedgarage:setVehicleFuel', vehicleProps.plate, currentFuel)
		print("currentFuel: "..currentFuel)
	end

	DeleteEntity(vehicle)
	TriggerServerEvent('esx_advancedgarage:setVehicleState', vehicleProps.plate, true, currentLoc)
	exports['mythic_notify']:DoHudText('inform', 'You parked your car!')
end

function SpawnVehicle(vehicle, plate, fuel, vector, heading)
	ESX.Game.SpawnVehicle(vehicle.model, vector, heading, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetVehicleBodyHealth(callback_vehicle, vehicle.bodyHealth)
		doCarDamages(vehicle.engineHealth, vehicle.bodyHealth, callback_vehicle, vehicle.tyre, vehicle.doors)
		Citizen.Wait(100)
		SetVehicleUndriveable(callback_vehicle, false)
		SetVehicleEngineOn(callback_vehicle, true, true)
		local carplate = GetVehicleNumberPlateText(callback_vehicle)
		table.insert(vehInstance, {vehicleentity = callback_vehicle, plate = carplate})
		if Config.Main.LegacyFuel then
			exports['LegacyFuel']:SetFuel(callback_vehicle, fuel)
		end
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
		exports["onyxLocksystem"]:givePlayerKeys(carplate)
		exports['mythic_notify']:DoHudText('inform', 'You pulled out your vehicle!')
	end)
	TriggerServerEvent('esx_advancedgarage:setVehicleState', plate, 0)	
end

function doCarDamages(eh, bh, veh, tyres, doors)
    local windows = {0,1,2,3,4}
    local tobreakW = 0
    local tobreakD = 0
    if eh and bh and tyres then
		print('we apply dmg')
        local engine = eh + 0.0
        local body = bh + 0.0
        local dif = (1000.0 - body) + 1.0
        local toDmg = math.floor(dif/100)
        local currentVehicle = (veh and IsEntityAVehicle(veh)) and veh or GetVehiclePedIsIn(PlayerPedId(), false)
        if toDmg >5 then
            toDmg = 5
        end
        if toDmg > 0 then 
            for i=1, toDmg, 1 do
                local ran = math.random(0,4) 
                SmashVehicleWindow(currentVehicle, windows[ran])
            end
        end
        SetVehicleEngineHealth(currentVehicle, engine)
        if tyres then
			local toPop = {0,1,4,5}
            for i, t in pairs(tyres) do
				if t == 1 then
					SetVehicleTyreBurst(currentVehicle, toPop[i], true, 1000.0)	
				end
			end
        end
		if doors then 
			for i, d in pairs(doors) do
				if d == 1 then 
					SetVehicleDoorBroken(currentVehicle, i-1, true)
				end
			end
		end

        if body < 1000 then
           	SetVehicleBodyHealth(currentVehicle, body)
        end
		
    end
end
-- Check Vehicles
function DoesAPlayerDrivesVehicle(plate)
	local isVehicleTaken = false
	local players = ESX.Game.GetPlayers()
	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])
		if target ~= PlayerPedId() then
			local plate1 = GetVehicleNumberPlateText(GetVehiclePedIsIn(target, true))
			local plate2 = GetVehicleNumberPlateText(GetVehiclePedIsIn(target, false))
			if plate == plate1 or plate == plate2 then
				isVehicleTaken = true
				break
			end
		end
	end
	return isVehicleTaken
end

-- Resource Stop
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		ESX.UI.Menu.CloseAll()
	end
end)

-- Create Blips
function CreateBlips()
	if Config.Aircrafts.Garages and Config.Aircrafts.Blips then
		for k,v in pairs(Config.AircraftGarages) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite (blip, Config.Blips.Garages.Sprite)
			SetBlipColour (blip, Config.Blips.Garages.Color)
			SetBlipDisplay(blip, Config.Blips.Garages.Display)
			SetBlipScale  (blip, Config.Blips.Garages.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_garage'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end
	end

	if Config.Boats.Garages and Config.Boats.Blips then
		for k,v in pairs(Config.BoatGarages) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite (blip, Config.Blips.Garages.Sprite)
			SetBlipColour (blip, Config.Blips.Garages.Color)
			SetBlipDisplay(blip, Config.Blips.Garages.Display)
			SetBlipScale  (blip, Config.Blips.Garages.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_garage'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end
	end

	if Config.Cars.Garages and Config.Cars.Blips then
		for k,v in pairs(Config.CarGarages) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite (blip, Config.Blips.Garages.Sprite)
			SetBlipColour (blip, Config.Blips.Garages.Color)
			SetBlipDisplay(blip, Config.Blips.Garages.Display)
			SetBlipScale  (blip, Config.Blips.Garages.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_garage'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end
	end
end

-- Handles Private Blips
function DeletePrivateBlips()
	if PrivateBlips[1] ~= nil then
		for i=1, #PrivateBlips, 1 do
			RemoveBlip(PrivateBlips[i])
			PrivateBlips[i] = nil
		end
	end
end

function RefreshPrivateBlips()
	for zoneKey,zoneValues in pairs(Config.PrivateCarGarages) do
		if zoneValues.Private and has_value(userProperties, zoneValues.Private) then
			local blip = AddBlipForCoord(zoneValues.Marker)

			SetBlipSprite (blip, Config.Blips.PGarages.Sprite)
			SetBlipColour (blip, Config.Blips.PGarages.Color)
			SetBlipDisplay(blip, Config.Blips.PGarages.Display)
			SetBlipScale  (blip, Config.Blips.PGarages.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_garage_private'))
			EndTextCommandSetBlipName(blip)
			table.insert(PrivateBlips, blip)
		end
	end
end

-- Handles Job Blips
function DeleteJobBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function RefreshJobBlips()
	if Config.Ambulance.Garages and Config.Ambulance.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
			for k,v in pairs(Config.AmbulanceGarages) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite (blip, Config.Blips.JGarages.Sprite)
				SetBlipColour (blip, Config.Blips.JGarages.Color)
				SetBlipDisplay(blip, Config.Blips.JGarages.Display)
				SetBlipScale  (blip, Config.Blips.JGarages.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(_U('blip_ambulance_garage'))
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end

	if Config.Police.Garages and Config.Police.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
			for k,v in pairs(Config.PoliceGarages) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite (blip, Config.Blips.JGarages.Sprite)
				SetBlipColour (blip, Config.Blips.JGarages.Color)
				SetBlipDisplay(blip, Config.Blips.JGarages.Display)
				SetBlipScale  (blip, Config.Blips.JGarages.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(_U('blip_police_garage'))
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end

	if Config.Mechanic.Garages and Config.Mechanic.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			for k,v in pairs(Config.MechanicGarages) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite (blip, Config.Blips.JGarages.Sprite)
				SetBlipColour (blip, Config.Blips.JGarages.Color)
				SetBlipDisplay(blip, Config.Blips.JGarages.Display)
				SetBlipScale  (blip, Config.Blips.JGarages.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(_U('blip_mechanic_garage'))
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end
end
