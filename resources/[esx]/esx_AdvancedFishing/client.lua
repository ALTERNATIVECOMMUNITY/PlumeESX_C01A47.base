ESX = nil
Citizen.CreateThread(function()
	while true do
		Wait(5)
		if ESX ~= nil then
		
		else
			ESX = nil
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		end
	end
end)

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local fishing = false
local lastInput = 0
local pause = false
local pausetimer = 0
local correct = 0
local fishingZone = false
local finished = -1
local bait = "none"
			
local blip2 = AddBlipForCoord(Config.SellTurtle.x, Config.SellTurtle.y, Config.SellTurtle.z)

			SetBlipSprite (blip2, 68)
			SetBlipDisplay(blip2, 4)
			SetBlipScale  (blip2, 0.9)
			SetBlipColour (blip2, 49)
			SetBlipAsShortRange(blip2, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Sea Turtle dealer")
			EndTextCommandSetBlipName(blip2)
			
local blip3 = AddBlipForCoord(Config.SellShark.x, Config.SellShark.y, Config.SellShark.z)

			SetBlipSprite (blip3, 68)
			SetBlipDisplay(blip3, 4)
			SetBlipScale  (blip3, 0.9)
			SetBlipColour (blip3, 49)
			SetBlipAsShortRange(blip3, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Shark meat dealer")
			EndTextCommandSetBlipName(blip3)
			
	
Citizen.CreateThread(function()
	exports["bt-polyzone"]:AddBoxZone("fishingSpot1", vector3(-3427.53, 967.27, 8.3), 10, 10, {
        name="fishingSpot1",
        heading=87.4,
        minZ=7,
        maxZ=10
    })
	exports["bt-polyzone"]:AddBoxZone("fishingSpot2", vector3(-1846.76, -1253.44, 8.6), 5, 15, {
        name="fishingSpot2",
        heading=137.0,
        minZ=7,
        maxZ=10
    })
	exports["bt-polyzone"]:AddBoxZone("fishingSpot3", vector3(-1610.35, 5258.27, 3.5), 10, 10, {
        name="fishingSpot3",
        heading=137.0,
        minZ=3.0,
        maxZ=5
    })
end)

RegisterNetEvent('bt-polyzone:enter')
AddEventHandler('bt-polyzone:enter', function(name)
    if string.find(name, "fishingSpot") then 
        fishingZone = true
    end
end)

RegisterNetEvent('bt-polyzone:exit')
AddEventHandler('bt-polyzone:exit', function(name)
    if string.find(name, "fishingSpot") then 
        fishingZone = false
    end
end)
			
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	while true do
		Wait(5)
		if fishing then
			if IsControlJustReleased(0, Keys['X']) then
				TriggerEvent('fishing:break')
				sendMessage("Stopped fishing")
			end
			if fishing then
		
				playerPed = GetPlayerPed(-1)
				local pos = GetEntityCoords(GetPlayerPed(-1))
				if pos.y >= 7700 or pos.y <= -4000 or pos.x <= -3700 or pos.x >= 4300 or IsPedInAnyVehicle(GetPlayerPed(-1)) or fishingZone then
					
				else
					fishing = false
					sendMessage("Stopped fishing", 'error')
				end
				if IsEntityDead(playerPed) or IsEntityInWater(playerPed) then
					fishing = false
					sendMessage("Stopped fishing", 'error')
				end
			end
			
		end
		
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.SellShark.x, Config.SellShark.y, Config.SellShark.z, true) <= 3 then
			TriggerServerEvent('fishing:startSelling', "shark")
			Citizen.Wait(4000)
		end
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.SellTurtle.x, Config.SellTurtle.y, Config.SellTurtle.z, true) <= 3 then
			TriggerServerEvent('fishing:startSelling', "turtle")
			Citizen.Wait(4000)
		end
		
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = math.random(Config.FishTime.a , Config.FishTime.b)
		Wait(wait)
			if fishing then
				exports['mythic_notify']:DoHudText("success", "Fish is taking the bait, reel it in!")
				finished = -1
    			finished = exports["np-taskbarskill"]:taskBar(2500,10)
				Wait(1000)
				if finished == 100 then
					exports['mythic_notify']:DoHudText('inform', 'You successfully reeled in the fish!')
					TriggerServerEvent('fishing:catch', bait, fishingZone)
				else 
					exports['mythic_notify']:DoHudText('error', 'The fish broke off the hook!')
				end
			end
			
	end
end)

RegisterNetEvent('fishing:message')
AddEventHandler('fishing:message', function(message, type)
	if type == nil then
		exports['mythic_notify']:DoHudText('inform', message)
	else
		exports['mythic_notify']:DoHudText(type, message)
	end
end)

function sendMessage(message, type)
	if type == nil then
		exports['mythic_notify']:DoHudText('inform', message)
	else
		exports['mythic_notify']:DoHudText(type, message)
	end
end

RegisterNetEvent('fishing:break')
AddEventHandler('fishing:break', function()
	fishing = false
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('fishing:spawnPed')
AddEventHandler('fishing:spawnPed', function()
	
	RequestModel( GetHashKey( "A_C_SharkTiger" ) )
		while ( not HasModelLoaded( GetHashKey( "A_C_SharkTiger" ) ) ) do
			Citizen.Wait( 1 )
		end
	local pos = GetEntityCoords(GetPlayerPed(-1))
	
	local ped = CreatePed(29, 0x06C3F072, pos.x, pos.y, pos.z, 90.0, true, false)
	SetEntityHealth(ped, 0)
end)

RegisterNetEvent('fishing:setbait')
AddEventHandler('fishing:setbait', function(bool)
	bait = bool
	print(bait)
end)

RegisterNetEvent('fishing:fishstart')
AddEventHandler('fishing:fishstart', function()
	playerPed = GetPlayerPed(-1)
	local pos = GetEntityCoords(GetPlayerPed(-1))
	if IsPedInAnyVehicle(playerPed) then
		sendMessage("You can not fish from a vehicle")
	else
		if pos.y >= 7700 or pos.y <= -4000 or pos.x <= -3700 or pos.x >= 4300 or fishingZone then
			sendMessage("Fishing started")
			TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_STAND_FISHING", 0, true)
			fishing = true
		else
			print('triggered')
			sendMessage("You need to go further away from the shore")
		end
	end
	
end, false)


