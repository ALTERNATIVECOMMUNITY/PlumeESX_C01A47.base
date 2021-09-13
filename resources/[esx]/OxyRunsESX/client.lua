local checkBox = false
local status = false
local hasBox = false
local zoneCreated = false
local startLoop = false
local playerData
local count
local pedCoords
ESX = nil

TriggerEvent("esx:getSharedObject",function(obj)
    ESX = obj
    playerData = ESX.GetPlayerData()
    --print(playerData.identifier)
end)

started = false
gotdest = false

RegisterCommand("trackdeliv", function(source, args, raw)
    local coords = GetEntityCoords(pedCar)
	SetNewWaypoint(coords.x, coords.y)
end, false)

function gotoOxy()


    currentRoute       = Config.Routes[math.random(1, #Config.Routes)]
    currentDestination = currentRoute.Destinations[math.random(1, #currentRoute.Destinations)]
    gotdest = true
    SetNewWaypoint(currentDestination.x, currentDestination.y)
    DeliveryBlip = AddBlipForCoord(currentDestination.x, currentDestination.y, 45.87)
end

RegisterNetEvent("oxyrunesx:startRun")
AddEventHandler("oxyrunesx:startRun", function()
    TriggerServerEvent("esxoxy:serverPay",1500)
	Citizen.Wait(1000)
end)

Citizen.CreateThread(function()
    local ped = {
        `g_m_m_chicold_01`,
    }
    exports["bt-target"]:AddTargetModel(ped, {
        options = {
        {
            event = "oxyrunesx:startRun",
            icon = "fas fa-truck-loading",
            label = "Start Delivery",
        },
        {
            event = "oxyrunesx:giveBox",
            icon = "fas fa-gas-pump",
            label = "Grab Package",
        },
    },
    job = {"all"},
    distance = 0.9,
            
    })
    while true do
        local ped = PlayerPedId()
        pedCoords = GetEntityCoords(ped)
        local startCoords = vector3(-1563.51, -441.16, 36.97)
        if #(startCoords - pedCoords) < 60.0 then
            createoxyPed()
        --elseif 
            --pedcreated = false
            --DeleteEntity(oxyped)
            --TriggerServerEvent('esxoxy:pedSpawned', pedcreated)
        end
        if checkBox then 
            exports["mf-inventory"]:getInventoryItems(playerData.identifier,function(items)
                    hasBox = false
                    for _, i in pairs(items) do
                        if i.name == 'suspicious_box' and not status then
                            TakeBox()
                            status = true
                            hasBox = true
                            if Oxyrun then 
                                boxinhand = true
                            end
                            break;
                        elseif i.name == 'suspicious_box' and status then
                            hasBox = true
                            break;
                        end
                    end
                    if not hasBox and status then --and not Oxyrun
                        status = false
                        
                        DropBox()
                    end
            end)
        end
        Wait(500)
    end
end)

pedcreated = false
function daLoop() 
    Citizen.CreateThread(function()
       
        while startLoop do
            if playerData == nil then
                playerData = ESX.GetPlayerData()
            end
            Citizen.Wait(1)
            
            local mycoords = GetEntityCoords(carpedDrive)

            if foundcar == true then
                --print('found a car')
                if #(mycoords - pedCoords) < 1.5 then

                    --DrawText3Ds(mycoords.x, mycoords.y, mycoords.z, "[E] To deliver Oxy!") 
                    exports["np-ui"]:showInteraction('[E] To deliver Oxy!')
                    if IsControlJustReleased(0,38) and boxesped ~= 0 and boxinhand then
                        exports["np-ui"]:hideInteraction()
                        SetEntityAsNoLongerNeeded(pedCar)
                        SetEntityAsNoLongerNeeded(carpedDrive)
                        --test = false
                        foundcar = false
                        DropBox()
                        PlayAmbientSpeech1(carpedDrive, "Generic_Thanks", "Speech_Params_Force_Shouted_Critical")
                        boxinhand = false
                        pedisspawned = false
                        status = false
                        boxesped = boxesped - 1
                        TriggerServerEvent('esxoxy:removePackage')
                        TriggerServerEvent("esxoxy:moneyforPackage")
                        Citizen.Wait(1000)
                        Wait(10000)
                    elseif IsControlJustReleased(0,38) and boxesped == 0 then
                        exports['mythic_notify']:DoLongHudText('error', 'No more packages!')
                        exports["np-ui"]:hideInteraction("info")
                    elseif IsControlJustReleased(0,38) and not boxinhand then
                        exports['mythic_notify']:DoLongHudText('error', 'You dont have the stuff on you! Is this a joke? Are you a cop! Im out of here!!')
                        exports["np-ui"]:hideInteraction("info")
                        SetEntityAsNoLongerNeeded(pedCar)
                        SetEntityAsNoLongerNeeded(carpedDrive)
                        SetPedScream(carpedDrive)
                        Wait(100000)
                        foundcar = false
                        pedisspawned = false
                    end
                end	
            end

            local carcoords = GetEntityCoords(oxyVehicle)
        
            if boxesped == 0 then 
                exports['mythic_notify']:DoLongHudText('inform', 'You dont have anymore packages left. Dump the car it might be hot!')
                SetEntityAsNoLongerNeeded(pedCar)
                SetEntityAsNoLongerNeeded(carpedDrive)
                pedisspawned = false
                boxinhand = false
                foundcar = false
                test = false
                started = false
                Oxyrun = false
                checkBox = false
                startLoop = false
                boxesped = -1
            end

            if (not DoesEntityExist(pedCar) or IsPedFleeing(carpedDrive) or IsPedDeadOrDying(carpedDrive, 1))  and started and pedisspawned then
            --if IsPedDeadOrDying(carpedDrive, 1) and started and pedisspawned then
                --print(IsPedDeadOrDying)
                --print(started)
                --print(pedisspawned)
                pedisspawned = false
                foundcar = false
                test = false
                Oxyrun = false
                exports['mythic_notify']:DoLongHudText('inform', 'Something happened to one of your clients another one is on the way!')
            end

            if IsPedFleeing(carpedDrive, 1) and started and pedisspawned then
                --print(IsPedDeadOrDying)
                --print(started)
                --print(pedisspawned)
                pedisspawned = false
                foundcar = false
                test = false
                Oxyrun = false
                exports['mythic_notify']:DoLongHudText('inform', 'Something happened to one of your clients another one is on the way!')
            end
            local ped = PlayerPedId()
            pedCoords = GetEntityCoords(ped)
            if gotdest and #(currentDestination - pedCoords) < 50.0 and started == true and pedisspawned == false then
                --print('waiting for clients')
                    local ped = PlayerPedId()
                    local pedCoords = GetEntityCoords(ped)
                    exports['mythic_notify']:DoLongHudText('inform', 'You are close to the drop off wait for your clients!')
                    pedisspawned = true
                    RemoveBlip(DeliveryBlip)
                    GetRandomAI()
                    Citizen.Wait(5000)
            elseif gotdest and #(currentDestination - pedCoords) > 80.0 and started and pedisspawned then
                exports['mythic_notify']:DoLongHudText('error', 'You moved too far from the delivery area and lost the job!')
                SetEntityAsNoLongerNeeded(pedCar)
                SetEntityAsNoLongerNeeded(carpedDrive)
                pedisspawned = false
                boxinhand = false
                foundcar = false
                test = false
                started = false
                Oxyrun = false
                checkBox = false
                startLoop = false
                boxesped = -1
            end
        end
    end)
end

function AnimationBox1(ped)
    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, false)
end

pedisspawned = false

boxinhand = false

foundcar = false
test = false

boxesped = 5
boxes = 5

local carpick = {
    [1] = "sultan",
    [2] = "kuruma",
    [3] = "futo",
    [4] = "granger",
    [5] = "tailgater",
}


function createoxyPed()
    if not pedcreated then
            local hashKey = `g_m_m_chicold_01`
	        local pedType = GetPedType(hashKey)
            RequestModel(hashKey)
            oxyped = CreatePed(pedType, hashKey, -1563.51, -441.16, 35.97, 64.41, 1, 1, false, true)
            SetEntityAsMissionEntity(oxyped)
            FreezeEntityPosition(oxyped, true)
	        SetEntityInvincible(oxyped, true)
	        SetBlockingOfNonTemporaryEvents(oxyped, true)
	        TaskStartScenarioInPlace(oxyped, "WORLD_HUMAN_COP_IDLES", 0, true)
            pedcreated = true
            TriggerServerEvent('esxoxy:pedSpawned', pedcreated)
    end
end


function GetRandomAI()
       test = true
       -- carforPed = GetRandomVehicleInSphere(1312.87, 2688.83, 37.61, 1500000000, 0, 10)
       local hashKey = `a_m_y_stwhi_02`
	   local pedType = GetPedType(hashKey)
       RequestModel(hashKey)
       carpedDrive = CreatePed(pedType, hashKey, currentRoute.PickupCoordinates, currentRoute.PickupHeading, 1, 1)

       if DoesEntityExist(pedCar) then

	        --SetVehicleHasBeenOwnedByPlayer(pedCar,false)
		    SetEntityAsNoLongerNeeded(pedCar)
		    DeleteEntity(pedCar)
	   end

       local car = GetHashKey(carpick[math.random(#carpick)])
       RequestModel(car)
       while not HasModelLoaded(car) do
           Citizen.Wait(0)
       end

       SetPedSeeingRange(carpedDrive, 0.0)
       SetPedHearingRange(carpedDrive, 0.0)
       SetPedAlertness(carpedDrive, 0)
       
      -- print(car)

       pedCar = CreateVehicle(car, currentRoute.PickupCoordinates, currentRoute.PickupHeading, true, false)
	   local plt = GetVehicleNumberPlateText(pedCar)
	   DecorSetInt(pedCar,"GamemodeCar",955)
       SetPedIntoVehicle(carpedDrive, pedCar, -1)
       local mycoords = GetEntityCoords(pedCar)

       carped = GetPedInVehicleSeat(carforPed, -1)
       local veh = GetVehiclePedIsIn(carped, false)
       local model = GetEntityModel(veh)
       local displaytext = GetDisplayNameFromVehicleModel(model)
       local name = GetLabelText(displaytext)

       SetEntityAsMissionEntity(veh,true,true)
       SetEntityAsMissionEntity(carped,true,true)

       local plate = GetVehicleNumberPlateText(veh)

       foundcar = true
       Oxyrun = true

       local speed = Config.SpeedOfPedWhenDriving

       --print(Config.SpeedOfPedWhenDriving)

       TaskVehicleDriveToCoord(carpedDrive, pedCar, currentDestination.x, currentDestination.y, currentDestination.z, Config.SpeedOfPedWhenDriving, 1, 0, 786603, 15.0, true)

       if carforPed == 0 then
          Oxyrun = true
          test = false
       end

       if carforPed ~= 0 then
          --print(mycoords)
       end
end


function DropBox()
    ClearPedTasks(GetPlayerPed(-1))
    DetachEntity(CarryPackage, true, true)
    DeleteObject(CarryPackage)
    CarryPackage = nil
end


function TakeBox()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Citizen.Wait(7)
    end
    TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("prop_cs_cardbox_01")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(object, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
    CarryPackage = object
end

local carpick1 = {
    [1] = "felon",
    [2] = "kuruma",
    [3] = "sultan",
    [4] = "granger",
    [5] = "tailgater",
}

function spawnBoxes()
    exports["bt-target"]:RemoveZone("startOxy")
    zoneCreated = false
    checkBox = true
    status = false
    count = 0
    exports['mythic_notify']:DoLongHudText('inform', 'Grab the goods and put it in the trunk!')
    while count < 5 do 
        --('waiting')
        Citizen.Wait(500)
    end
    exports['mythic_notify']:DoLongHudText('inform', 'Go to the marker on your GPS and wait for your clients!')
    started = true
    pedisspawned = false
    status = false
    DropBox()
    boxes = 5
    boxesped = 5
end

RegisterNetEvent("oxyrunesx:giveBox")
AddEventHandler("oxyrunesx:giveBox", function()
    if checkBox then
        count = count + 1
        TriggerServerEvent('esxoxy:givePackage')
    else
        exports['mythic_notify']:DoLongHudText('inform', 'You are gonna need to pay up first!')
    end
end)

newwaypoint = nil


RegisterNetEvent("oxyrunesx:startOxyRun")
AddEventHandler("oxyrunesx:startOxyRun", function()
    checkBox = true
    startLoop = true
    daLoop()
    spawnBoxes()
    gotoOxy()
end)

RegisterNetEvent("oxyrunesx:setPedSpawned")
AddEventHandler("oxyrunesx:setPedSpawned", function(value)
    pedcreated = value
end)


function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end