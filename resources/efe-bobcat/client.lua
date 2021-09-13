ESX = nil
local sync = false
local pedsT = {}

Citizen.CreateThread(function()
	while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function animasyon() -- ÖN KAPI ANİMASYON
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(50)
    end
    local ped = PlayerPedId()

    SetEntityHeading(ped, 170.52)
    Citizen.Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(882.1660, -2258.35, 32.461, rotx, roty, rotz + 1.1, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), 882.1660, -2258.35, 32.461,  true,  true, false)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.3,  true,  true, true)

    SetEntityCollision(bomba, false, true)
    AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(2000)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)
    TriggerServerEvent("efe:particleserver", method)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

    NetworkStopSynchronisedScene(bagscene)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
    Citizen.Wait(5000)
    ClearPedTasks(ped)
    DeleteObject(bomba)
    StopParticleFxLooped(effect, 0)
    TriggerEvent("efe:birincikapidoorlock")
end

function ikincianim() -- İÇERİDEKİ İLK KAPI ANİMASYON
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(50)
    end
    local ped = PlayerPedId()

    SetEntityHeading(ped, 170.52)
    Citizen.Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(880.4080, -2264.50, 32.441, rotx, roty, rotz + 1.1, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), 880.4080, -2264.50, 32.441,  true,  true, false)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.4,  true,  true, true)

    SetEntityCollision(bomba, false, true)
    AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(2000)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)
    TriggerServerEvent("efe:particleserversec", method)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

    NetworkStopSynchronisedScene(bagscene)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
    Citizen.Wait(5000)
    ClearPedTasks(ped)
    DeleteObject(bomba)
    StopParticleFxLooped(effect, 0)
	TriggerEvent("efe:ikincikapidoorlock")
end

RegisterNetEvent('efe:firstdoor') -- BİRİNCİ KAPI
AddEventHandler('efe:firstdoor', function(door)
    ESX.TriggerServerCallback('efe:bobcatpolice', function(count)
        if count >= Config.MinPolice then
    exports["np-memorygame"]:thermiteminigame(1, 1, 1, 1,
    function() -- success
        print(door)
        print(lockedState)
        TriggerEvent("efe:bobcatkapiac")
        TriggerEvent('efe:dispatchyolla', "10-55", "Bobcat Güvenlik Soygunu", "Bobcat güvenlik bankasının alarmları tetiklendi.", 2, "Bobcat Güvenlik Bankası Soygunu", 500, 0, 200)     
    end,
    function() -- failure
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Başaramadın.'})
        --TriggerEvent("inventory:removeItem","thermite",1)
        end)
    else
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Yeterince polis yok!'})
    end
    end)
end)    

RegisterNetEvent('efe:secondoor') -- 2.Cİ KAPI
AddEventHandler('efe:secondoor', function(door)
    ESX.TriggerServerCallback('efe:bobcatpolice', function(count)
        if count >= Config.MinPolice then
    exports["np-memorygame"]:thermiteminigame(1, 1, 1, 1,
    function() 
        TriggerEvent("efe:bobcatikincikapi")
    end,
    function() -- failure
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Başaramadın.'})
        TriggerEvent("inventory:removeItem","thermite",1)
    end)
else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Yeterince polis yok!'})
        end
    end)
end)

RegisterNetEvent("efe:ptfxparticle")
AddEventHandler("efe:ptfxparticle", function(method)
    local ptfx

    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(1)
    end
        ptfx = vector3(882.1320, -2257.34, 32.461)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Citizen.Wait(4000)
    print("seks")
    StopParticleFxLooped(effect, 0)
end)

RegisterNetEvent("efe:ptfxparticlesec")
AddEventHandler("efe:ptfxparticlesec", function(method)
    local ptfx

    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(1)
    end
        ptfx = vector3(880.49, -2263.60, 32.441)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Citizen.Wait(4000)
    print("seks")
    StopParticleFxLooped(effect, 0)
end)

RegisterNetEvent('efe:bobcatikincikapi')
AddEventHandler('efe:bobcatikincikapi', function()
	ikincianim()
    --TriggerEvent("efe:ikincikapidoorlock")
end)

RegisterNetEvent('efe:bobcatkapiac')
AddEventHandler('efe:bobcatkapiac', function()
	animasyon()
	Citizen.Wait(3500)
    --TriggerEvent("efe:birincikapidoorlock")
end)
--here
RegisterNetEvent('efe:birincikapidoorlock') -- BİRİNCİ KAPI 1
AddEventHandler('efe:birincikapidoorlock', function()
    TriggerServerEvent('nui_doorlock:updateState', 21, false, nil, false, true)    -- 1. kapı sağ
end)

RegisterNetEvent('efe:ikincikapidoorlock') -- İKİNCİ KAPI 2
AddEventHandler('efe:ikincikapidoorlock', function()
	TriggerServerEvent('nui_doorlock:updateState', 22, false, nil, false, true) -- 2.kapı
    --TriggerEvent("efe:pedicreatele")
end)

RegisterNetEvent('efe:ucuncukapidoorlock') -- İKİNCİ KAPI 3 
AddEventHandler('efe:ucuncukapidoorlock', function()
	--TriggerServerEvent('nui_doorlock:updateState', 23, false, source, false, true)
    TriggerEvent("efe:pedicreatele") -- sağ kapı en içteki
end)

RegisterNetEvent('efe:dorduncukapidoorlock') -- İKİNCİ KAPI 4
AddEventHandler('efe:dorduncukapidoorlock', function()
	TriggerServerEvent('nui_doorlock:updateState', 54, false, source, false, true)-- sol kapı en içteki
end)

RegisterNetEvent('efe:pedicreatele') -- İKİNCİ KAPI sexk
AddEventHandler('efe:pedicreatele', function()
    TriggerEvent("efe:bobcatcreateped")
end)

RegisterNetEvent('efe:propcreatle') -- sexk1
AddEventHandler('efe:propcreatle', function()
    TriggerEvent("efe:propcreate")
end)

RegisterNetEvent('efe:propcreate')
AddEventHandler('efe:propcreate', function()
    local weaponbox = CreateObject(GetHashKey("ex_prop_crate_ammo_sc"), 888.0774, -2287.33, 31.441, true,  true, true)
    CreateObject(weaponbox)
    SetEntityHeading(weaponbox, 176.02)
    FreezeEntityPosition(weaponbox, true)

    local weaponbox2 = CreateObject(GetHashKey("ex_prop_crate_expl_sc"), 886.8, -2281.7, 31.441, true,  true, true)
    CreateObject(weaponbox2)
    SetEntityHeading(weaponbox2, 352.02)
    FreezeEntityPosition(weaponbox2, true) 

    local weaponbox3 = CreateObject(GetHashKey("ex_prop_crate_expl_bc"), 882.1840, -2286.8, 31.441, true,  true, true)
    CreateObject(weaponbox3)
    SetEntityHeading(weaponbox3, 158.02)
    FreezeEntityPosition(weaponbox3, true) 

    local weaponbox4 = CreateObject(GetHashKey("ex_prop_crate_ammo_bc"), 881.4557, -2282.61, 31.441, true,  true, true)
    CreateObject(weaponbox4)
    SetEntityHeading(weaponbox4, 52.02)
    FreezeEntityPosition(weaponbox4, true)
end)


RegisterNetEvent('efe:bobcatcreateped')
AddEventHandler('efe:bobcatcreateped', function()
    print("spawning")
	local bobcatped9 = GetHashKey('csb_mweather')
    --[[
    local bobcatped1 = NetworkGetEntityFromNetworkId(bobcatpedID1)
    local bobcatped2 = NetworkGetEntityFromNetworkId(bobcatpedID2)
    local bobcatped3 = NetworkGetEntityFromNetworkId(bobcatpedID3)
    local bobcatped4 = NetworkGetEntityFromNetworkId(bobcatpedID4)
    local bobcatped5 = NetworkGetEntityFromNetworkId(bobcatpedID5)
    local bobcatped6 = NetworkGetEntityFromNetworkId(bobcatpedID6)
    local bobcatped7 = NetworkGetEntityFromNetworkId(bobcatpedID7)
    local bobcatped8 = NetworkGetEntityFromNetworkId(bobcatpedID8)
    ]]--
	AddRelationshipGroup('efe')

		RequestModel(1456041926)
		--bobcatped1 = CreatePed(30, 883.4797, -2273.77, 32.441, 30.568, 88.00, true, false)
        --SetEntityAsMissionEntity(bobcatped1, true, true)
		---SetPedArmour(bobcatped1, 500)
		--SetPedAsEnemy(bobcatped1, true)
		--SetPedRelationshipGroupHash(bobcatped1, 'efe')
		--GiveWeaponToPed(bobcatped1, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		--TaskCombatPed(bobcatped1, GetPlayerPed(-1))
		---SetPedAccuracy(bobcatped1, 100)
		--SetPedDropsWeaponsWhenDead(bobcatped1, false)
		
        while not DoesEntityExist(bobcatped2) do
            bobcatped2 = CreatePed(30, 1456041926, 892.4030, -2275.25, 32.441, 360.00, true, true)
            Citizen.Wait(50)
        end
        SetEntityAsMissionEntity(bobcatped2, true, true)
        SetEntityAlwaysPrerender(bobcatped2, true)
		SetPedArmour(bobcatped2, 500)
		SetPedAsEnemy(bobcatped2, true)
		SetPedRelationshipGroupHash(bobcatped2, 'efe')
		GiveWeaponToPed(bobcatped2, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped2, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped2, 100)
		SetPedDropsWeaponsWhenDead(bobcatped2, false)

        while not DoesEntityExist(bobcatped3) do
            bobcatped3 = CreatePed(30, 1456041926, 892.6776, -2281.26, 32.441, 350.00, true, true)
            Citizen.Wait(50)
        end
        SetEntityAsMissionEntity(bobcatped3, true, true)
        SetEntityAlwaysPrerender(bobcatped3, true)
		SetPedArmour(bobcatped3, 500)
		SetPedAsEnemy(bobcatped3, true)
		SetPedRelationshipGroupHash(bobcatped3, 'efe')
		GiveWeaponToPed(bobcatped3, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped3, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped3, 100)
		SetPedDropsWeaponsWhenDead(bobcatped3, false)

        while not DoesEntityExist(bobcatped4) do
            bobcatped4 = CreatePed(30, 1456041926, 889.3485, -2292.47, 32.441, 350.00, true, true)
            Citizen.Wait(50)
        end
        SetEntityAsMissionEntity(bobcatped4, true, true)
        SetEntityAlwaysPrerender(bobcatped4, true)
		SetPedArmour(bobcatped4, 500)
		SetPedAsEnemy(bobcatped4, true)
		SetPedRelationshipGroupHash(bobcatped4, 'efe')
		GiveWeaponToPed(bobcatped4, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped4, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped4, 100)
		SetPedDropsWeaponsWhenDead(bobcatped4, false)

        while not DoesEntityExist(bobcatped5) do
            bobcatped5 = CreatePed(30, 1456041926, 880.9854, -2293.40, 32.441, 300.00, true, true)
            Citizen.Wait(50)
        end
        SetEntityAsMissionEntity(bobcatped5, true, true)
        SetEntityAlwaysPrerender(bobcatped5, true)
		SetPedArmour(bobcatped5, 500)
		SetPedAsEnemy(bobcatped5, true)
		SetPedRelationshipGroupHash(bobcatped5, 'efe')
		GiveWeaponToPed(bobcatped5, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped5, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped5, 100)
		SetPedDropsWeaponsWhenDead(bobcatped5, false)

        while not DoesEntityExist(bobcatped6) do
            bobcatped6 = CreatePed(30, 1456041926, 873.4896, -2293.21, 32.441, 266.00, true, true)
            Citizen.Wait(50)
        end
        SetEntityAsMissionEntity(bobcatped6, true, true)
        SetEntityAlwaysPrerender(bobcatped6, true)
		SetPedArmour(bobcatped6, 500)
		SetPedAsEnemy(bobcatped6, true)
		SetPedRelationshipGroupHash(bobcatped6, 'efe')
		GiveWeaponToPed(bobcatped6, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped6, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped6, 100)
		SetPedDropsWeaponsWhenDead(bobcatped6, false)

        while not DoesEntityExist(bobcatped7) do
            bobcatped7 = CreatePed(30, 1456041926,894.1248, -2287.51, 32.446, 298.00, true, true)
            Citizen.Wait(50)
        end
        SetEntityAsMissionEntity(bobcatped7, true, true)
        SetEntityAlwaysPrerender(bobcatped7, true)
		SetPedArmour(bobcatped7, 500)
		SetPedAsEnemy(bobcatped7, true)
		SetPedRelationshipGroupHash(bobcatped7, 'efe')
		GiveWeaponToPed(bobcatped7, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped7, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped7, 100)
		SetPedDropsWeaponsWhenDead(bobcatped7, false)

        while not DoesEntityExist(bobcatped8) do
            bobcatped8 = CreatePed(30, 1456041926, 896.9407, -2280.87, 32.441, 266.00, true, true)
            Citizen.Wait(50)
        end
        SetEntityAsMissionEntity(bobcatped8, true, true)
        SetEntityAlwaysPrerender(bobcatped8, true)
		SetPedArmour(bobcatped8, 500)
		SetPedAsEnemy(bobcatped8, true)
		SetPedRelationshipGroupHash(bobcatped8, 'efe')
		GiveWeaponToPed(bobcatped8, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped8, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped8, 100)
		SetPedDropsWeaponsWhenDead(bobcatped8, false)
        local peds = {bobcatped2, bobcatped3, bobcatped4, bobcatped5, bobcatped6, bobcatped7, bobcatped8}
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local players = ESX.Game.GetPlayersInArea(coords, 10)
        local ids = {}
        for i, p in pairs(players) do 
            print(GetPlayerServerId(p))
            ids[i] = GetPlayerServerId(p)
        end
        TriggerServerEvent('efe:syncPedsSV', peds, ids)
end)

RegisterNetEvent('efe:syncPeds')
AddEventHandler('efe:syncPeds', function(peds)
    print('Actively syncing and aggroing')
	for i, p in pairs(peds) do
        print(p)
        SetEntityAlwaysPrerender(p, true)
        SetEntityVisible(p, true, 0)
        TaskCombatPed(p, GetPlayerPed(-1))
        table.insert(pedsT, p)
    end
    sync = true
end)

RegisterNetEvent('efe:bombabumbe')
AddEventHandler('efe:bombabumbe', function()
	local interiorid = GetInteriorAtCoords(883.4142, -2282.372, 31.44168)
	ActivateInteriorEntitySet(interiorid, "np_prolog_broken")
	RemoveIpl(interiorid, "np_prolog_broken")
	DeactivateInteriorEntitySet(interiorid, "np_prolog_clean")
	RefreshInterior(interiorid)
end)

	
Citizen.CreateThread(function()
    local hash = GetHashKey("cs_drfriedlander")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
end
    rehineped = CreatePed("PED_TYPE_CIVFEMALE", "cs_drfriedlander", 870.1760, -2288.20, 31.441, 175.21, true, false)
    SetBlockingOfNonTemporaryEvents(rehineped, true)
            SetPedDiesWhenInjured(rehineped, false)
            SetPedCanPlayAmbientAnims(rehineped, true)
            SetPedCanRagdollFromPlayerImpact(rehineped, false)
			SetEntityInvincible(rehineped, false)
	ESX.Streaming.RequestAnimDict('random@arrests@busted', function()
        TaskPlayAnim(rehineped, 'random@arrests@busted', 'idle_a', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
	end)
end)

Citizen.CreateThread(function()
    while not sync do
        Citizen.Wait(100)
    end
    while sync do
        for i, p in pairs(pedsT) do
            SetEntityAlwaysPrerender(p, true)
            SetEntityVisible(p, true, 0)
            Citizen.Wait(100)
        end
    end
end)

RegisterNetEvent('efe:pediyurut') -- PED WALK
AddEventHandler('efe:pediyurut', function()
	ClearPedTasks(rehineped)
	TaskGoStraightToCoord(rehineped, 869.2078, -2292.60, 32.441, 150.0, -1, 265.61, 0)
	Citizen.Wait(5000)
	TaskGoStraightToCoord(rehineped, 893.3309, -2294.90, 32.441, 150.0, -1, 350.61, 0)
	Citizen.Wait(13000)
	TriggerEvent("efe:pediyurutiki")
end)

RegisterNetEvent('efe:silahver') -- PED WALK
AddEventHandler('efe:silahver', function()
    TriggerServerEvent('efe:silahverSV', 1)
end)



RegisterNetEvent('efe:pediyurutiki') -- PED WALK
AddEventHandler('efe:pediyurutiki', function()
	TaskGoStraightToCoord(rehineped, 894.6337, -2284.97, 32.441, 150.0, -1, 82.56, 0)
	Citizen.Wait(7500)
	ESX.Streaming.RequestAnimDict('weapons@projectile@grenade_str', function()
        TaskPlayAnim(rehineped, 'weapons@projectile@grenade_str', 'throw_h_fb_backward', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
    end)
	Citizen.Wait(1000)
	AddExplosion(890.7849, -2284.88, 32.441, 32, 150000.0, true, false, 4.0)
	AddExplosion(894.0084, -2284.90, 32.580, 32, 150000.0, true, false, 4.0)
    TriggerEvent("efe:bombabumbe")
    TriggerEvent("efe:propcreate")
end)
	
    exports["bt-target"]:AddCircleZone("kapipatlat", vector3(870.4505, -2288.83, 32.441), 1.0, {
        name ="kapipatlat",
        useZ = true,
        --debugPoly=true
        }, {
            options = {
                {
                    event = "efe:pediyurut",
                    icon = "fas fa-bomb",
                    label = "Kapıyı Patlat!",
                },
             },
             job = {"all"},
            distance = 2.1
        })

        exports["bt-target"]:AddCircleZone("kanksmankscankssilahlariver", vector3(883.0063, -2283.38, 32.441), 1.0, {
            name ="kanksmankscankssilahlariver",
            useZ = true,
            --debugPoly=true
            }, {
                options = {
                    {
                        event = "efe:silahver",
                        icon = "fas fa-box",
                        label = "Silahları Yağmala!",
                    },
                 },
                 job = {"all"},
                distance = 2.1
            })