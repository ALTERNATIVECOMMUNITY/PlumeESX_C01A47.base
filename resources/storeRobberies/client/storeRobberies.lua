ped = nil
local objects = {}
local robbing = false
canRob = true
canRobType = nil
lockpicking = false
registering = false
safeboxing = false
currentStore = 0
copsCalled = false
serverKeyGen = 0
ESX = nil
local dankGeneral = vector3(-3243.22, 1001.35, 12.83)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
                   
        end)
        Citizen.Wait(1)
    end
    PlayerData = ESX.GetPlayerData()
end)


RegisterNetEvent("storeRobberies:openStore")
AddEventHandler("storeRobberies:openStore", function()
    local playerLoc = GetEntityCoords(GetPlayerPed(-1))
    if #(playerLoc - dankGeneral) < 5 then
	    exports["mf-inventory"]:openOtherInventory('general_store:2')
    else
        exports["mf-inventory"]:openOtherInventory('general_store:1')
    end
end)

RegisterNetEvent("storeRobberies:openAmmunation")
AddEventHandler("storeRobberies:openAmmunation", function()
    ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
		if hasLicense then
			exports["mf-inventory"]:openOtherInventory('ammunationStore:1')
        else
            exports['mythic_notify']:DoHudText('error', 'You dont have a Weapon License')
        end
	end, GetPlayerServerId(globalPlayerId), 'weapon')
end)

RegisterNetEvent("storeRobberies:openHuntingAmmunation")
AddEventHandler("storeRobberies:openHuntingAmmunation", function()
    ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
		if hasLicense then
			exports["mf-inventory"]:openOtherInventory('ammunationHuntingStore:1')
        else
            exports['mythic_notify']:DoHudText('error', 'You dont have a Hunting License')
        end
	end, GetPlayerServerId(globalPlayerId), 'hunt')
end)

Citizen.CreateThread(function()
	local store = {`csb_customer`, `csb_hao, csb_chef`, `cs_jimmyboston`, `a_m_m_fatlatin_01`, `a_f_y_hipster_02`, `a_f_m_soucent_02`, `a_f_m_soucent_01`, `a_f_m_skidrow_01`, `a_f_m_downtown_01`, `a_m_y_yoga_01`}
	exports["bt-target"]:AddTargetModel(store, {
	
	options = {
	{
		event = "storeRobberies:openStore",
		icon = "fas fa-cash-register",
		label = "Open Store",
	},
	},
		job = {"all"},
		distance = 3
	})
	exports["bt-target"]:AddBoxZone("openAmmunation", vector3(23.55, -1106.619, 29.78), 0.4, 0.6, {
		name="openAmmunation",
		heading=160,
		debugPoly=true,
		minZ=29.68,
		maxZ=30.2
		}, {
			options = {
				{
					event = "storeRobberies:openAmmunation",
					icon = "fas fa-cash-register",
					label = "Open Store",
				},
			},
		job = {"all"},
		distance = 3.0
	})
    exports["bt-target"]:AddBoxZone("openAmmunationPopular", vector3(808.86, -2158.3, 29.78), 0.4, 0.6, {
		name="openAmmunationPopular",
		heading=360.0,
		debugPoly=true,
		minZ=29.68,
		maxZ=30.2
		}, {
			options = {
				{
					event = "storeRobberies:openAmmunation",
					icon = "fas fa-cash-register",
					label = "Open Store",
				},
			},
		job = {"all"},
		distance = 3.0
	})
    exports["bt-target"]:AddBoxZone("openAmmunationVespucci", vector3(841.0564, -1034.562, 28.28), 0.4, 0.6, {
		name="openAmmunationVespucci",
		heading=360.0,
		debugPoly=true,
		minZ=28.18,
		maxZ=28.75
		}, {
			options = {
				{
					event = "storeRobberies:openAmmunation",
					icon = "fas fa-cash-register",
					label = "Open Store",
				},
			},
		job = {"all"},
		distance = 3.0
	})
    exports["bt-target"]:AddBoxZone("openAmmunationPalomino", vector3(-660.9294, -934.1031, 21.74),0.7, 0.7, {
		name="openAmmunationPalomino",
		heading=180.0,
		debugPoly=true,
		minZ=21.64,
		maxZ=22.2
		}, {
			options = {
				{
					event = "storeRobberies:openAmmunation",
					icon = "fas fa-cash-register",
					label = "Open Store",
				},
			},
		job = {"all"},
		distance = 3.0
	})
    exports["bt-target"]:AddBoxZone("openAmmunationDelPerro", vector3(-1304.976, -395.8181, 36.8146),0.7, 0.7, {
		name="openAmmunationDelPerro",
		heading=75.778,
		debugPoly=true,
		minZ=36.71,
		maxZ=37.3
		}, {
			options = {
				{
					event = "storeRobberies:openAmmunation",
					icon = "fas fa-cash-register",
					label = "Open Store",
				},
			},
		job = {"all"},
		distance = 3.0
	})
    exports["bt-target"]:AddBoxZone("openAmmunationSpanish", vector3(252.8583, -51.628, 70.06),0.7, 0.7, {
		name="openAmmunationSpanish",
		heading=70.0,
		debugPoly=true,
		minZ=69.96,
		maxZ=70.56
		}, {
			options = {
				{
					event = "storeRobberies:openAmmunation",
					icon = "fas fa-cash-register",
					label = "Open Store",
				},
			},
		job = {"all"},
		distance = 3.0
	})
    exports["bt-target"]:AddBoxZone("openAmmunationRoute68", vector3(-1117.612, 2700.264, 18.67303),0.7, 0.7, {
		name="openAmmunationRoute68",
		heading=221.827,
		debugPoly=true,
		minZ=18.57,
		maxZ=19.17
		}, {
			options = {
				{
					event = "storeRobberies:openHuntingAmmunation",
					icon = "fas fa-cash-register",
					label = "Open Store",
				},
			},
		job = {"all"},
		distance = 3.0
	})
    exports["bt-target"]:AddBoxZone("openAmmunationAlgonquin", vector3(1693.570, 3761.601, 34.824),0.7, 0.7, {
		name="openAmmunationAlgonquin",
		heading=227.39,
		debugPoly=true,
		minZ=34.724,
		maxZ=35.324
		}, {
			options = {
				{
					event = "storeRobberies:openAmmunation",
					icon = "fas fa-cash-register",
					label = "Open Store",
				},
			},
		job = {"all"},
		distance = 3.0
	})
    exports["bt-target"]:AddBoxZone("openAmmunationPaleto", vector3(-330.2908, 6085.548, 31.57),0.7, 0.7, {
		name="openAmmunationAlgonquin",
		heading=224.99,
		debugPoly=true,
		minZ=31.47,
		maxZ=32.07
		}, {
			options = {
				{
					event = "storeRobberies:openAmmunation",
					icon = "fas fa-cash-register",
					label = "Open Store",
				},
			},
		job = {"all"},
		distance = 3.0
	})
end)

RegisterNetEvent('storeRobberies:client:shopkeeperUpdate')
AddEventHandler('storeRobberies:client:shopkeeperUpdate', function(shopkeepers)
        for v = 1, #Config.Shops do
            Config.Shops[v].shopKeeper = shopkeepers[v]
        end
end)

RegisterNetEvent('storeRobberies:client:randomKeyGen')
AddEventHandler('storeRobberies:client:randomKeyGen', function(key)
    serverKeyGen = key
end)

RegisterNetEvent('storeRobberies:client:registerOpen')
AddEventHandler('storeRobberies:client:registerOpen', function(store, state)
    Config.Shops[store].registerOpened = state
end)

RegisterNetEvent('storeRobberies:client:safeOpen')
AddEventHandler('storeRobberies:client:safeOpen', function(store, state)
    Config.Shops[store].safeOpened = state
end)

RegisterNetEvent('storeRobberies:client:canRobRunning')
AddEventHandler('storeRobberies:client:canRobRunning', function(store, state)
    Config.Shops[store].canRob = state
end)


RegisterNetEvent('storeRobberies:client:shopkeeperStateUpdate')
AddEventHandler('storeRobberies:client:shopkeeperStateUpdate', function(state)
    for v = 1, #Config.Shops do
        Config.Shops[v].shopKeeperState = state[v]
    end
end)

RegisterNetEvent('storeRobberies:client:registerOpenedUpdate')
AddEventHandler('storeRobberies:client:registerOpenedUpdate', function(state)
    for v = 1, #Config.Shops do
        Config.Shops[v].registerOpened = state[v]
    end
end)

RegisterNetEvent('storeRobberies:client:safeOpenedUpdate')
AddEventHandler('storeRobberies:client:safeOpenedUpdate', function(state)
    for v = 1, #Config.Shops do
        Config.Shops[v].safeOpened = state[v]
    end
end)

RegisterNetEvent('storeRobberies:client:callCops')
AddEventHandler('storeRobberies:client:callCops', function()
    Citizen.Wait(60 * 1000 * 2)
    copsCalled = false
end)


RegisterNetEvent('storeRobberies:client:safeCodeUpdate')
AddEventHandler('storeRobberies:client:safeCodeUpdate', function(safecodes)
    for v = 1, #Config.Shops do
        Config.Shops[v].safeCode = safecodes[v]
    end
end)

RegisterNetEvent('storeRobberies:client:canRobUpdater')
AddEventHandler('storeRobberies:client:canRobUpdater', function(canRobList)
    for v = 1, #Config.Shops do
        Config.Shops[v].canRob = canRobList[v]
    end
end)

RegisterNetEvent('storeRobberies:client:shopkeeperReset')
AddEventHandler('storeRobberies:client:shopkeeperReset', function(shopkeepers)
    Citizen.Wait(1000)

    for i = 1, #Config.Shops do
        Config.Shops[i].shopKeeper = shopkeepers[i]
    end

    if DoesEntityExist(ped) then
        DeletePed(ped)
    end
end)

RegisterNetEvent('storeRobberies:client:resetStore')
AddEventHandler('storeRobberies:client:resetStore', function(i)
    if DoesEntityExist(ped) then
        DeletePed(ped)
    end
end)

RegisterNetEvent('storeRobberies:client:canRob')
AddEventHandler('storeRobberies:client:canRob', function(booleanVal, type)
    canRob = booleanVal
    canRobType = type
end)

RegisterNetEvent('storeRobberies:client:animator')
AddEventHandler('storeRobberies:client:animator', function(number, dict, anim, time)
    if(ped ~= nil)then
        if(DoesEntityExist(ped))then
            if(time ~= nil)then
                ClearPedTasks(ped)
                Citizen.Wait(300)
                loadDict(dict)
                local timer = GetGameTimer() + time * 1000
                while timer >= GetGameTimer() do
                    if(not IsEntityPlayingAnim(ped, dict, anim, 3))then
                        TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                        RemoveAnimDict(dict)
                    end
                    Wait(100)
                end
            else
                ClearPedTasks(ped)
                Citizen.Wait(300)
                loadDict(dict)
                TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                RemoveAnimDict(dict)
            end
        end
    end
end)

Citizen.CreateThread(function()
    local distance = 1000
    Citizen.Wait(1000)
    while true do
        for v = 1, #Config.Shops do
            if #(globalPlayerCoords - Config.Shops[v].shopKeeperCoords) <= distance then
                distance = #(globalPlayerCoords - Config.Shops[v].shopKeeperCoords)
                currentStore = v
            end
        end
        Citizen.Wait(500)
        distance = 1000
    end
end)

RegisterNetEvent('storeRobberies:client:fightBack')
AddEventHandler('storeRobberies:client:fightBack', function(store, safe, targeter)

    target = GetPlayerPed(GetPlayerFromServerId(targeter))

    if(store == currentStore and DoesEntityExist(ped)and DoesEntityExist(target))then
        pedTalk()

        if(safe)then
            TaskCombatPed(ped, target, 0, 16)
            GiveWeaponToPed(ped, `WEAPON_BAT`, 150, 0, 1)
        else
            GiveWeaponToPed(ped, Config.Shopkeepers[Config.Shops[store].shopKeeper].Weapons[math.random(1, #Config.Shopkeepers[Config.Shops[store].shopKeeper].Weapons)], 150, 0, 1)
            TaskCombatPed(ped, target, 0, 16)
            TaskShootAtEntity(ped, target, 20000, 1)
        end

        while(not IsPedDeadOrDying(target) and not IsPedDeadOrDying(ped))do
            Citizen.Wait(200)
        end

        ClearPedTasks(ped)
    end
end)

RegisterNetEvent('storeRobberies:client:pedHandler')
AddEventHandler('storeRobberies:client:pedHandler', function()
    Citizen.CreateThread(function()
        while true do
                v = currentStore
                if(#(globalPlayerCoords - Config.Shops[v].shopKeeperCoords) <= 20.0)then
                    if(not DoesEntityExist(ped))then
                        ped = _CreatePed(Config.Shopkeepers[Config.Shops[v].shopKeeper].model, Config.Shops[v].shopKeeperCoords, Config.Shops[v].shopKeeperHeading)
                        local brokenCashRegister = GetClosestObjectOfType(GetEntityCoords(ped), 5.0, GetHashKey('prop_till_01_dam'))
                        if DoesEntityExist(brokenCashRegister) then
                            CreateModelSwap(GetEntityCoords(brokenCashRegister), 0.5, GetHashKey('prop_till_01_dam'), GetHashKey('prop_till_01'), false)
                        end
                    
                        if(not Config.Shops[v].shopKeeperState)then
                            SetEntityHealth(ped, 0)
                        end
                    end
                else
                    if(DoesEntityExist(ped))then
                        DeletePed(ped)
                    end
                    Citizen.Wait(1000)
                end
            Citizen.Wait(500)
        end
    end)
end)

Citizen.CreateThread(function()
    
    ped = nil

    while(globalPlayerId == nil)do
        print("Initializing globalPlayerId value")
        Wait(100)
    end

    while(Config.Shops[1].shopKeeper == nil)do
        TriggerServerEvent("storeRobberies:server:randomKeyGen", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("storeRobberies:server:shopkeeperUpdate", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("storeRobberies:server:shopkeeperStateUpdate", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("storeRobberies:server:registerOpenedUpdate", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("storeRobberies:server:safeOpenedUpdate", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("storeRobberies:server:safeCodeUpdate", GetPlayerServerId(globalPlayerId))
         
        TriggerServerEvent("storeRobberies:server:canRobUpdater", GetPlayerServerId(globalPlayerId))
        Citizen.Wait(1000)
    end

    TriggerEvent("storeRobberies:client:pedHandler", currentStore)

    Citizen.CreateThread(function()
        while true do
                if(DoesEntityExist(ped))then
                    if IsPedDeadOrDying(ped) then
                        TriggerServerEvent('storeRobberies:server:pedDead', currentStore)
                        TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
                        if not copsCalled then
                            TriggerServerEvent("storeRobberies:server:callCops", currentStore)
                            TriggerEvent("storeRobberies:client:callCops")
                            copsCalled = true
                        end
                    end
                end
            Wait(500)
        end
    end)

    while true do
            Wait(0)
            local me = globalPlayerPedId
            if globalIsPedArmed or globalIsPedMeleeArmed == 1 then
                melee = false
                if(globalIsPedMeleeArmed == 1)then
                    melee = IsControlJustPressed(1, 25)
                else
                    melee = false
                end

                if globalIsPlayerFreeAiming or melee then
                    Wait(5)
                    if(DoesEntityExist(ped))then
                        if(#(globalPlayerCoords - Config.Shops[v].shopKeeperCoords) <= 5.0)then
                            if HasEntityClearLosToEntityInFront(me, ped, 19) and not IsPedDeadOrDying(ped) then
                                if not robbing then
                                    if(Config.Shops[currentStore].canRob)then
                                        TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, false)
                                        TriggerServerEvent('storeRobberies:server:canRob',GetPlayerServerId(globalPlayerId), currentStore)
                                        while canRob == nil do
                                            Wait(0)
                                        end

                                        local fightBack = 0
                                        local scared = false

                                        if(Config.Shopkeepers[Config.Shops[currentStore].shopKeeper].CallCopsEarlyChance > math.random(1,100))then
                                            TriggerEvent("storeRobberies:client:callCops")
                                            TriggerServerEvent("storeRobberies:server:callCops", currentStore)
                                            local data = {displayCode = '211', description = 'Robbery', isImportant = 0, recipientList = {'police'}, length = '10000', infoM = 'fa-info-circle', info = 'Store Robbery'}
                                            local dispatchData = {dispatchData = data, caller = 'Alarm', coords = Config.Shops[currentStore].blip}
                                            print('triggered')
                                            TriggerServerEvent('wf-alerts:svNotify', dispatchData)
                                            copsCalled = true
                                        end

                                        if(Config.Shopkeepers[Config.Shops[currentStore].shopKeeper].FightBackChance > math.random(1,100))then
                                            if(canRob)then
                                                fightBack = math.random(1,3)
                                            else
                                                fightBack = 1
                                            end
                                        else
                                            fightBack = 0
                                        end

                                        if(Config.Shopkeepers[Config.Shops[currentStore].shopKeeper].ScaredChance > math.random(1,100))then
                                            scared = true
                                        end

                                        local anim,dict,animCamera,dictCamera
                                        local dictCamera = "anim@heists@prison_heiststation@cop_reactions"
                                        local animCamera = "cop_b_idle"

                                        if(scared)then
                                            anim = "missheist_agency2ahands_up"
                                            dict = "handsup_anxious"
                                            PlayPain(ped, 7, 0, 0)
                                            SetFacialIdleAnimOverride(ped, "shocked_1")
                                        else
                                            anim = "random@mugging3"
                                            dict = "handsup_standing_base"
                                            PlayPain(ped, 6, 0, 0)
                                            SetFacialIdleAnimOverride(ped, "mood_stressed_1")
                                        end

                                        TriggerServerEvent("storeRobberies:server:animator", currentStore, anim, dict)
                                        local pedCoords = GetEntityCoords(ped)
                                        
                                        if canRob == true then
                                            robbing = true

                                            Citizen.CreateThread(function()
                                                while robbing do Wait(0) if IsPedDeadOrDying(ped) then robbing = false end end
                                            end)

                                            if(fightBack == 1)then
                                                fightBack_function(currentStore)
                                            else
                                                local randomise
                                                if(fightBack == 2)then
                                                    randomiser  = math.random(200,4800)
                                                end

                                                while not IsPedDeadOrDying(ped) and #(globalPlayerCoords - Config.Shops[v].shopKeeperCoords) <= 7.5 do
                                                    pedCoords = GetEntityCoords(ped)

                                                    DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, Languages[Config.Language]['robbingInitialMessage'])

                                                    if(Config.UsingSurveillanceSystem)then
                                                        DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z-0.10, Languages[Config.Language]['robbingInitialMessage-Surv'])
                                                        if IsControlJustPressed(1, Config.DisableCamerasButton) then
                                                            local timer = 0
                                                            loadDict(dictCamera)
                                                            TaskPlayAnim(ped, dictCamera, animCamera, 8.0, -8.0, -1, 1, 0, false, false, false)
                                                            RemoveAnimDict(dictCamera)
                                                            while(timer <= 5000 and not IsPedDeadOrDying(ped) and  #(globalPlayerCoords - Config.Shops[v].shopKeeperCoords) <= 7.5)do

                                                                if(fightBack == 2 and timer > randomiser)then
                                                                    fightBack_function(currentStore)
                                                                    break;
                                                                end
                                                                

                                                                DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, Languages[Config.Language]['secondaryMessage'])
                                                                DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z-0.10, Languages[Config.Language]['disablingCameras'] .. " - " .. round(timer / 50, 1) .. "%")
                                                                timer = timer + randomFloat(4.5, 8.2)
                                                                Citizen.Wait(5)
                                                            end

                                                            if timer>= 5000 then
                                                                if(not (Config.Shopkeepers[Config.Shops[currentStore].shopKeeper].DisableCamerasFakeChance > math.random(1,100)))then
                                                                    
                                                                    if((fightBack == 3 and not IsPedDeadOrDying(ped)) or Config.Shops[currentStore].registerOpened)then
                                                                        fightBack_function(currentStore)
                                                                        break;
                                                                    else
                                                                        for k, v in pairs(Config.Shops[currentStore].camera) do
                                                                            TriggerServerEvent("cameraSystem:server:updateState", v, false)
                                                                        end
                                                                    end
                                                                end
                                                                TriggerServerEvent("storeRobberies:server:animator", currentStore, anim, dict)
                                                            end

                                                        end
                                                    else
                                                        DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z-0.10, Languages[Config.Language]['robbingInitialMessage-noSurv'])
                                                    end
                                                        if IsControlJustPressed(1, Config.EmptyRegisterButton) then
                                                            local timer = 0
                                                            loadDict(dictCamera)
                                                            TaskPlayAnim(ped, dictCamera, animCamera, 8.0, -8.0, -1, 1, 0, false, false, false)
                                                            RemoveAnimDict(dictCamera)
                                                            while(timer <= 5000 and not IsPedDeadOrDying(ped) and #(globalPlayerCoords - pedCoords) <= 7.5)do

                                                                if(fightBack == 2 and timer > randomiser)then
                                                                    fightBack_function(currentStore)
                                                                    break;
                                                                end
                                                                

                                                                DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, Languages[Config.Language]['secondaryMessage'])
                                                                DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z-0.10, Languages[Config.Language]['unlockRegister'] .. " - " .. round(timer / 50, 1) .. "%")
                                                                timer = timer + randomFloat(8.5, 12.2)
                                                                Citizen.Wait(5)
                                                            end

                                                            if timer >= 5000 then
                                                                if(Config.Shops[currentStore].safeType ~= "padlock")then
                                                                    if(fightBack == 0 and Config.Shopkeepers[Config.Shops[currentStore].shopKeeper].GiveSafeCodeChance > math.random(1,100))then
                                                                        Citizen.CreateThread(function()
                                                                            messager = GetGameTimer() + 10000
                                                                            while messager >= GetGameTimer() do
                                                                                if IsPedDeadOrDying(ped) then
                                                                                    break
                                                                                end
                                                                                DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, Languages[Config.Language]['safecode'] .. " ".. Config.Shops[currentStore].safeCode)
                                                                                Wait(7)
                                                                            end                                                        
                                                                        end)
                                                                    end
                                                                end

                                                                if((fightBack == 3 and not IsPedDeadOrDying(ped)) or Config.Shops[currentStore].registerOpened)then
                                                                    fightBack_function(currentStore)
                                                                    break;
                                                                elseif not IsPedDeadOrDying(ped) then
                                                                    TriggerServerEvent("storeRobberies:server:animator", currentStore, anim, dict)
                                                                    local cashRegister = GetClosestObjectOfType(GetEntityCoords(ped), 5.0, GetHashKey('prop_till_01'))
                                                                    if DoesEntityExist(cashRegister) then
                                                                        CreateModelSwap(GetEntityCoords(cashRegister), 0.5, GetHashKey('prop_till_01'), GetHashKey('prop_till_01_dam'), false)
                                                                    end
                                                        
                                                                    local model = GetHashKey('prop_poly_bag_01')
                                                                    RequestModel(model)
                                                                    while not HasModelLoaded(model) do Wait(0) end
                                                                    local bag = CreateObject(model, GetEntityCoords(ped), false, false)
                                                                                
                                                                    AttachEntityToEntity(bag, ped, GetPedBoneIndex(ped, 60309), 0.1, -0.11, 0.08, 0.0, -75.0, -75.0, 1, 1, 0, 0, 2, 1)
                                                                    timer = GetGameTimer() + 3000
                                                                    while timer >= GetGameTimer() do
                                                                        if IsPedDeadOrDying(ped) then
                                                                            break
                                                                        end
                                                                        Wait(0)
                                                                    end
                                                                    if not IsPedDeadOrDying(ped) then
                                                                        DetachEntity(bag, true, false)
                                                                        timer = GetGameTimer() + 30
                                                                        while timer >= GetGameTimer() do
                                                                            if IsPedDeadOrDying(ped) then
                                                                                break
                                                                            end
                                                                            Wait(0)
                                                                        end
                                                                        SetEntityHeading(bag, Config.Shops[currentStore].shopKeeperHeading)
                                                                        ApplyForceToEntity(bag, 3, vector3(0.0, 50.0, 0.0), 0.0, 0.0, 0.0, 0, true, true, false, false, true)
                                                                        ApplyForceToEntity(bag, 3, vector3(0.0, 50.0, 0.0), 0.0, 0.0, 0.0, 0, true, true, false, false, true)
                                                                        table.insert(objects, {bank = ped, object = bag})
                                                                        Citizen.CreateThread(function()
                                                                            while true do
                                                                                Wait(5)
                                                                                if DoesEntityExist(bag) then
                                                                                    if  #(globalPlayerCoords - GetEntityCoords(bag)) <= 1.5 then
                                                                                        PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
                                                                                        DeleteObject(bag)
                                                                                        TriggerServerEvent("storeRobberies:server:registerMoney", GetPlayerServerId(globalPlayerId), currentStore, serverKeyGen)
                                                                                        break
                                                                                    end
                                                                                else
                                                                                    break
                                                                                end
                                                                            end
                                                                        end)
                                                                    else
                                                                        DeleteObject(bag)
                                                                    end
                                                                end
                                                                TriggerServerEvent("storeRobberies:server:animator", currentStore, 'mp_am_hold_up', "cower_intro")
                                                                TriggerServerEvent("storeRobberies:server:registerOpen", currentStore)
                                                                TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
                                                                break
                                                            end

                                                        end
                                                    Citizen.Wait(7)
                                                end
                                                TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
                                            end
                                        elseif canRobType == 'cops' then
                                            if(fightBack == 1)then
                                                fightBack_function(currentStore)
                                            else
                                                local wait = GetGameTimer()+10000
                                                while wait >= GetGameTimer() do
                                                    if  #(globalPlayerCoords - Config.Shops[v].shopKeeperCoords) <= 7.5 then
                                                        Wait(7)
                                                        DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, Languages[Config.Language]['no_cops'])
                                                    else
                                                        Wait(7)
                                                        wait = GetGameTimer()
                                                    end
                                                end
                                                TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
                                            end
                                            ClearPedTasks(ped)
                                            SetFacialIdleAnimOverride(ped, "mood_normal_1")
                                        else
                                            if(fightBack == 1)then
                                                fightBack_function(currentStore)
                                            else
                                                local wait = GetGameTimer()+10000
                                                while wait >= GetGameTimer() do
                                                    if  #(globalPlayerCoords - Config.Shops[v].shopKeeperCoords) <= 7.5 then
                                                        Wait(7)
                                                        DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, Languages[Config.Language]['robbed'])
                                                    else
                                                        Wait(7)
                                                        wait = GetGameTimer()
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                Citizen.Wait(100)
                                TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
                            end
                        else
                            Citizen.Wait(100)
                            TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
                        end
                    else
                        Citizen.Wait(100)
                        TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
                    end
                else
                    Citizen.Wait(100)
                end
            else
                Citizen.Wait(500)
            end
    end
end)

RegisterNetEvent('storeRobberies:client:onPedDeath')
AddEventHandler('storeRobberies:client:onPedDeath', function(v)
    SetEntityHealth(ped, 0)
    Config.Shops[v].shopKeeperState = false
end)

function lockpick(bool)
    lockpicking = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    SetCursorLocation(0.5, 0.2)
    uiOpen = bool
end

RegisterNUICallback('success', function()
    if currentStore ~= 0 then
        lockpick(false)
        lockpicking = true
        registering = true
        takeAnim()
        PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
        TriggerServerEvent("storeRobberies:server:registerOpen", currentStore)
        TriggerServerEvent("storeRobberies:server:registerMoney", GetPlayerServerId(globalPlayerId), currentStore, serverKeyGen)
        Citizen.Wait(500)
        lockpicking = false
        registering = false
        TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
    else
        lockpick(false)
        Citizen.Wait(500)
        TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
    end
end)

RegisterNUICallback('callcops', function()
end)

RegisterNUICallback('PadLockSuccess', function()
    Citizen.Wait(1000)
    safeboxing = false
    TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
end)

RegisterNUICallback('PadLockClose', function()
    SetNuiFocus(false, false)
    copsCalled = false
    Citizen.Wait(1000)
    safeboxing = false
    TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
end)

RegisterNUICallback("CombinationFail", function(data, cb)
    Citizen.Wait(1000)
    safeboxing = false
    TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
end)

RegisterNUICallback('fail', function()
    lockpick(false)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('exit', function()
    lockpick(false)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('TryCombination', function(data, cb)
        if tonumber(data.combination) ~= nil then
            if tonumber(data.combination) == Config.Shops[currentStore].safeCode then
                TriggerServerEvent("storeRobberies:server:safeOpen", currentStore)
                PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
                SetNuiFocus(false, false)
                SendNUIMessage({
                    action = "closeKeypad",
                    error = false,
                })
                takeAnim()
                TriggerServerEvent("storeRobberies:server:safeMoney", GetPlayerServerId(globalPlayerId), currentStore, serverKeyGen)
            else
                SetNuiFocus(false, false)
                SendNUIMessage({
                    action = "closeKeypad",
                    error = true,
                })
            end
        end
        Citizen.Wait(1000)
        safeboxing = false
        TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, true)
end)    