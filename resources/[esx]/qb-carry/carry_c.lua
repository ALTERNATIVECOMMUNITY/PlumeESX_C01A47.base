ESX = nil
local holdingBody = false
local carrying = false
local inVehicle = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('carry:command')
AddEventHandler('carry:command', function()
	if not carrying then
		local players = ESX.Game.GetPlayers()
		local closestDistance = -1
		local closestPlayer = -1
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped)
		closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(coords)	
		print(closestPlayer)
		
		if closestPlayer ~= -1 and closestDistance <= 3.0 then
			if IsPedSittingInAnyVehicle(GetPlayerPed(closestPlayer)) then
				inVehicle = true
			end
			TriggerServerEvent('carry:sync', GetPlayerServerId(closestPlayer))
		end
	else
			carrying = false
			ClearPedTasks(GetPlayerPed(-1))
			DetachEntity(GetPlayerPed(-1), true, false)
			local players = ESX.Game.GetPlayers()
			local closestDistance = -1
			local closestPlayer = -1
			local ped = GetPlayerPed(-1)
			local coords = GetEntityCoords(ped)
			closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(coords)	
			print(closestPlayer)
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				TriggerServerEvent("carry:stop",GetPlayerServerId(closestPlayer))
			end
	end
end,false)

RegisterNetEvent('carry:putInVeh')
AddEventHandler('carry:putInVeh', function()
			carrying = false
			ClearPedTasks(GetPlayerPed(-1))
			DetachEntity(GetPlayerPed(-1), true, false)
			local players = ESX.Game.GetPlayers()
			local closestDistance = -1
			local closestPlayer = -1
			local ped = GetPlayerPed(-1)
			local coords = GetEntityCoords(ped)
			closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(coords)	
			print(closestPlayer)
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				TriggerServerEvent("carry:stop",GetPlayerServerId(closestPlayer), true)
			end
			local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		

end,false)

RegisterNetEvent('carry:syncTarget')
AddEventHandler('carry:syncTarget', function(target)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carrying = true
	
	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		TaskLeaveVehicle(playerPed, vehicle, 64)
		Citizen.Wait(2000)
	end
	
	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 1, -0.68, -0.2, 0.94, 180.0, 180.0, 60.0, 1, 1, 0, 1, 0, 1)
		
	while carrying do

		DisableControlAction(1, 19, true)
		DisableControlAction(0, 34, true)
		DisableControlAction(0, 9, true)
	
		DisableControlAction(0, 288, true)
		DisableControlAction(0, 289, true)
		DisableControlAction(0, 170, true)
		DisableControlAction(0, 73, true)
		DisableControlAction(0, 79, true)
		DisableControlAction(0, 305, true)
		DisableControlAction(0, 82, true)
		DisableControlAction(0, 182, true)

		DisableControlAction(0, 32, true)
		DisableControlAction(0, 8, true)
		DisableControlAction(2, 31, true)
		DisableControlAction(2, 32, true)
		DisableControlAction(1, 33, true)
		DisableControlAction(1, 34, true)
		DisableControlAction(1, 35, true)
		DisableControlAction(1, 21, true)  -- space
		DisableControlAction(1, 22, true)  -- space
		DisableControlAction(1, 23, true)  -- F
		DisableControlAction(1, 24, true)  -- F
		DisableControlAction(1, 25, true)  -- F
	
	
		DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
		DisableControlAction(1, 140, true) --Disables Melee Actions
		DisableControlAction(1, 141, true) --Disables Melee Actions
		DisableControlAction(1, 142, true) --Disables Melee Actions 
		DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisablePlayerFiring(playerPed, true) -- Disable weapon firing

		if not IsEntityPlayingAnim(playerPed, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 3) then
			loadAnim("amb@world_human_bum_slumped@male@laying_on_left_side@base")
			TaskPlayAnim(playerPed, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
		end

		Wait(1)
	end

end)


RegisterNetEvent('carry:syncMe')
AddEventHandler('carry:syncMe', function()
	local playerPed = GetPlayerPed(-1)



	carrying = true

	while carrying do
		if inVehicle then
			Citizen.Wait(2000)
			inVehicle = false
		end	
		if not IsEntityPlayingAnim(playerPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
			loadAnim("missfinale_c2mcs_1")
			TaskPlayAnim(playerPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
		end

		if IsControlJustPressed(0, 38) then
			carrying = false
			ClearPedSecondaryTask(GetPlayerPed(-1))
			DetachEntity(GetPlayerPed(-1), true, false)
			local players = ESX.Game.GetPlayers()
			local closestDistance = -1
			local closestPlayer = -1
			local ped = GetPlayerPed(-1)
			local coords = GetEntityCoords(ped)
			closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(coords)	
			
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				TriggerServerEvent("carry:stop",GetPlayerServerId(closestPlayer))
			end
		end

		Wait(1)
	end

end)

RegisterNetEvent('carry:stop')
AddEventHandler('carry:stop', function(putVeh)
	carrying = false
	ClearPedTasks(PlayerPedId())
	DetachEntity(GetPlayerPed(-1), true, false)
	if putVeh then
		if IsAnyVehicleNearPoint(coords, 5.0) then
			local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

			if DoesEntityExist(vehicle) then
				local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

				for i=maxSeats - 1, 0, -1 do
					if IsVehicleSeatFree(vehicle, i) then
						freeSeat = i
						break
					end
				end

				if freeSeat then
					TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
					dragStatus.isDragged = false
				end
			end
		end
	end
end)


RegisterNetEvent('carryAI')
AddEventHandler('carryAI', function()
	if not holdingBody then
		carryPedNow()
	else
		TriggerEvent('notification', 'You early carry ped.', 2)
	end
end)

function carryPedNow()

    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if distance < 2.0 and not IsPedAPlayer(ped) then
            ClearPedTasksImmediately(ped) 
        	carryPed(ped)
        	return
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped

end

function carryPed(ped)


	TriggerEvent('notification', 'Press E to release carry.')

	loadAnim('anim@narcotics@trash')
	TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1500, 49, 3.0, 0, 0, 0) 
	TaskTurnPedToFaceEntity(PlayerPedId(), ped, 1.0)

	

	SetBlockingOfNonTemporaryEvents(ped, true)		
	SetPedSeeingRange(ped, 0.0)		
	SetPedHearingRange(ped, 0.0)		
	SetPedFleeAttributes(ped, 0, false)		
	SetPedKeepTask(ped, true)	

	loadAnim( "dead" ) 
	TaskPlayAnim(ped, "dead", "dead_f", 8.0, 8.0, -1, 1, 0, 0, 0, 0)

	DetachEntity(ped)
	ClearPedTasks(ped)
	loadAnim( "amb@world_human_bum_slumped@male@laying_on_left_side@base" ) 
	TaskPlayAnim(ped, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
	attachCarryPed(ped)
	holdingBody = true
	ClearPedTasksImmediately(PlayerPedId())
	while (holdingBody) do

		Citizen.Wait(1)


		if not IsEntityPlayingAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
			loadAnim( "missfinale_c2mcs_1" ) 
			TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)

		end

		
		if IsControlJustPressed(0, 38) or (`WEAPON_UNARMED` ~= GetSelectedPedWeapon(PlayerPedId()))  then
			holdingBody = false
			DetachEntity(ped)
			ClearPedTasks(ped)
		end


	end
	ClearPedTasks(PlayerPedId())	  
	DetachEntity(ped)
end

function attachCarryPed(ped)
	AttachEntityToEntity(ped, PlayerPedId(), 1, -0.68, -0.2, 0.94, 180.0, 180.0, 60.0, 1, 1, 0, 1, 0, 1)
	loadAnim( "missfinale_c2mcs_1" ) 
	TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
end

function loadAnim( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

RegisterNetEvent("roll")
AddEventHandler("roll",function(times,weight)

	times = tonumber(times)
	weight = tonumber(weight)
	rollAnim()
	local strg = ""
	for i = 1, times do
		if i == 1 then
			strg = strg .. " " .. math.random(weight) .. "/" .. weight
		else
			strg = strg .. " | " .. math.random(weight) .. "/" .. weight
		end
		
	end
	TriggerServerEvent("showRoll", "Dice rolled " .. strg)
end)

function rollAnim()
    loadAnim( "anim@mp_player_intcelebrationmale@wank" ) 
    TaskPlayAnim( PlayerPedId(), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1500)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'dice', 0.1)
    ClearPedTasks(PlayerPedId())
    Citizen.Wait(500)
end

RegisterNetEvent("showRoll")
AddEventHandler('showRoll', function(user, str)
	local monid = PlayerId()
	local sonid = GetPlayerFromServerId(user)
	if #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(sonid))) < 8.0 and HasEntityClearLosToEntity( GetPlayerPed(monid), GetPlayerPed(sonid), 17 ) then
		TriggerEvent('phone:DoHudTextCoords', str, GetPlayerPed(sonid))
	end
end)

function DrawText3DTest(x,y,z, text, dicks,power)

	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	if dicks > 255 then
		dicks = 255
	end
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextDropshadow(0, 0, 0, 0, 155)
		SetTextEdge(1, 0, 0, 0, 250)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		 SetTextColour(255, 255, 255, dicks)
  
		DrawText(_x,_y)
		local factor = (string.len(text)) / 250
		if dicks < 115 then
			 DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, dicks)
		else
			 DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, 115)
		end
  
	end
  end