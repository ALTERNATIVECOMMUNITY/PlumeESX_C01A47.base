local isJudge = false
local isPolice = false
local isMedic = false
local isDoctor = false
local isNews = false
local isDead = false
local isInstructorMode = false
local myJob = "unemployed"
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}
local PlayerData = {}
local prop
local propertyNames = {'GenericApartment', 'LowEndApartment', 'IntegrityWay'}
local civGarageNames = {'apartmentGarage1', 'apartmentGarage2', 'apartmentGarage3', 'apartmentGarage4', 'elginGarage1', 'elginGarage2', 'elginGarage3', 'elginGarage4', 'paletoGarage1', 'paletoGarage2',
'paletoGarage3', 'paletoGarage4', 'sandyGarage1', 'sandyGarage2', 'sandyGarage3', 'sandyGarage4', 'impoundParking1'}
local polyzoneBooleans = {apartmentGarage1 = false, apartmentGarage2 = false, apartmentGarage3 = false, apartmentGarage4 = false, elginGarage1 = false, elginGarage2 = false, elginGarage3 = false, 
elginGarage4 = false, paletoGarage1 = false, paletoGarage2 = false, paletoGarage3 = false, paletoGarage4 = false, sandyGarage1 = false, sandyGarage2 = false, sandyGarage3 = false, sandyGarage4 = false, 
policeGarage1 = false, policeGarage2 = false, policeGarage3 = false, bennysMrpd = false, bennysOlympic = false, bennysSandy = false, GenericApartment = false, GenericApartmentExit = false, LowEndApartment = false,
LowEndApartmentExit = false, IntegrityWay = false, policeCloset = false, mosleyCloset = false, mosleyBennys = false, impoundLocal = false, impoundParking1 = false, towCloset = false, towGarage = false,
ambulanceGarage1 = false, ambulanceGarage2 = false}
ESX = nil
local inApartment = false
local exit = false
local roomMenu = false
local player,dis



Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	exports["bt-polyzone"]:AddBoxZone("policeGarage1", vector3(445.7275, -991.5033, 25.6908), 2.5, 4, {
        name="policeGarage1",
        heading=0,
        minZ=24.5,
        maxZ=27.17
    })
    exports["bt-polyzone"]:AddBoxZone("policeGarage2", vector3(445.9648,-988.9055,25.6908), 2.5, 4, {
        name="policeGarage2",
        heading=0,
        minZ=24.5,
        maxZ=27.17
    })
    exports["bt-polyzone"]:AddBoxZone("policeGarage3", vector3(446.2286,-994.2879,25.6908), 2.5, 4, {
        name="policeGarage3",
        heading=0,
        minZ=24.5,
        maxZ=27.17
    })
    exports["bt-polyzone"]:AddBoxZone("bennysMrpd", vector3(450.1978, -975.811,25.37073), 3.5, 6, {
        name="bennysMrpd",
        heading=0,
        minZ=24.5,
        maxZ=27.17
    })
    exports["bt-polyzone"]:AddBoxZone("bennysOlympic", vector3(731.2879,-1089.007,21.52893), 4, 8, {
		name="bennysOlympic",
		heading=0,
		minZ=21,
		maxZ=24
	})
	exports["bt-polyzone"]:AddBoxZone("bennysSandy", vector3(110.2549, 6626.624, 31.36926), 4, 8, {
		name="bennysSandy",
		heading=135,
		minZ=30,
		maxZ=33
	})
    exports["bt-polyzone"]:AddBoxZone("apartmentGarage1", vector3(-297.5900, -989.6500, 31.0800), 2.5, 4, {
		name="apartmentGarage1",
		heading=158,
		minZ=29,
		maxZ=33
	})
    exports["bt-polyzone"]:AddBoxZone("apartmentGarage2", vector3(-301.2132,-988.7868,31.06592), 2.5, 4, {
		name="apartmentGarage2",
		heading=158,
		minZ=29,
		maxZ=33
	})
    exports["bt-polyzone"]:AddBoxZone("apartmentGarage3", vector3(-304.7736,-987.5472,31.06592), 2.5, 4, {
		name="apartmentGarage3",
		heading=158,
		minZ=29,
		maxZ=33
	})
    exports["bt-polyzone"]:AddBoxZone("apartmentGarage4", vector3(-308.3736,-986.4132,31.06592), 2.5, 4, {
		name="apartmentGarage4",
		heading=158,
		minZ=29,
		maxZ=33
	})
    --start of elgin ave, pillboxhill
    exports["bt-polyzone"]:AddBoxZone("elginGarage1", vector3(247.7143,-758.3735,30.81323), 2.5, 4, {
		name="elginGarage1",
		heading=160,
		minZ=29,
		maxZ=33
	})
    exports["bt-polyzone"]:AddBoxZone("elginGarage2", vector3(251.3539, -759.1121, 30.81323), 2.5, 4, {
		name="elginGarage2",
		heading=160,
		minZ=29,
		maxZ=33
	})
    exports["bt-polyzone"]:AddBoxZone("elginGarage3", vector3(254.2945,-760.9319,30.81323), 2.5, 4, {
		name="elginGarage3",
		heading=160,
		minZ=29,
		maxZ=33
	})
    exports["bt-polyzone"]:AddBoxZone("elginGarage4", vector3(257.4857, -762, 30.81323), 2.5, 4, {
		name="elginGarage4",
		heading=160,
		minZ=29,
		maxZ=33
	})
    --start of paleto truck stop garage
    exports["bt-polyzone"]:AddBoxZone("paletoGarage1", vector3(145.73, 6602.37, 31.8), 2.5, 6, {
		name="paletoGarage1",
		heading=180,
		minZ=29,
		maxZ=33
	})
    exports["bt-polyzone"]:AddBoxZone("paletoGarage2", vector3(151.04, 6597.12, 31.8), 2.5, 6, {
		name="paletoGarage2",
		heading=180,
		minZ=29,
		maxZ=33
	})
    exports["bt-polyzone"]:AddBoxZone("paletoGarage3", vector3(151.12, 6609.01, 31.8), 2.5, 6, {
		name="paletoGarage3",
		heading=180,
		minZ=29,
		maxZ=33
	})
    exports["bt-polyzone"]:AddBoxZone("paletoGarage4", vector3(145.48, 6612.71, 31.8), 2.5, 6, {
		name="paletoGarage4",
		heading=180,
		minZ=29,
		maxZ=33
	})
    --start of sandy garage
    exports["bt-polyzone"]:AddBoxZone("sandyGarage1", vector3(1949.47, 3759.19, 32.21), 2.5, 4, {
		name="sandyGarage1",
		heading=210,
		minZ=31,
		maxZ=34
	})
    exports["bt-polyzone"]:AddBoxZone("sandyGarage2", vector3(1953.08, 3760.69,32.2), 2.5, 4, {
		name="sandyGarage2",
		heading=210,
		minZ=31,
		maxZ=34
	})
    exports["bt-polyzone"]:AddBoxZone("sandyGarage3", vector3(1956.13, 3762.66, 32.2), 2.5, 4, {
		name="sandyGarage3",
		heading=210,
		minZ=31,
		maxZ=34
	})
    exports["bt-polyzone"]:AddBoxZone("sandyGarage4", vector3(1959.19, 3764.9, 32.2), 2.5, 4, {
		name="sandyGarage4",
		heading=210,
		minZ=31,
		maxZ=34
	})
    exports["bt-polyzone"]:AddBoxZone("policeCloset", vector3(461.38, -997.48, 30.8), 10, 5, {
        name="policeCloset",
        heading=275.0,
        minZ=30,
        maxZ=32
    })
    exports["bt-polyzone"]:AddBoxZone("mosleyCloset", vector3(0.0527, -1660.66, 29.46), 10, 5, {
        name="mosleyCloset",
        heading=51.5,
        minZ=29,
        maxZ=31
    })
    exports["bt-polyzone"]:AddBoxZone("mosleyBennys", vector3(-8.93, -1668.08, 29.48), 15, 15, {
        name="mosleyBennys",
        heading=145.4,
        minZ=29,
        maxZ=31
    })
    exports["bt-polyzone"]:AddBoxZone("impoundLocal", vector3(-239.208,-1183.80, 23.02), 10, 6, {
        name="impoundLocal",
        heading=88.0,
        minZ=20,
        maxZ=25
    })
    exports["bt-polyzone"]:AddBoxZone("impoundParking1", vector3(-152.44,-1169.88, 23.77), 2.5, 4, {
        name="impoundParking1",
        heading=89.78,
        minZ=20,
        maxZ=25
    })
    exports["bt-polyzone"]:AddBoxZone("towCloset", vector3(-185.04,-1164.61, 23.67), 3, 5, {
        name="towCloset",
        heading=177.42,
        minZ=20,
        maxZ=25
    })
    exports["bt-polyzone"]:AddBoxZone("towGarage", vector3(-209.75,-1169.98, 23.04), 3, 5, {
        name="towCloset",
        heading=83.01,
        minZ=22.5,
        maxZ=24.5
    })
    exports["bt-polyzone"]:AddBoxZone("ambulanceGarage1", vector3(-435.87,-350.545, 24.224), 3, 5, {
        name="ambulanceGarage1",
        heading=195.45,
        minZ=23.22,
        maxZ=26.22
    })
    exports["bt-polyzone"]:AddBoxZone("ambulanceGarage2", vector3(-439.64,-352.10,24.22), 3, 5, {
        name="ambulanceGarage2",
        heading=195.45,
        minZ=23.22,
        maxZ=26.22
    })
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('bt-polyzone:enter')
AddEventHandler('bt-polyzone:enter', function(name)
    if polyzoneBooleans[name] ~= nil then
        polyzoneBooleans[name] = true
    end
    if string.find(name, "Exit") then 
        exit = true
    end
    if string.find(name, "Room_Menu") then 
        roomMenu = true
    end
end)

RegisterNetEvent('bt-polyzone:exit')
AddEventHandler('bt-polyzone:exit', function(name)
    if polyzoneBooleans[name] ~= nil then
        polyzoneBooleans[name] = false
    end
    if string.find(name, "Exit") then 
        exit = false
    end
    if string.find(name, "Room_Menu") then 
        roomMenu = false
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('np_menu:propertyEntered')
AddEventHandler('np_menu:propertyEntered', function(o)
	inApartment = o
end)

function atGarageCiv() 
    for i, value in ipairs(civGarageNames) do
       if polyzoneBooleans[value] then
            return true
       end
    end   
end

function atProperty() 
    for i, value in ipairs(propertyNames) do
       if polyzoneBooleans[value] then
            TriggerEvent('esx_property:setLocation', value)
            return true
       end
    end   
end

rootMenuConfig =  {
    {
        id = "general",
        displayName = "General",
        icon = "#globe-europe",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"general:escort",  "general:checkoverself", "general:checktargetstates",  "general:keysgive",  "general:emotes", "general:putinvehicle"}
         
    },
    {
        id = "police-action",
        displayName = "Police Actions",
        icon = "#police-action",
        enableMenu = function()
            return (PlayerData.job.name == 'police' and not isDead and not IsPedInAnyVehicle(PlayerPedId(), false))
        end,
        subMenus = {"police:putInVeh", "general:unseatnearest", "police:escort", "police:runplate", "cuffs:remmask", "police:removeweapons", "police:frisk"}
    },
    {
        id = "police-check",
        displayName = "Police Checks",
        icon = "#police-check",
        enableMenu = function()
            return (PlayerData.job.name == 'police' and not isDead and not IsPedInAnyVehicle(PlayerPedId(), false)) 
        end,
        subMenus = {"general:checktargetstates", "police:checkbank", "police:checklicenses", "cuffs:checkinventory", "police:gsr", "police:dnaswab" }
    },
    {
        id = "police-vehicle",
        displayName = "Police Vehicle",
        icon = "#police-vehicle",
        enableMenu = function()
            return (PlayerData.job.name == 'police' and not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end,
        subMenus = { "police:runplate", "police:toggleradar"}
    },
    {
        id = "garage",
        displayName = "Garage",
        icon = "#walking",
        enableMenu = function()
            return ((not isDead and polyzoneBooleans.policeGarage1 or polyzoneBooleans.policeGarage2 or polyzoneBooleans.policeGarage3) and (PlayerData.job.name == 'police')) or ((not isDead and polyzoneBooleans.towGarage) and (PlayerData.job.name == 'towing')) or ((not isDead and polyzoneBooleans.ambulanceGarage1 or polyzoneBooleans.ambulanceGarage2 ) and (PlayerData.job.name == 'mount_zonah'))
        end,
        subMenus = { "garage:putaway", "garage:takeout"}
    },
    {
        id = "garageCiv",
        displayName = "Garage",
        icon = "#walking",
        enableMenu = function()
            return not isDead and atGarageCiv() 
        end,
        subMenus = { "garageCiv:putaway", "garageCiv:takeout"}
    },
    {
        id = "animations",
        displayName = "Walking Styles",
        icon = "#walking",
        enableMenu = function()
            return not isDead and not IsPedInAnyVehicle(PlayerPedId(), false)
        end,
        subMenus = { "animations:brave", "animations:hurry", "animations:business", "animations:tipsy", "animations:injured","animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien" }
    },
    {
        id = "expressions",
        displayName = "Expressions",
        icon = "#expressions",
        enableMenu = function()
            return not isDead and not IsPedInAnyVehicle(PlayerPedId(), false)
        end,
        subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
    },
    {
        id = "clothes",
        displayName = "Clothing",
        icon = "#walking",
        enableMenu = function()
            return not isDead and not IsPedInAnyVehicle(PlayerPedId(), false) and ((polyzoneBooleans['policeCloset'] and PlayerData.job.name == 'police') or (polyzoneBooleans['towCloset'] and PlayerData.job.name == 'towing') or (polyzoneBooleans['mosleyCloset'] and PlayerData.job.name == 'mosleys_mech'))
        end,
        subMenus = { "clothes:store", "propertyMenu:outfits"}
    },
    {
        id = "judge-raid",
        displayName = "DoJ Menu",
        icon = "#judge-raid",
        enableMenu = function()
            return (not isDead and isJudge)
        end,
        subMenus = { "judge-raid:checkowner", "judge-raid:seizeall", "judge-raid:takecash", "judge-raid:takedm"}
    },
    {
        id = "judge-licenses",
        displayName = "DoJ Licenses",
        icon = "#judge-licenses",
        enableMenu = function()
            return (not isDead and isJudge)
        end,
        subMenus = { "police:checklicenses", "judge:grantDriver", "judge:grantBusiness", "judge:grantWeapon", "judge:grantHouse", "judge:grantBar", "judge:grantDA", "judge:removeDriver", "judge:removeBusiness", "judge:removeWeapon", "judge:removeHouse", "judge:removeBar", "judge:removeDA", "judge:denyWeapon", "judge:denyDriver", "judge:denyBusiness", "judge:denyHouse" }
    },
    {
        id = "judge-actions",
        displayName = "DoJ Actions",
        icon = "#judge-actions",
        enableMenu = function()
            return (not isDead and isJudge)
        end,
        subMenus = { "police:cuff", "cuffs:uncuff", "general:escort", "police:frisk", "cuffs:checkinventory", "police:checkbank"}
    },
    {
        id = "da-actions",
        displayName = "DA Actions",
        icon = "#judge-actions",
        enableMenu = function()
            return (not isDead and isJudge)
        end,
        subMenus = { "police:cuff", "cuffs:uncuff", "general:escort", "police:frisk", "cuffs:checkinventory"}
    },
    {
        id = "cuff",
        displayName = "Cuff",
        icon = "#cuffs",
        enableMenu = function()
            if not isDead and not IsPlayerFreeAiming(PlayerId()) and not IsPedInAnyVehicle(PlayerPedId(), false) and not isHandcuffed and not isHandcuffedAndWalking then
                if isPolice then
                    return true
                elseif not isPolice then
                    t, distance = GetClosestPlayer()
                    local serverId = GetPlayerServerId(t)
                    if(distance ~= -1 and distance < 3 and not IsPedRagdoll(PlayerPedId())) then
                        if cuffStates[serverId] == nil then
                            return false
                        else
                            return cuffStates[serverId]
                        end
                    end
                end
            end
            return false
        end,
        subMenus = { "cuffs:uncuff", "cuffs:remmask", "cuffs:checkinventory", "cuffs:unseat", "police:seat", "cuffs:checkphone" }
    },
    {
        id = "bennys",
        displayName = "Bennys",
        icon = "#general-check-vehicle",
        functionName = "esx_lscustom:bennysRadial",
        enableMenu = function()
            return not isDead and polyzoneBooleans.bennysOlympic or not isDead and polyzoneBooleans.bennysSandy or (not isDead and polyzoneBooleans.mosleyBennys and PlayerData.job.name == 'mosleys_mech')
        end
    },
    {
        id = "cuff",
        displayName = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "esx_policejob:handCuffRadial",
        enableMenu = function()
            return (not isDead and not isHandcuffed and not isHandcuffedAndWalking and PlayerData.job.name == 'police' and not IsPedInAnyVehicle(PlayerPedId(), false))
        end
    },
    {
        id = "repair",
        displayName = "Benny's",
        icon = "#general-check-vehicle",
        functionName = "esx_policejob:bennysRepairRadial",
        enableMenu = function()
            return (not isDead and not isHandcuffed and not isHandcuffedAndWalking and PlayerData.job.name == 'police' and IsPedInAnyVehicle(PlayerPedId(), false) and polyzoneBooleans.bennysMrpd)
        end
    },
    {
        id = "medic",
        displayName = "Medical",
        icon = "#medic",
        enableMenu = function()
            return (PlayerData.job.name == 'mount_zonah' and not isDead)
        end,
        subMenus = {"medic:revive", "medic:heal", "medic:escort", "medic:putInVeh", "medic:putOutVeh"}
    },
    {
        id = "strecther",
        displayName = "Put on Stretcher",
        icon = "#general-put-in-veh",
        functionName = "stretcher:findPlayer",
        enableMenu = function()
            return (checkStrechter() and PlayerData.job.name == 'mount_zonah')
        end
    },
    {
        id = "news",
        displayName = "Weazel News",
        icon = "#news",
        enableMenu = function()
            return (PlayerData.job.name == 'reporter' and not isDead)
        end,
        subMenus = { "news:setCamera", "news:setMicrophone", "news:setBoom" }
    },
    {
        id = "vehicle",
        displayName = "Vehicle",
        icon = "#vehicle-options-vehicle",
        functionName = "vehcontrol:openExternalRadial",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end
    },
	{
        id = "impound",
        displayName = "Impound",
        icon = "#impound-vehicle",
        functionName = "esx_policejob:impoundRadial",
        enableMenu = function()
            if (PlayerData.job.name == 'police' and not isDead) then
                return true
            end
            return false
        end,
        subMenus = {}
    }, {
        id = "oxygentank",
        displayName = "Remove Oxygen Tank",
        icon = "#oxygen-mask",
        functionName = "RemoveOxyTank",
        enableMenu = function()
            return not isDead and hasOxygenTankOn
        end
    },  
	{
        id = "mdt",
        displayName = "MDT",
        icon = "#mdt",
        functionName = "mdt:radialopen",
        enableMenu = function()
            return (PlayerData.job.name == 'police' and not isDead)
        end
    },
    {
        id = "propertyMenu",
        displayName = "Property Menu",
        icon = "#judge-licenses-grant-house",
        enableMenu = function()
            return not isDead and roomMenu
        end,
        subMenus = {"propertyMenu:outfits", "propertyMenu:inventory"}
    },
    {
        id = "enterProperty",
        displayName = "Enter Property",
        icon = "#judge-licenses-grant-house",
        functionName = "esx_property:enterPropertyRadial",
        enableMenu = function()
            return not isDead and atProperty()
        end,
        subMenus = {}
    },
    {
        id = "exitProperty",
        displayName = "Exit Property",
        icon = "#judge-licenses-grant-house",
        functionName = "esx_property:exitPropertyRadial",
        enableMenu = function()
            return not isDead and exit
        end,
        subMenus = {}
    },
    {
        id = "towing",
        displayName = "Tow Options",
        icon = "#vehicle-options-vehicle",
        functionName = "erp_towscript:depositRadial",
        enableMenu = function()
            return (not isDead and PlayerData.job.name == 'towing' and polyzoneBooleans.impoundLocal)
        end,
        subMenus = {"towing:impound"}
    },
    {
        id = "rob",
        displayName = "Rob",
        icon = "#cuffs-check-inventory",
        functionName = "np-menu:intiateRobbing",
        enableMenu = function()
            return canPlayerBeRobbed()
        end
    }

}

newSubMenus = {
    ['general:emotes'] = {
        title = "Emotes",
        icon = "#general-emotes",
        functionName = "dp:RecieveMenu"
    },    
    ['general:keysgive'] = {
        title = "Give Key",
        icon = "#general-keys-give",
        functionName = "onyx:checkKeys"
    },
    ['general:checkoverself'] = {
        title = "Examine Self",
        icon = "#general-check-over-self",
        functionName = "Evidence:CurrentDamageList"
    },
    ['general:checktargetstates'] = {
        title = "Examine Target",
        icon = "#general-check-over-target",
        functionName = "requestWounds"
    },
    ['general:checkvehicle'] = {
        title = "Examine Vehicle",
        icon = "#general-check-vehicle",
        functionName = "towgarage:annoyedBouce"
    },
    ['general:escort'] = {
        title = "Escort",
        icon = "#general-escort",
        functionName = "carry:command"
    },
    ['general:putinvehicle'] = {
        title = "Seat Vehicle",
        icon = "#general-put-in-veh",
        functionName = "carry:putInVeh"
        
        --esx_policejob:putInVehicleRadial
    },
    ['general:unseatnearest'] = {
        title = "Unseat Nearest",
        icon = "#general-unseat-nearest",
        functionName = "esx_policejob:OutVehicleRadial"
    },    
    ['general:flipvehicle'] = {
        title = "Flip Vehicle",
        icon = "#general-flip-vehicle",
        functionName = "FlipVehicle"
    },
    ['propertyMenu:outfits'] = {
        title = "Outfits",
        icon = "#walking",
        functionName = "raid_clothes:oufitsMenuRadial"
    },
    ['propertyMenu:inventory'] = {
        title = "Storage",
        icon = "#cuffs-check-inventory",
        functionName = "esx_property:openInventoryPropertyRadial"
    },
    ['animations:brave'] = {
        title = "Brave",
        icon = "#animation-brave",
        functionName = "dpemote:walkBraveRadial"
    },
    ['animations:hurry'] = {
        title = "Hurry",
        icon = "#animation-hurry",
        functionName = "dpemote:walkHurryRadial"
    },
    ['animations:business'] = {
        title = "Business",
        icon = "#animation-business",
        functionName = "dpemote:walkBusinessRadial"
    },
    ['animations:tipsy'] = {
        title = "Tipsy",
        icon = "#animation-tipsy",
        functionName = "dpemote:walkTipsyRadial"
    },
    ['animations:injured'] = {
        title = "Injured",
        icon = "#animation-injured",
        functionName = "dpemote:walkInjuredRadial"
    },
    ['animations:tough'] = {
        title = "Tough",
        icon = "#animation-tough",
        functionName = "dpemote:walkToughRadial"
    },
    ['animations:sassy'] = {
        title = "Sassy",
        icon = "#animation-sassy",
        functionName = "dpemote:walkSassyRadial"
    },
    ['animations:sad'] = {
        title = "Sad",
        icon = "#animation-sad",
        functionName = "dpemote:walkSadRadial"
    },
    ['animations:posh'] = {
        title = "Posh",
        icon = "#animation-posh",
        functionName = "dpemote:walkPoshRadial"
    },
    ['animations:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        functionName = "dpemote:walkAlienRadial"
    },
    ['animations:hobo'] = {
        title = "Hobo",
        icon = "#animation-hobo",
        functionName = "dpemote:walkHoboRadial"
    },
    ['animations:money'] = {
        title = "Money",
        icon = "#animation-money",
        functionName = "dpemote:walkMoneyRadial"
    },
    ['animations:swagger'] = {
        title = "Swagger",
        icon = "#animation-swagger",
        functionName = "dpemote:walkSwaggerRadial"
    },
    ['animations:shady'] = {
        title = "Shady",
        icon = "#animation-shady",
        functionName = "dpemote:walkShadyRadial"
    },
    ['animations:maneater'] = {
        title = "Man Eater",
        icon = "#animation-maneater",
        functionName = "dpemote:walkManEaterRadial"
    },
    ['animations:chichi'] = {
        title = "ChiChi",
        icon = "#animation-chichi",
        functionName = "dpemote:walkChiChiRadial"
    },
    ['animations:default'] = {
        title = "Default",
        icon = "#animation-default",
        functionName = "dpemote:walkDefaultRadial"
    },
    ['clothes:store'] = {
        title = "Closet",
        icon = "#police-check",
        functionName = "raid_clothes:openmenu"
    },
    ['k9:spawn'] = {
        title = "Summon",
        icon = "#k9-spawn",
        functionName = "K9:Create"
    },
    ['k9:delete'] = {
        title = "Dismiss",
        icon = "#k9-dismiss",
        functionName = "K9:Delete"
    },
    ['k9:follow'] = {
        title = "Follow",
        icon = "#k9-follow",
        functionName = "K9:Follow"
    },
    ['k9:vehicle'] = {
        title = "Get in/out",
        icon = "#k9-vehicle",
        functionName = "K9:Vehicle"
    },
    ['k9:sit'] = {
        title = "Sit",
        icon = "#k9-sit",
        functionName = "K9:Sit"
    },
    ['k9:lay'] = {
        title = "Lay",
        icon = "#k9-lay",
        functionName = "K9:Lay"
    },
    ['k9:stand'] = {
        title = "Stand",
        icon = "#k9-stand",
        functionName = "K9:Stand"
    },
    ['k9:sniff'] = {
        title = "Sniff Person",
        icon = "#k9-sniff",
        functionName = "K9:Sniff"
    },
    ['k9:sniffvehicle'] = {
        title = "Sniff Vehicle",
        icon = "#k9-sniff-vehicle",
        functionName = "sniffVehicle"
    },
    ['k9:huntfind'] = {
        title = "Hunt nearest",
        icon = "#k9-huntfind",
        functionName = "K9:Huntfind"
    },
    ['blips:gasstations'] = {
        title = "Gas Stations",
        icon = "#blips-gasstations",
        functionName = "CarPlayerHud:ToggleGas"
    },    
    ['blips:trainstations'] = {
        title = "Train Stations",
        icon = "#blips-trainstations",
        functionName = "Trains:ToggleTainsBlip"
    },
    ['blips:garages'] = {
        title = "Garages",
        icon = "#blips-garages",
        functionName = "Garages:ToggleGarageBlip"
    },
    ['blips:barbershop'] = {
        title = "Barber Shop",
        icon = "#blips-barbershop",
        functionName = "hairDresser:ToggleHair"
    },    
    ['blips:tattooshop'] = {
        title = "Tattoo Shop",
        icon = "#blips-tattooshop",
        functionName = "tattoo:ToggleTattoo"
    },
    ['drivinginstructor:drivingtest'] = {
        title = "Driving Test",
        icon = "#drivinginstructor-drivingtest",
        functionName = "drivingInstructor:testToggle"
    },
    ['drivinginstructor:submittest'] = {
        title = "Submit Test",
        icon = "#drivinginstructor-submittest",
        functionName = "drivingInstructor:submitTest"
    },
    ['judge-raid:checkowner'] = {
        title = "Check Owner",
        icon = "#judge-raid-check-owner",
        functionName = "appartment:CheckOwner"
    },
    ['judge-raid:seizeall'] = {
        title = "Seize All Content",
        icon = "#judge-raid-seize-all",
        functionName = "appartment:SeizeAll"
    },
    ['judge-raid:takecash'] = {
        title = "Take Cash",
        icon = "#judge-raid-take-cash",
        functionName = "appartment:TakeCash"
    },
    ['judge-raid:takedm'] = {
        title = "Take Marked Bills",
        icon = "#judge-raid-take-dm",
        functionName = "appartment:TakeDM"
    },
    ['cuffs:cuff'] = {
        title = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "esx_policejob:handCuffRadial"
    },
    ['cuffs:uncuff'] = {
        title = "Uncuff",
        icon = "#cuffs-uncuff",
        functionName = "police:uncuffMenu"
    },
    ['cuffs:remmask'] = {
        title = "Remove Mask Hat",
        icon = "#cuffs-remove-mask",
        functionName = "raid_clothes:policeRemovePropsRadial"
    },
    ['cuffs:checkinventory'] = {
        title = "Search Person",
        icon = "#cuffs-check-inventory",
        functionName = "esx_policejob:CheckInventoryRadial"
    },
    ['cuffs:unseat'] = {
        title = "Unseat",
        icon = "#cuffs-unseat-player",
        functionName = "esx_policejob:OutVehicleRadial"
    },
    ['cuffs:checkphone'] = {
        title = "Read Phone",
        icon = "#cuffs-check-phone",
        functionName = "police:checkPhone"
    },
    ['medic:revive'] = {
        title = "Revive",
        icon = "#medic-revive",
        functionName = "esx_ambulancejob:revivePlayerRadial"
    },
    ['medic:heal'] = {
        title = "Heal",
        icon = "#medic-heal",
        functionName = "esx_ambulancejob:healPlayerRadial"
    },
    ['medic:escort'] = {
        title = "Escort",
        icon = "#general-escort",
        functionName = "esx_ambulancejob:dragRadial"
    },
    ['medic:putInVeh'] = {
        title = "Seat Vehicle",
        icon = "#general-put-in-veh",
        functionName = "esx_ambulancejob:putInVehicleRadial"
    },
    ['medic:putOutVeh'] = {
        title = "Unseat Vehicle",
        icon = "#general-unseat-nearest",
        functionName = "esx_ambulancejob:OutVehicleRadial"
    },
    ['police:cuff'] = {
        title = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "esx_policejob:handCuffRadial"
    },
    ['police:checkbank'] = {
        title = "Check Bank",
        icon = "#police-check-bank",
        functionName = "police:checkBank"
    },
    ['police:checklicenses'] = {
        title = "Check Licenses",
        icon = "#police-check-licenses",
        functionName = "police:checkLicenses"
    },
    ['police:removeweapons'] = {
        title = "Remove Weapons License",
        icon = "#police-action-remove-weapons",
        functionName = "police:removeWeapon"
    },
    ['police:gsr'] = {
        title = "GSR Test",
        icon = "#police-action-gsr",
        functionName = "police:gsr"
    },
    ['police:dnaswab'] = {
        title = "DNA Swab",
        icon = "#police-action-dna-swab",
        functionName = "evidence:dnaSwab"
    },
    ['police:toggleradar'] = {
        title = "Toggle Radar",
        icon = "#police-vehicle-radar",
        functionName = "startSpeedo"
    },
    ['police:runplate'] = {
        title = "Run Plate",
        icon = "#police-vehicle-plate",
        functionName = "esx_policejob:runPlateRadial"
    },
    ['police:frisk'] = {
        title = "Frisk",
        icon = "#police-action-frisk",
        functionName = "esx_policejob:FriskRadial"
    },
    ['police:escort'] = {
        title = "Escort",
        icon = "#general-escort",
        functionName = "esx_policejob:dragRadial"
    },
    ['police:putInVeh'] = {
        title = "Seat Vehicle",
        icon = "#general-put-in-veh",
        functionName = "esx_policejob:putInVehicleRadial"
    },
    ['garage:putaway'] = {
        title = "Put Away",
        icon = "#police-action-frisk",
        functionName = "advancedGarage:StoreOwnedPoliceRadial"
    },
    ['garage:takeout'] = {
        title = "Take Out",
        icon = "#general-keys-give",
        functionName = "advancedGarage:OpenJobGarageRadial"
    },
    ['garageCiv:putaway'] = {
        title = "Put Away",
        icon = "#police-action-frisk",
        functionName = "advancedGarage:StoreOwnedPoliceRadial"
    },
    ['garageCiv:takeout'] = {
        title = "Take Out",
        icon = "#general-keys-give",
        functionName = "advancedGarage:OpenGarageCivRadial"
    },
    ['judge:grantDriver'] = {
        title = "Grant Drivers",
        icon = "#judge-licenses-grant-drivers",
        functionName = "police:grantDriver"
    }, 
    ['judge:grantBusiness'] = {
        title = "Grant Business",
        icon = "#judge-licenses-grant-business",
        functionName = "police:grantBusiness"
    },  
    ['judge:grantWeapon'] = {
        title = "Grant Weapon",
        icon = "#judge-licenses-grant-weapon",
        functionName = "police:grantWeapon"
    },
    ['judge:grantHouse'] = {
        title = "Grant House",
        icon = "#judge-licenses-grant-house",
        functionName = "police:grantHouse"
    },
    ['judge:grantBar'] = {
        title = "Grant BAR",
        icon = "#judge-licenses-grant-bar",
        functionName = "police:grantBar"
    },
    ['judge:grantDA'] = {
        title = "Grant DA",
        icon = "#judge-licenses-grant-da",
        functionName = "police:grantDA"
    },
    ['judge:removeDriver'] = {
        title = "Remove Drivers",
        icon = "#judge-licenses-remove-drivers",
        functionName = "police:removeDriver"
    },
    ['judge:removeBusiness'] = {
        title = "Remove Business",
        icon = "#judge-licenses-remove-business",
        functionName = "police:removeBusiness"
    },
    ['judge:removeWeapon'] = {
        title = "Remove Weapon",
        icon = "#judge-licenses-remove-weapon",
        functionName = "police:removeWeapon"
    },
    ['judge:removeHouse'] = {
        title = "Remove House",
        icon = "#judge-licenses-remove-house",
        functionName = "police:removeHouse"
    },
    ['judge:removeBar'] = {
        title = "Remove BAR",
        icon = "#judge-licenses-remove-bar",
        functionName = "police:removeBar"
    },
    ['judge:removeDA'] = {
        title = "Remove DA",
        icon = "#judge-licenses-remove-da",
        functionName = "police:removeDA"
    },
    ['judge:denyWeapon'] = {
        title = "Deny Weapon",
        icon = "#judge-licenses-deny-weapon",
        functionName = "police:denyWeapon"
    },
    ['judge:denyDriver'] = {
        title = "Deny Drivers",
        icon = "#judge-licenses-deny-drivers",
        functionName = "police:denyDriver"
    },
    ['judge:denyBusiness'] = {
        title = "Deny Business",
        icon = "#judge-licenses-deny-business",
        functionName = "police:denyBusiness"
    },
    ['judge:denyHouse'] = {
        title = "Deny House",
        icon = "#judge-licenses-deny-house",
        functionName = "police:denyHouse"
    },
    ['news:setCamera'] = {
        title = "Camera",
        icon = "#news-job-news-camera",
        functionName = "Cam:ToggleCam"
    },
    ['news:setMicrophone'] = {
        title = "Microphone",
        icon = "#news-job-news-microphone",
        functionName = "Mic:ToggleMic"
    },
    ['news:setBoom'] = {
        title = "Microphone Boom",
        icon = "#news-job-news-boom",
        functionName = "Mic:ToggleBMic"
    },
    ['weed:currentStatusServer'] = {
        title = "Request Status",
        icon = "#weed-cultivation-request-status",
        functionName = "weed:currentStatusServer"
    },   
    ['weed:weedCrate'] = {
        title = "Remove A Crate",
        icon = "#weed-cultivation-remove-a-crate",
        functionName = "weed:weedCrate"
    },
    ['cocaine:currentStatusServer'] = {
        title = "Request Status",
        icon = "#meth-manufacturing-request-status",
        functionName = "cocaine:currentStatusServer"
    },
    ['cocaine:methCrate'] = {
        title = "Remove A Crate",
        icon = "#meth-manufacturing-remove-a-crate",
        functionName = "cocaine:methCrate"
    },
    ["expressions:angry"] = {
        title="Angry",
        icon="#expressions-angry",
        functionName = "dpemotes:emoteRadial",
        functionParameters =  { "Angry" }
    },
    ["expressions:drunk"] = {
        title="Drunk",
        icon="#expressions-drunk",
        functionName = "dpemotes:emoteRadial",
        functionParameters =  { "Drunk" }
    },
    ["expressions:dumb"] = {
        title="Dumb",
        icon="#expressions-dumb",
        functionName = "dpemotes:emoteRadial",
        functionParameters =  { "Dumb" }
    },
    ["expressions:electrocuted"] = {
        title="Electrocuted",
        icon="#expressions-electrocuted",
        functionName = "dpemotes:emoteRadial",
        functionParameters =  { "Electrocuted" }
    },
    ["expressions:grumpy"] = {
        title="Grumpy",
        icon="#expressions-grumpy",
        functionName = "dpemotes:emoteRadial", 
        functionParameters =  { "Grumpy2" }
    },
    ["expressions:happy"] = {
        title="Happy",
        icon="#expressions-happy",
        functionName = "dpemotes:emoteRadial",
        functionParameters =  { "Happy" }
    },
    ["expressions:injured"] = {
        title="Injured",
        icon="#expressions-injured",
        functionName = "dpemotes:emoteRadial",
        functionParameters =  { "Injured" }
    },
    ["expressions:joyful"] = {
        title="Joyful",
        icon="#expressions-joyful",
        functionName = "dpemotes:emoteRadial",
        functionParameters =  { "Joyful" }
    },
    ["expressions:mouthbreather"] = {
        title="Mouthbreather",
        icon="#expressions-mouthbreather",
        functionName = "dpemotes:emoteRadial",
        functionParameters = { "Mouthbreather" }
    },
    ["expressions:normal"]  = {
        title="Normal",
        icon="#expressions-normal",
        functionName = "dpemotes:emoteRadial",
        functionParameters = { "Never Blink" }
    },
    ["expressions:oneeye"]  = {
        title="One Eye",
        icon="#expressions-oneeye",
        functionName = "dpemotes:emoteRadial",
        functionParameters = { "One Eye" }
    },
    ["expressions:shocked"]  = {
        title="Shocked",
        icon="#expressions-shocked",
        functionName = "dpemotes:emoteRadial",
        functionParameters = { "Shocked" }
    },
    ["expressions:sleeping"]  = {
        title="Sleeping",
        icon="#expressions-sleeping",
        functionName = "dpemotes:emoteRadial",
        functionParameters = { "Sleeping2" }
    },
    ["expressions:smug"]  = {
        title="Smug",
        icon="#expressions-smug",
        functionName = "dpemotes:emoteRadial",
        functionParameters = { "Smug" }
    },
    ["expressions:speculative"]  = {
        title="Speculative",
        icon="#expressions-speculative",
        functionName = "dpemotes:emoteRadial",
        functionParameters = { "Speculative" }
    },
    ["expressions:stressed"]  = {
        title="Stressed",
        icon="#expressions-stressed",
        functionName = "dpemotes:emoteRadial",
        functionParameters = { "Stressed" }
    },
    ["expressions:sulking"]  = {
        title="Sulking",
        icon="#expressions-sulking",
        functionName = "dpemotes:emoteRadial",
        functionParameters = { "Sulking" },
    },
    ["expressions:weird"]  = {
        title="Weird",
        icon="#expressions-weird",
        functionName = "dpemotes:emoteRadial",
        functionParameters = { "Weird" }
    },
    ["expressions:weird2"]  = {
        title="Weird 2",
        icon="#expressions-weird2",
        functionName = "dpemotes:emoteRadial",
        functionParameters = { "Weird2" }
    },
    ["towing:impound"]  = {
        title="Impound",
        icon="#judge-licenses-remove-drivers",
        functionName = "erp_towscript:depositRadial",
        functionParameters = {}
    }
}

RegisterNetEvent("menu:setCuffState")
AddEventHandler("menu:setCuffState", function(pTargetId, pState)
    cuffStates[pTargetId] = pState
end)


RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
    isJudge = true
end)

RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
    if isMedic and job ~= "ambulance" then isMedic = false end
    if isPolice and job ~= "police" then isPolice = false end
    if isDoctor and job ~= "doctor" then isDoctor = false end
    if isNews and job ~= "reporter" then isNews = false end
    if job == "police" then isPolice = true end
    if job == "ambulance" then isMedic = true end
    if job == "reporter" then isNews = true end
    if job == "doctor" then isDoctor = true end
    myJob = job
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)

RegisterNetEvent("drivingInstructor:instructorToggle")
AddEventHandler("drivingInstructor:instructorToggle", function(mode)
    if myJob == "driving instructor" then
        isInstructorMode = mode
    end
end)

RegisterNetEvent("police:currentHandCuffedState")
AddEventHandler("police:currentHandCuffedState", function(pIsHandcuffed, pIsHandcuffedAndWalking)
    isHandcuffedAndWalking = pIsHandcuffedAndWalking
    isHandcuffed = pIsHandcuffed
end)

RegisterNetEvent("menu:hasOxygenTank")
AddEventHandler("menu:hasOxygenTank", function(pHasOxygenTank)
    hasOxygenTankOn = pHasOxygenTank
end)

RegisterNetEvent('enablegangmember')
AddEventHandler('enablegangmember', function(pGangNum)
    gangNum = pGangNum
end)

function checkStrechter()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local closestObject = GetClosestVehicle(pedCoords, 3.0, GetHashKey("stretcher"), 70)
    return DoesEntityExist(closestObject)
end
function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end

local idToRob

function canPlayerBeRobbed()
    player,dis = ESX.Game.GetClosestPlayer()
    local id = GetPlayerServerId(player)
    local robbable = nil
    if player ~= -1 then 
        ESX.TriggerServerCallback('esx_thief:getValue', function(result)
            local result = result
            if result.value then
                robbable = true
                idToRob = id
            else
                robbable = false
                idToRob = nil
            end
        end, id)
    else
        robbable= false
    end
    while robbable == nil do
        Wait(10)
    end
    print(robbable)
    return robbable
end

RegisterNetEvent('np-menu:intiateRobbing')
AddEventHandler('np-menu:intiateRobbing', function()
	TriggerServerEvent('esx_policejob:getPlayerID', idToRob, distance, 'rob')
end)

RegisterNetEvent('np-menu:robPlayer')
AddEventHandler('np-menu:robPlayer', function(distance, identifier)
    local player = PlayerPedId()
    if distance < 2 then
        exports['progressBars']:startUI(7000, "Robbing player")
        FreezeEntityPosition(player, true)
        TaskStartScenarioInPlace(player, "PROP_HUMAN_BUM_BIN", 0, true)
        Citizen.Wait(7000)
        FreezeEntityPosition(player, false)
        ClearPedTasks(player)
        exports["mf-inventory"]:openOtherInventory(identifier)
    end
end)

trainstations = {
    {-547.34057617188,-1286.1752929688,25.3059978411511},
    {-892.66284179688,-2322.5168457031,-13.246466636658},
    {-1100.2299804688,-2724.037109375,-8.3086919784546},
    {-1071.4924316406,-2713.189453125,-8.9240007400513},
    {-875.61907958984,-2319.8686523438,-13.241264343262},
    {-536.62890625,-1285.0009765625,25.301458358765},
    {270.09558105469,-1209.9177246094,37.465930938721},
    {-287.13568115234,-327.40936279297,8.5491418838501},
    {-821.34295654297,-132.45257568359,18.436864852905},
    {-1359.9794921875,-465.32354736328,13.531299591064},
    {-498.96591186523,-680.65930175781,10.295949935913},
    {-217.97073364258,-1032.1605224609,28.724565505981},
    {113.90325164795,-1729.9976806641,28.453630447388},
    {117.33223724365,-1721.9318847656,28.527353286743},
    {-209.84713745117,-1037.2414550781,28.722997665405},
    {-499.3971862793,-665.58514404297,10.295639038086},
    {-1344.5224609375,-462.10494995117,13.531820297241},
    {-806.85192871094,-141.39852905273,18.436403274536},
    {-302.21514892578,-327.28854370117,8.5495929718018},
    {262.01733398438,-1198.6135253906,37.448017120361},
    {2072.4086914063,1569.0856933594,76.712524414063},
    {664.93090820313,-997.59942626953,22.261747360229},
    {190.62687683105,-1956.8131103516,19.520135879517},
    {2611.0278320313,1675.3806152344,26.578210830688},
    {2615.3901367188,2934.8666992188,39.312232971191},
    {2885.5346679688,4862.0146484375,62.551517486572},
    {47.061096191406,6280.8969726563,31.580261230469},
    {2002.3624267578,3619.8029785156,38.568252563477},
    {2609.7016601563,2937.11328125,39.418235778809}
}
