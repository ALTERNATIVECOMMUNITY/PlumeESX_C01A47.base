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
	--[[
	for i, value in ipairs(locStrings) do
		if name == value then
			locBooleans[name]=true
			locToSpawn = locSpawnTable[name]
			headingToSpawn = headingTable[name]
			local location = string.gsub(name, "%d", "")
			currentLoc = locations[location]
		end
	end
	]]--
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
	--[[
	for i, value in ipairs(locStrings) do
		if name == value then
			locBooleans[name]=false
			locToSpawn = nil
			headingToSpawn = nil
			local location = string.gsub(name, "%d", "")
			currentLoc = locations[location]		
		end
	end
	]]--
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

-- Start of Ambulance Code
--[[
function OpenAmbulanceGarageMenu()
	local elements = {}
	local NoCars, NoHelis = true, true

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedAmbulanceCars)
		if #ownedAmbulanceCars > 0 then
			table.insert(elements, {label = _U('cars'), value = 'cars'})
			NoCars = false
		end
	end, 'ambulance', 'cars')

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedAmbulanceHelis)
		if #ownedAmbulanceHelis > 0 then
			table.insert(elements, {label = _U('helis'), value = 'helis'})
			NoHelis = false
		end
	end, 'ambulance', 'helis')
	Citizen.Wait(500)

	if NoCars and NoHelis then
		ESX.UI.Menu.CloseAll()
		ESX.ShowNotification(_U('garage_no_veh'))
	else
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulancegaragemenu', {
			title = _U('garage_menu'),
			align = GetConvar('esx_MenuAlign', 'top-left'),
			elements = elements
		}, function(data, menu)
			local action = data.current.value

			if action == 'cars' then
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedAmbulanceCars)
					for _,v in pairs(ownedAmbulanceCars) do
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
				end, 'ambulance', 'cars')
			elseif action == 'helis' then
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedAmbulanceHelis)
					for _,v in pairs(ownedAmbulanceHelis) do
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
								if ESX.Game.IsSpawnPointClear(this_Garage.Spawner2, 5.0) then
									SpawnVehicle2(vehVehicle, vehPlate, vehFuel)
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
				end, 'ambulance', 'helis')
			end
		end, function(data, menu)
			menu.close()
		end)
	end
end
]]--
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

function OpenAmbulanceImpoundMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'policeambulancemenu', {
		title = _U('garage_menu'),
		align = GetConvar('esx_MenuAlign', 'top-left'),
		elements = {
			{label = _U('cars'), value = 'cars'},
			{label = _U('helis'), value = 'helis'}
	}}, function(data, menu)
		local action = data.current.value

		if action == 'cars' then
			local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('impound_fee'), _U('actions')}, rows = {}}
			ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedVehicles', function(outAmbulanceCars)
				if #outAmbulanceCars == 0 then
					ESX.ShowNotification(_U('impound_no'))
				else
					for _,v in pairs(outAmbulanceCars) do
						table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Ambulance.PoundP)), '{{' .. _U('return') .. '|return}}'}})
					end

					ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'out_owned_vehicles_list', elements, function(data2, menu2)
						local vehVehicle, vehPlate, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.fuel
						local doesVehicleExist = false

						if data2.value == 'return' then
							for k,v in pairs (vehInstance) do
								if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehPlate) then
									if DoesEntityExist(v.vehicleentity) then
										doesVehicleExist = true
									else
										table.remove(vehInstance, k)
										doesVehicleExist = false
									end
								end
							end

							if not doesVehicleExist and not DoesAPlayerDrivesVehicle(vehPlate) then
								if ESX.Game.IsSpawnPointClear(this_Garage.Spawner, 5.0) then
									ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function(hasEnoughMoney)
										if hasEnoughMoney then
											ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function()
												SpawnVehicle(vehVehicle, vehPlate, vehFuel)
												ESX.UI.Menu.CloseAll()
											end, 'ambulance', 'both', 'pay')
										else
											ESX.ShowNotification(_U('not_enough_money'))
										end
									end, 'ambulance', 'both', 'check')
								else
									ESX.ShowNotification(_U('spawnpoint_blocked'))
								end
							else
								ESX.ShowNotification(_U('veh_out_world'))
							end
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end
			end, 'ambulance', 'cars')
		elseif action == 'helis' then
			local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('impound_fee'), _U('actions')}, rows = {}}
			ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedVehicles', function(outAmbulanceHelis)
				if #outAmbulanceHelis == 0 then
					ESX.ShowNotification(_U('impound_no'))
				else
					for _,v in pairs(outAmbulanceHelis) do
						table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Ambulance.PoundP)), '{{' .. _U('return') .. '|return}}'}})
					end

					ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'out_owned_vehicles_list', elements, function(data2, menu2)
						local vehVehicle, vehPlate, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.fuel
						local doesVehicleExist = false

						if data2.value == 'return' then
							for k,v in pairs (vehInstance) do
								if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehPlate) then
									if DoesEntityExist(v.vehicleentity) then
										doesVehicleExist = true
									else
										table.remove(vehInstance, k)
										doesVehicleExist = false
									end
								end
							end

							if not doesVehicleExist and not DoesAPlayerDrivesVehicle(vehPlate) then
								if ESX.Game.IsSpawnPointClear(this_Garage.Spawner2, 5.0) then
									ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function(hasEnoughMoney)
										if hasEnoughMoney then
											ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function()
												SpawnVehicle2(vehVehicle, vehPlate, vehFuel)
												ESX.UI.Menu.CloseAll()
											end, 'ambulance', 'both', 'pay')
										else
											ESX.ShowNotification(_U('not_enough_money'))
										end
									end, 'ambulance', 'both', 'check')
								else
									ESX.ShowNotification(_U('spawnpoint_blocked'))
								end
							else
								ESX.ShowNotification(_U('veh_out_world'))
							end
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end
			end, 'ambulance', 'helis')
		end
	end, function(data, menu)
		menu.close()
	end)
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
		SpawnVehicle2(vehToSpawn[tonumber(a[5])].vehicle , a[1], a[4],locToSpawn, headingToSpawn)		
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
		SpawnVehicle2(vehToSpawn[tonumber(a[5])].vehicle , a[2], a[3], locToSpawn, headingToSpawn)		
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
			--[[	
			elseif action == 'helis' then
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedPoliceHelis)
					for _,v in pairs(ownedPoliceHelis) do
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
								if ESX.Game.IsSpawnPointClear(this_Garage.Spawner2, 5.0) then
									SpawnVehicle2(vehVehicle, vehPlate, vehFuel)
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
				end, 'police', 'helis')
			end
		--end, function(data, menu)
			menu.close()
		end)
	end
end
]]--
function OpenPoliceImpoundMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'policeimpoundmenu', {
		title = _U('garage_menu'),
		align = GetConvar('esx_MenuAlign', 'top-left'),
		elements = {
			{label = _U('cars'), value = 'cars'},
			{label = _U('helis'), value = 'helis'}
	}}, function(data, menu)
		local action = data.current.value

		if action == 'cars' then
			local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('impound_fee'), _U('actions')}, rows = {}}
			ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedVehicles', function(outPoliceCars)
				if #outPoliceCars == 0 then
					ESX.ShowNotification(_U('impound_no'))
				else
					for _,v in pairs(outPoliceCars) do
						table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Police.PoundP)), '{{' .. _U('return') .. '|return}}'}})
					end

					ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'out_owned_vehicles_list', elements, function(data2, menu2)
						local vehVehicle, vehPlate, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.fuel
						local doesVehicleExist = false

						if data2.value == 'return' then
							for k,v in pairs (vehInstance) do
								if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehPlate) then
									if DoesEntityExist(v.vehicleentity) then
										doesVehicleExist = true
									else
										table.remove(vehInstance, k)
										doesVehicleExist = false
									end
								end
							end

							if not doesVehicleExist and not DoesAPlayerDrivesVehicle(vehPlate) then
								if ESX.Game.IsSpawnPointClear(this_Garage.Spawner, 5.0) then
									ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function(hasEnoughMoney)
										if hasEnoughMoney then
											ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function()
												SpawnVehicle(vehVehicle, vehPlate, vehFuel)
												ESX.UI.Menu.CloseAll()
											end, 'police', 'both', 'pay')
										else
											ESX.ShowNotification(_U('not_enough_money'))
										end
									end, 'police', 'both', 'check')
								else
									ESX.ShowNotification(_U('spawnpoint_blocked'))
								end
							else
								ESX.ShowNotification(_U('veh_out_world'))
							end
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end
			end, 'police', 'cars')
		elseif action == 'helis' then
			local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('impound_fee'), _U('actions')}, rows = {}}
			ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedVehicles', function(outPoliceHelis)
				if #outPoliceHelis == 0 then
					ESX.ShowNotification(_U('impound_no'))
				else
					for _,v in pairs(outPoliceHelis) do
						table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Police.PoundP)), '{{' .. _U('return') .. '|return}}'}})
					end

					ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'out_owned_vehicles_list', elements, function(data2, menu2)
						local vehVehicle, vehPlate, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.fuel
						local doesVehicleExist = false

						if data2.value == 'return' then
							for k,v in pairs (vehInstance) do
								if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehPlate) then
									if DoesEntityExist(v.vehicleentity) then
										doesVehicleExist = true
									else
										table.remove(vehInstance, k)
										doesVehicleExist = false
									end
								end
							end

							if not doesVehicleExist and not DoesAPlayerDrivesVehicle(vehPlate) then
								if ESX.Game.IsSpawnPointClear(this_Garage.Spawner, 5.0) then
									ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function(hasEnoughMoney)
										if hasEnoughMoney then
											ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function()
												SpawnVehicle2(vehVehicle, vehPlate, vehFuel)
												ESX.UI.Menu.CloseAll()
											end, 'police', 'both', 'pay')
										else
											ESX.ShowNotification(_U('not_enough_money'))
										end
									end, 'police', 'both', 'check')
								else
									ESX.ShowNotification(_U('spawnpoint_blocked'))
								end
							else
								ESX.ShowNotification(_U('veh_out_world'))
							end
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end
			end, 'police', 'helis')
		end
	end, function(data, menu)
		menu.close()
	end)
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
		vehicleProps['tyre'] = tyre
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

function OpenMechanicImpoundMenu()
	local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('impound_fee'), _U('actions')}, rows = {}}
	ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedVehicles', function(outMechanicCars)
		if #outMechanicCars == 0 then
			ESX.ShowNotification(_U('impound_no'))
		else
			for _,v in pairs(outMechanicCars) do
				table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Mechanic.PoundP)), '{{' .. _U('return') .. '|return}}'}})
			end

			ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'out_owned_vehicles_list', elements, function(data2, menu2)
				local vehVehicle, vehPlate, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.fuel
				local doesVehicleExist = false

				if data2.value == 'return' then
					for k,v in pairs (vehInstance) do
						if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehPlate) then
							if DoesEntityExist(v.vehicleentity) then
								doesVehicleExist = true
							else
								table.remove(vehInstance, k)
								doesVehicleExist = false
							end
						end
					end

					if not doesVehicleExist and not DoesAPlayerDrivesVehicle(vehPlate) then
						if ESX.Game.IsSpawnPointClear(this_Garage.Spawner, 5.0) then
							ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function(hasEnoughMoney)
								if hasEnoughMoney then
									ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function()
										SpawnVehicle(vehVehicle, vehPlate, vehFuel)
										ESX.UI.Menu.CloseAll()
									end, 'mechanic', 'both', 'pay')
								else
									ESX.ShowNotification(_U('not_enough_money'))
								end
							end, 'mechanic', 'both', 'check')
						else
							ESX.ShowNotification(_U('spawnpoint_blocked'))
						end
					else
						ESX.ShowNotification(_U('veh_out_world'))
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, 'mechanic', 'cars')
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
function OpenAircraftGarageMenu()
	local elements = {}
	local NoHelis, NoPlanes = true, true

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedHelis)
		if #ownedHelis > 0 then
			table.insert(elements, {label = _U('helis'), value = 'helis'})
			NoHelis = false
		end
	end, 'civ', 'helis')

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedPlanes)
		if #ownedPlanes > 0 then
			table.insert(elements, {label = _U('planes'), value = 'planes'})
			NoPlanes = false
		end
	end, 'civ', 'planes')
	Citizen.Wait(500)

	if NoHelis and NoPlanes then
		ESX.UI.Menu.CloseAll()
		ESX.ShowNotification(_U('garage_no_veh'))
	else
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'aircraftgaragemenu', {
			title = _U('garage_menu'),
			align = GetConvar('esx_MenuAlign', 'top-left'),
			elements = elements
		}, function(data, menu)
			local action = data.current.value

			if action == 'helis' then
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedHelis)
					for _,v in pairs(ownedHelis) do
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
				end, 'civ', 'helis')
			elseif action == 'planes' then
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedPlanes)
					for _,v in pairs(ownedPlanes) do
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
				end, 'civ', 'planes')
			end
		end, function(data, menu)
			menu.close()
		end)
	end
end

function OpenAircraftImpoundMenu()
	local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('impound_fee'), _U('actions')}, rows = {}}
	ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedVehicles', function(outCivAircrafts)
		if #outCivAircrafts == 0 then
			ESX.ShowNotification(_U('impound_no'))
		else
			for _,v in pairs(outCivAircrafts) do
				table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Aircrafts.PoundP)), '{{' .. _U('return') .. '|return}}'}})
			end

			ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'out_owned_vehicles_list', elements, function(data2, menu2)
				local vehVehicle, vehPlate, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.fuel
				local doesVehicleExist = false

				if data2.value == 'return' then
					for k,v in pairs (vehInstance) do
						if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehPlate) then
							if DoesEntityExist(v.vehicleentity) then
								doesVehicleExist = true
							else
								table.remove(vehInstance, k)
								doesVehicleExist = false
							end
						end
					end

					if not doesVehicleExist and not DoesAPlayerDrivesVehicle(vehPlate) then
						if ESX.Game.IsSpawnPointClear(this_Garage.Spawner, 5.0) then
							ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function(hasEnoughMoney)
								if hasEnoughMoney then
									ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function()
										SpawnVehicle(vehVehicle, vehPlate, vehFuel)
										ESX.UI.Menu.CloseAll()
									end, 'civ', 'aircrafts', 'pay')
								else
									ESX.ShowNotification(_U('not_enough_money'))
								end
							end, 'civ', 'aircrafts', 'check')
						else
							ESX.ShowNotification(_U('spawnpoint_blocked'))
						end
					else
						ESX.ShowNotification(_U('veh_out_world'))
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, 'civ', 'aircrafts')
end

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

function OpenBoatImpoundMenu()
	local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('impound_fee'), _U('actions')}, rows = {}}
	ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedVehicles', function(outCivBoats)
		if #outCivBoats == 0 then
			ESX.ShowNotification(_U('impound_no'))
		else
			for _,v in pairs(outCivBoats) do
				table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Boats.PoundP)), '{{' .. _U('return') .. '|return}}'}})
			end

			ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'out_owned_vehicles_list', elements, function(data2, menu2)
				local vehVehicle, vehPlate, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.fuel
				local doesVehicleExist = false

				if data2.value == 'return' then
					for k,v in pairs (vehInstance) do
						if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehPlate) then
							if DoesEntityExist(v.vehicleentity) then
								doesVehicleExist = true
							else
								table.remove(vehInstance, k)
								doesVehicleExist = false
							end
						end
					end

					if not doesVehicleExist and not DoesAPlayerDrivesVehicle(vehPlate) then
						if ESX.Game.IsSpawnPointClear(this_Garage.Spawner, 5.0) then
							ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function(hasEnoughMoney)
								if hasEnoughMoney then
									ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function()
										SpawnVehicle(vehVehicle, vehPlate, vehFuel)
										ESX.UI.Menu.CloseAll()
									end, 'civ', 'boats', 'pay')
								else
									ESX.ShowNotification(_U('not_enough_money'))
								end
							end, 'civ', 'boats', 'check')
						else
							ESX.ShowNotification(_U('spawnpoint_blocked'))
						end
					else
						ESX.ShowNotification(_U('veh_out_world'))
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, 'civ', 'boats')
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

	-- Start of esx_advancedvehicleshop Truck Shop
	if Config.Main.TruckShop then
		table.insert(elements, {label = _U('large_trucks'), value = 'large_trucks'})
	end
	-- End of esx_advancedvehicleshop Truck Shop
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
					table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
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
					table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
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
					table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
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
					table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
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
					table.insert(elements.rows, {data = v, cols = { v.vehName, v.plate, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
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
					table.insert(elements.rows, {data = v, cols = { v.vehName, v.plate, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
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
					table.insert(elements.rows, {data = v, cols = { v.vehName, v.plate, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
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
					table.insert(elements.rows, {data = v, cols = { v.vehName, v.plate, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
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
					table.insert(elements.rows, {data = v, cols = { v.vehName, v.plate, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
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
					table.insert(elements.rows, {data = v, cols = { v.vehName, v.plate, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
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

function OpenTruckGarageMenu()
	local elements = {}
	local NoBox, NoHaul, NoOther, NoTrans = true, true, true, true

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedBox)
		if #ownedBox > 0 then
			table.insert(elements, {label = _U('box'), value = 'box'})
			NoBox = false
		end
	end, 'civ', 'box')

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedHaul)
		if #ownedHaul > 0 then
			table.insert(elements, {label = _U('haul'), value = 'haul'})
			NoHaul = false
		end
	end, 'civ', 'haul')

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedOther)
		if #ownedOther > 0 then
			table.insert(elements, {label = _U('other'), value = 'other'})
			NoOther = false
		end
	end, 'civ', 'other')

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedTrans)
		if #ownedTrans > 0 then
			table.insert(elements, {label = _U('trans'), value = 'trans'})
			NoTrans = false
		end
	end, 'civ', 'trans')
	Citizen.Wait(500)

	if NoBox and NoHaul and NoOther and NoTrans then
		ESX.ShowNotification(_U('garage_no', _U('large_trucks')))
	else
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'truckgaragemenu', {
			title = _U('garage_menu'),
			align = GetConvar('esx_MenuAlign', 'top-left'),
			elements = elements
		}, function(data, menu)
			local action = data.current.value

			if action == 'box' then
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedBox)
					for _,v in pairs(ownedBox) do
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
				end, 'civ', 'box')
			elseif action == 'haul' then
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedHaul)
					for _,v in pairs(ownedHaul) do
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
				end, 'civ', 'haul')
			elseif action == 'other' then
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedOther)
					for _,v in pairs(ownedOther) do
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
				end, 'civ', 'other')
			elseif action == 'trans' then
				local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
				ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedTrans)
					for _,v in pairs(ownedTrans) do
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
				end, 'civ', 'trans')
			end
		end, function(data, menu)
			menu.close()
		end)
	end
end

function OpenCarImpoundMenu()
	local elements = {head = {_U('veh_plate'), _U('veh_name'), _U('impound_fee'), _U('actions')}, rows = {}}
	ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedVehicles', function(outCivCars)
		if #outCivCars == 0 then
			ESX.ShowNotification(_U('impound_no'))
		else
			for _,v in pairs(outCivCars) do
				table.insert(elements.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Cars.PoundP)), '{{' .. _U('return') .. '|return}}'}})
			end

			ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'out_owned_vehicles_list', elements, function(data2, menu2)
				local vehVehicle, vehPlate, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.fuel
				local doesVehicleExist = false

				if data2.value == 'return' then
					for k,v in pairs (vehInstance) do
						if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehPlate) then
							if DoesEntityExist(v.vehicleentity) then
								doesVehicleExist = true
							else
								table.remove(vehInstance, k)
								doesVehicleExist = false
							end
						end
					end

					if not doesVehicleExist and not DoesAPlayerDrivesVehicle(vehPlate) then
						if ESX.Game.IsSpawnPointClear(this_Garage.Spawner, 5.0) then
							ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function(hasEnoughMoney)
								if hasEnoughMoney then
									ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function()
										SpawnVehicle(vehVehicle, vehPlate, vehFuel)
										ESX.UI.Menu.CloseAll()
									end, 'civ', 'cars', 'pay')
								else
									ESX.ShowNotification(_U('not_enough_money'))
								end
							end, 'civ', 'cars', 'check')
						else
							ESX.ShowNotification(_U('spawnpoint_blocked'))
						end
					else
						ESX.ShowNotification(_U('veh_out_world'))
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, 'civ', 'cars')
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

-- Repair Vehicles
function RepairVehicle(apprasial, vehicle, vehicleProps)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'delete_menu', {
		title = _U('damaged_vehicle'),
		align = GetConvar('esx_MenuAlign', 'top-left'),
		elements = {
			{label = _U('return_vehicle', apprasial), value = 'yes'},
			{label = _U('see_mechanic'), value = 'no'}
	}}, function(data, menu)
		menu.close()

		if data.current.value == 'yes' then
			TriggerServerEvent('esx_advancedgarage:payhealth', apprasial)
			vehicleProps.bodyHealth = 1000.0 -- must be a decimal value!!!
			vehicleProps.engineHealth = 1000
			StoreVehicle(vehicle, vehicleProps)
		elseif data.current.value == 'no' then
			ESX.ShowNotification(_U('visit_mechanic'))
		end
	end, function(data, menu)
		menu.close()
	end)
end

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

function SpawnVehicle2(vehicle, plate, fuel, vector, heading)
	ESX.Game.SpawnVehicle(vehicle.model, vector, heading, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetVehicleBodyHealth(callback_vehicle, vehicle.bodyHealth)
		doCarDamages(vehicle.engineHealth, vehicle.bodyHealth, callback_vehicle, vehicle.tyre)
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

function doCarDamages(eh, bh, veh, tyres)
	smash = false
	damageOutside = false
    if eh and bh and tyres then
        local engine = eh + 0.0
        local body = bh + 0.0
        if engine < 200.0 then
            engine = 200.0
        end

        if body < 150.0 then
            body = 150.0
        end
        if body < 890.0 then
            smash = true
        end

        if body < 600.0 then
            damageOutside = true
        end

        local currentVehicle = (veh and IsEntityAVehicle(veh)) and veh or GetVehiclePedIsIn(PlayerPedId(), false)

        Citizen.Wait(100)
        SetVehicleEngineHealth(currentVehicle, engine)
        if smash then
            SmashVehicleWindow(currentVehicle, 0)
            SmashVehicleWindow(currentVehicle, 1)
            SmashVehicleWindow(currentVehicle, 2)
            SmashVehicleWindow(currentVehicle, 3)
            SmashVehicleWindow(currentVehicle, 4)
        end
        if damageOutside then
            SetVehicleDoorBroken(currentVehicle, 0, true)
            SetVehicleDoorBroken(currentVehicle, 1, true)
            SetVehicleDoorBroken(currentVehicle, 6, true)
            SetVehicleDoorBroken(currentVehicle, 5, true)
            SetVehicleDoorBroken(currentVehicle, 4, true)
        end
		
        if tyres then
			local toPop = {0,1,4,5}
            for i, t in pairs(tyres) do
				if t == 1 then
					SetVehicleTyreBurst(currentVehicle, toPop[i], true, 1000.0)	
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

-- Entered Marker
AddEventHandler('esx_advancedgarage:hasEnteredMarker', function(zone)
	if zone == 'ambulance_garage_point' then
		CurrentAction = 'ambulance_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'ambulance_store_point' then
		CurrentAction = 'ambulance_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'ambulance_pound_point' then
		CurrentAction = 'ambulance_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'police_garage_point' then
		CurrentAction = 'police_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'police_store_point' then
		CurrentAction = 'police_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'police_pound_point' then
		CurrentAction = 'police_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'mechanic_garage_point' then
		CurrentAction = 'mechanic_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'mechanic_store_point' then
		CurrentAction = 'mechanic_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'mechanic_pound_point' then
		CurrentAction = 'mechanic_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'aircraft_garage_point' then
		CurrentAction = 'aircraft_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'aircraft_store_point' then
		CurrentAction = 'aircraft_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'aircraft_pound_point' then
		CurrentAction = 'aircraft_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'boat_garage_point' then
		CurrentAction = 'boat_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'boat_store_point' then
		CurrentAction = 'boat_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'boat_pound_point' then
		CurrentAction = 'boat_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'car_garage_point' then
		CurrentAction = 'car_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'car_store_point' then
		CurrentAction = 'car_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'car_pound_point' then
		CurrentAction = 'car_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	end
end)

-- Exited Marker
AddEventHandler('esx_advancedgarage:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Resource Stop
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		ESX.UI.Menu.CloseAll()
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local playerVeh = GetVehiclePedIsIn(playerPed, false)
		local model = GetEntityModel(playerVeh)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'ambulance_garage_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenAmbulanceGarageMenu()
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_ambulance'))
					end
				elseif CurrentAction == 'ambulance_store_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
						if IsThisModelACar(model) or IsThisModelABicycle(model) or IsThisModelABike(model) or IsThisModelAHeli(model) then
							if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
								StoreOwnedAmbulanceMenu()
							else
								ESX.ShowNotification(_U('driver_seat'))
							end
						else
							ESX.ShowNotification(_U('not_correct_veh'))
						end
					else
						ESX.ShowNotification(_U('must_ambulance'))
					end
				elseif CurrentAction == 'ambulance_pound_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenAmbulanceImpoundMenu()
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_ambulance'))
					end
				elseif CurrentAction == 'police_garage_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenPoliceGarageMenu()
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_police'))
					end
				elseif CurrentAction == 'police_store_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
						if IsThisModelACar(model) or IsThisModelABicycle(model) or IsThisModelABike(model) or IsThisModelAHeli(model) then
							if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
								StoreOwnedPoliceMenu()
							else
								ESX.ShowNotification(_U('driver_seat'))
							end
						else
							ESX.ShowNotification(_U('not_correct_veh'))
						end
					else
						ESX.ShowNotification(_U('must_police'))
					end
				elseif CurrentAction == 'police_pound_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenPoliceImpoundMenu()
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_police'))
					end
				elseif CurrentAction == 'mechanic_garage_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenMechanicGarageMenu()
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_mechanic'))
					end
				elseif CurrentAction == 'mechanic_store_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
						if IsThisModelACar(model) or IsThisModelABicycle(model) or IsThisModelABike(model) or IsThisModelAHeli(model) then
							if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
								StoreOwnedMechanicMenu()
							else
								ESX.ShowNotification(_U('driver_seat'))
							end
						else
							ESX.ShowNotification(_U('not_correct_veh'))
						end
					else
						ESX.ShowNotification(_U('must_mechanic'))
					end
				elseif CurrentAction == 'mechanic_pound_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenMechanicImpoundMenu()
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_mechanic'))
					end
				elseif CurrentAction == 'aircraft_garage_point' then
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						OpenAircraftGarageMenu()
					else
						ESX.ShowNotification(_U('cant_in_veh'))
					end
				elseif CurrentAction == 'aircraft_store_point' then
					if IsThisModelAHeli(model) or IsThisModelAPlane(model) then
						if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
							StoreOwnedAircraftMenu()
						else
							ESX.ShowNotification(_U('driver_seat'))
						end
					else
						ESX.ShowNotification(_U('not_correct_veh'))
					end
				elseif CurrentAction == 'aircraft_pound_point' then
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						OpenAircraftImpoundMenu()
					else
						ESX.ShowNotification(_U('cant_in_veh'))
					end
				elseif CurrentAction == 'boat_garage_point' then
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						OpenBoatGarageMenu()
					else
						ESX.ShowNotification(_U('cant_in_veh'))
					end
				elseif CurrentAction == 'boat_store_point' then
					if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
						StoreOwnedBoatMenu()
					else
						ESX.ShowNotification(_U('driver_seat'))
					end
				elseif CurrentAction == 'boat_pound_point' then
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						OpenBoatImpoundMenu()
					else
						ESX.ShowNotification(_U('cant_in_veh'))
					end
				elseif CurrentAction == 'car_garage_point' then
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						OpenCarGarageMenu()
					else
						ESX.ShowNotification(_U('cant_in_veh'))
					end
				elseif CurrentAction == 'car_store_point' then
					if IsThisModelACar(model) or IsThisModelABicycle(model) or IsThisModelABike(model) or IsThisModelAQuadbike(model) then
						if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
							StoreOwnedCarMenu()
						else
							ESX.ShowNotification(_U('driver_seat'))
						end
					else
						ESX.ShowNotification(_U('not_correct_veh'))
					end
				elseif CurrentAction == 'car_pound_point' then
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						OpenCarImpoundMenu()
					else
						ESX.ShowNotification(_U('cant_in_veh'))
					end
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
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

		for k,v in pairs(Config.AircraftPounds) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite (blip, Config.Blips.Pounds.Sprite)
			SetBlipColour (blip, Config.Blips.Pounds.Color)
			SetBlipDisplay(blip, Config.Blips.Pounds.Display)
			SetBlipScale  (blip, Config.Blips.Pounds.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_pound'))
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

		for k,v in pairs(Config.BoatPounds) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite (blip, Config.Blips.Pounds.Sprite)
			SetBlipColour (blip, Config.Blips.Pounds.Color)
			SetBlipDisplay(blip, Config.Blips.Pounds.Display)
			SetBlipScale  (blip, Config.Blips.Pounds.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_pound'))
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

		for k,v in pairs(Config.CarPounds) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite (blip, Config.Blips.Pounds.Sprite)
			SetBlipColour (blip, Config.Blips.Pounds.Color)
			SetBlipDisplay(blip, Config.Blips.Pounds.Display)
			SetBlipScale  (blip, Config.Blips.Pounds.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_pound'))
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

	if Config.Ambulance.Pounds and Config.Ambulance.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
			for k,v in pairs(Config.AmbulancePounds) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite (blip, Config.Blips.JPounds.Sprite)
				SetBlipColour (blip, Config.Blips.JPounds.Color)
				SetBlipDisplay(blip, Config.Blips.JPounds.Display)
				SetBlipScale  (blip, Config.Blips.JPounds.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(_U('blip_ambulance_impound'))
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

	if Config.Police.Pounds and Config.Police.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
			for k,v in pairs(Config.PolicePounds) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite (blip, Config.Blips.JPounds.Sprite)
				SetBlipColour (blip, Config.Blips.JPounds.Color)
				SetBlipDisplay(blip, Config.Blips.JPounds.Display)
				SetBlipScale  (blip, Config.Blips.JPounds.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(_U('blip_police_impound'))
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

	if Config.Mechanic.Pounds and Config.Mechanic.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			for k,v in pairs(Config.MechanicPounds) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite (blip, Config.Blips.JPounds.Sprite)
				SetBlipColour (blip, Config.Blips.JPounds.Color)
				SetBlipDisplay(blip, Config.Blips.JPounds.Display)
				SetBlipScale  (blip, Config.Blips.JPounds.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(_U('blip_mechanic_impound'))
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end
end
