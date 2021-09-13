Citizen.CreateThread(function()
	for i = 1, 13 do
		EnableDispatchService(i, EnableDispatch)
	end
	while true do
		-- These natives has to be called every frame.
		SetVehicleDensityMultiplierThisFrame((TrafficAmount/100)+.0)
		SetPedDensityMultiplierThisFrame((PedestrianAmount/100)+.0)
		SetRandomVehicleDensityMultiplierThisFrame((TrafficAmount/100)+.0)
		SetParkedVehicleDensityMultiplierThisFrame((ParkedAmount/100)+.0)
		SetScenarioPedDensityMultiplierThisFrame((PedestrianAmount/100)+.0, (PedestrianAmount/100)+.0)
		SetRandomBoats(EnableBoats)
		SetRandomTrains(EnableTrains)
                SetGarbageTrucks(EnableGarbageTrucks)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        
        local playerLocalisation = GetEntityCoords(GetPlayerPed(-1))
        ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)

    end
end)
