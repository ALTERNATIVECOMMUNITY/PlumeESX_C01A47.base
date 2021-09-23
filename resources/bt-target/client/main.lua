local Models = {}
local Zones = {}
local inShop = false
local mechSpot = {tunah = 'tunah', auto = 'auto'}

Citizen.CreateThread(function()
    RegisterKeyMapping("+playerTarget", "Player Targeting", "keyboard", "LMENU") --Removed Bind System and added standalone version
    RegisterCommand('+playerTarget', playerTargetEnable, false)
    RegisterCommand('-playerTarget', playerTargetDisable, false)
    TriggerEvent("chat:removeSuggestion", "/+playerTarget")
    TriggerEvent("chat:removeSuggestion", "/-playerTarget")
end)

RegisterNetEvent('bt-polyzone:enter')
AddEventHandler('bt-polyzone:enter', function(name)
	if mechSpot[name] ~= nil then
        inShop = true
    end
end)

RegisterNetEvent('bt-polyzone:exit')
AddEventHandler('bt-polyzone:exit', function(name)
	if mechSpot[name] ~= nil then
		inShop = false
    end
end)

if Config.ESX then
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
        while PlayerJob == nil do
            PlayerJob = ESX.GetPlayerData().job
            Citizen.Wait(0)
        end
        RegisterNetEvent('esx:setJob')
        AddEventHandler('esx:setJob', function(job)
            PlayerJob = job
        end)
    end)
else
    PlayerJob = Config.NonEsxJob()
end

function checkRepairing()
    local checks = {'spotER', 'spotE1', 'spotE2', 'spotE3', 'spot1', 'spot2', 'spot3', 'spot4'}
    for _, v in pairs(checks) do
        if Zones[v] then
            return true
        end
    end
    return false
end

function playerTargetEnable()
    if success then return end
    if IsPedArmed(PlayerPedId(), 6) then return end
    local veh,dis = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
    RemoveZone('VehPlate')
    RemoveZone('MechMenu')
    if veh and dis < 3 then 
        local boneIndex = GetEntityBoneIndexByName(veh, 'platelight')
        print(boneIndex)
        local pos = GetWorldPositionOfEntityBone(veh, boneIndex)
        local pos2 = GetEntityCoords(veh)
        local heading = GetEntityHeading(veh)
        local d1,d2 = GetModelDimensions(GetEntityModel(veh))

        AddBoxZone("VehPlate", pos, 0.4, 0.6, {
            name="VehPlate",
            heading=heading,
            debugPoly=false,
            minZ=pos.z-0.1,
            maxZ=pos.z+0.1
            }, {
                options = {
                    {
                        event = "pe-fake-plate:Peak",
                        icon = "fas fa-tools",
                        label = "Add/Remove Fake Plate",
                    },
                },
                job = {"all"},
                distance = 1.5
        })
        if not checkRepairing() and inShop then
            AddBoxZone("MechMenu", pos2, d2.y - d1.y, d2.x - d1.x, {
                name="MechMenu",
                heading=heading,
                debugPoly=true,
                minZ=pos.z-0.3,
                maxZ=pos.z+0.3
                }, {
                    options = {
                        {
                            event = "t1ger_mechanicjob:mechActionContext",
                            icon = "fas fa-tools",
                            label = "Vehicle Repair",
                        },
                    },
                    job = {"mechanic"},
                    distance = 3.0
            })
        end
    end
    targetActive = true

    SendNUIMessage({response = "openTarget"})

    while targetActive do
        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local hit, coords, entity = RayCastGamePlayCamera(20.0)

        if hit == 1 then
            if GetEntityType(entity) ~= 0 then
                for _, model in pairs(Models) do
                    if _ == GetEntityModel(entity) then
                        for k , v in ipairs(Models[_]["job"]) do 
                            if v == "all" or v == PlayerJob.name then
                                if _ == GetEntityModel(entity) then
                                    if #(plyCoords - coords) <= Models[_]["distance"] then

                                        success = true

                                        SendNUIMessage({response = "validTarget", data = Models[_]["options"]})

                                        while success and targetActive do
                                            local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                                            local hit, coords, entity = RayCastGamePlayCamera(20.0)

                                            DisablePlayerFiring(PlayerPedId(), true)

                                            if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                                                SetNuiFocus(true, true)
                                                SetCursorLocation(0.5, 0.5)
                                            end

                                            if GetEntityType(entity) == 0 or #(plyCoords - coords) > Models[_]["distance"] then
                                                success = false
                                            end

                                            Citizen.Wait(1)
                                        end
                                        SendNUIMessage({response = "leftTarget"})
                                    end
                                end
                            end
                        end
                    end
                end
            end

            for _, zone in pairs(Zones) do
                if Zones[_]:isPointInside(coords) then
                    for k , v in ipairs(Zones[_]["targetoptions"]["job"]) do 
                        if v == "all" or v == PlayerJob.name then
                            if #(plyCoords - Zones[_].center) <= zone["targetoptions"]["distance"] then

                                success = true

                                SendNUIMessage({response = "validTarget", data = Zones[_]["targetoptions"]["options"]})
                                while success and targetActive do
                                    local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                                    local hit, coords, entity = RayCastGamePlayCamera(20.0)

                                    DisablePlayerFiring(PlayerPedId(), true)

                                    if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                                        SetNuiFocus(true, true)
                                        SetCursorLocation(0.5, 0.5)
                                    elseif not Zones[_]:isPointInside(coords) or #(vector3(Zones[_].center.x, Zones[_].center.y, Zones[_].center.z) - plyCoords) > zone.targetoptions.distance then
                                    end
        
                                    if not Zones[_]:isPointInside(coords) or #(plyCoords - Zones[_].center) > zone.targetoptions.distance then
                                        success = false
                                    end
        

                                    Citizen.Wait(1)
                                end
                                SendNUIMessage({response = "leftTarget"})
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(250)
    end
end

function playerTargetDisable()
    if success then return end
    targetActive = false
    SendNUIMessage({response = "closeTarget"})
    
end

--NUI CALL BACKS

RegisterNUICallback('selectTarget', function(data, cb)
    SetNuiFocus(false, false)

    success = false

    targetActive = false
   
    if data.key then
        TriggerEvent(data.event, data.key)
    else
        TriggerEvent(data.event)
    end    
end)

RegisterNUICallback('closeTarget', function(data, cb)
    SetNuiFocus(false, false)

    success = false

    targetActive = false
    
end)

--Functions from https://forum.cfx.re/t/get-camera-coordinates/183555/14

function RotationToDirection(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end

--Exports

function AddCircleZone(name, center, radius, options, targetoptions)
    Zones[name] = CircleZone:Create(center, radius, options)
    Zones[name].targetoptions = targetoptions
end

function AddBoxZone(name, center, length, width, options, targetoptions)
    Zones[name] = BoxZone:Create(center, length, width, options)
    Zones[name].targetoptions = targetoptions
end

function AddPolyzone(name, points, options, targetoptions)
    Zones[name] = PolyZone:Create(points, options)
    Zones[name].targetoptions = targetoptions
end

function AddTargetModel(models, parameteres)
    for _, model in pairs(models) do
        Models[model] = parameteres
    end
end

function RemoveZone(name)
    if not Zones[name] then return end
    if Zones[name].destroy then
        Zones[name]:destroy()
    end

    Zones[name] = nil
end

function RemoveModel(model)
    if not Models[model] then return end
    --if Models[model] then
       -- Models[model]:destroy()
   -- end

    Models[model] = nil
    --table.remove(Models, model)
end

RegisterCommand('resetTarget', function()
    targetActive = false
    SendNUIMessage({response = "closeTarget"})
    targetActive = true
end, false)

exports("AddCircleZone", AddCircleZone)

exports("AddBoxZone", AddBoxZone)

exports("AddPolyzone", AddPolyzone)

exports("AddTargetModel", AddTargetModel)

exports("RemoveZone", RemoveZone)

exports("RemoveModel", RemoveModel)
