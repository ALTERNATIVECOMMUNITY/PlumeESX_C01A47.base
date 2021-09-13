ESX = nil;
local plate



Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj)
			ESX = obj;
		end);
		Citizen.Wait(0);
	end;
	Citizen.Wait(5000);
	PlayerData = ESX.GetPlayerData();
end);

RegisterNUICallback("showroomPurchaseCurrentVehicle", function(data, cb)
  plate = exports['esx_advancedvehicleshop']:GeneratePlate()
  print(plate)
  while plate == nil do
    wait(10)
  end
  ESX.TriggerServerCallback("showroom:purchaseVehicle", function(success, model, plate)
    print(success, model)
	if success then
    DoScreenFadeOut(0)
    Wait(400)
    DoScreenFadeIn(1000)
    SetNuiFocus(false, false)
    ClearFocus()
    RenderScriptCams(false, false, 0, 1, 0)
    DeleteEntity(vehicle)
    TakeOutVehicle(model)
		cb({
			data = {},
			meta = {
				ok = true,
			}
		});
	else
    print("nomoney")
		TriggerEvent("DoLongHudText", "Not enough money!", 2);
	end
  end, data.model, data.price, data.zoneName, plate, data.label, data.category)
end)

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(GetRandomLetter(3) .. ' ' .. GetRandomNumber(3))
		ESX.TriggerServerCallback('esx_advancedvehicleshop:isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end


function TakeOutVehicle(vehicle)
      enginePercent = 100
      bodyPercent = 100
      currentFuel = 100
      model = vehicle
      ESX.Game.SpawnVehicle(model, vector3(-45.60, -1080.9, 26.706), 70.0, function(vehicle)
        SetVehicleNumberPlateText(vehicle, plate)
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
        local getp = GetVehicleNumberPlateText(vehicle)
				exports["onyxLocksystem"]:givePlayerKeys(getp)
      end)
end

RegisterCommand("cord", function()
coords = GetEntityCoords(PlayerPedId())
head = GetEntityHeading(PlayerPedId())
print(coords, head)
end)