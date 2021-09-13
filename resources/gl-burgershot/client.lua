ESX                             = nil
local charge = 0

local display = false

local bossSpawned = false
local PlayerJob

    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end
        PlayerJob = ESX.GetPlayerData().job
        RegisterNetEvent('esx:setJob')
		AddEventHandler('esx:setJob', function(job)
		    PlayerJob = job
		end)
        --[[
        exports["bt-target"]:AddBoxZone("TowDuty", vector3(-192.54, -1161.95, 23.2), 0.4, 0.6, { 
            name="TowDuty",
            heading=83.71,
            debugPoly=false,
            minZ=23.3,
            maxZ=23.7
            }, {
                options = {
                    {
                        event = "gl-burgershot:Tray",
                        icon = "far fa-clipboard",
                        label = "Sign In/Out",
                    },
                },
                job = {"all"},
                distance = 3.0
        })
        ]]--
        
    end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)



-- Spawn Boss NPC When you get close, delete when you leave
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
			local pedCoords = GetEntityCoords(GetPlayerPed(-1))
			local bossCoords = vector3(-1195.873, -901.336, 12.995)	
			local dst = #(bossCoords - pedCoords)
			
			if dst < 200 and bossSpawned == false then
				TriggerEvent('gl-burgershot:spawnBoss',bossCoords,14.032)
				bossSpawned = true
			end
			if dst >= 201  then
				bossSpawned = false
				DeletePed(npc)
			end
	end
end)

-- Refresh EntityZones for the cars/tow trucks & Draw Blips
Citizen.CreateThread(function()

if Config.EnableBlip then
		blip = AddBlipForCoord(-1193.86200, -894.37900, 14.01902)
		SetBlipSprite(blip, 106)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Burger Shot")
		EndTextCommandSetBlipName(blip)
end

    local burgerManager = {
        `u_m_y_burgerdrug_01`,
    }

	exports['bt-target']:AddTargetModel(burgerManager, {
        options = {
            {
                event = "gl-burgershot:openBossMenu",
                icon = "fas fa-clipboard",
                label = "Open Boss Menu",
            },

        },
        job = {"burgershot"},
        distance = 2.5
    })

    local MakeMeal = {
        `prop_food_bs_bag_01`,
    }

	exports['bt-target']:AddTargetModel(MakeMeal, {
        options = {
            {
                event = "gl-burgershot:makeMeal1",
                icon = "fas fa-hamburger",
                label = "Moneyshot Meal",
            },
            {
                event = "gl-burgershot:makeMeal2",
                icon = "fas fa-hamburger",
                label = "Bleeder Meal",
            },
            {
                event = "gl-burgershot:makeMeal3",
                icon = "fas fa-hamburger",
                label = "Heartstopper Meal",
            },

        },
        job = {"burgershot"},
        distance = 2.5
    })

	-- Cash Register
    exports['bt-target']:AddBoxZone("BurgerPay", vector3(-1193.33,-895.05,14.09839), 0.8, 0.4, {
        name="BurgerPay",
        heading=125.0,
        debugPoly=false,
        minZ=14.000,
        maxZ=14.30
    }, {
        options = {
            {
            event = "gl-burgershot:payorder",
            icon = "fas fa-cash-register",
            label = "Interact",
            },
        },
            job = {"all"},
            distance = 2.5 
    })

    exports['bt-target']:AddBoxZone("BurgerPay2", vector3(-1194.64,-893.40,14.09839), 0.8, 0.4, {
        name="BurgerPay2",
        heading=125.0,
        debugPoly=false,
        minZ=14.000,
        maxZ=14.30
    }, {
        options = {
            {
            event = "gl-burgershot:payorder",
            icon = "fas fa-cash-register",
            label = "Interact",
            },
        },
            job = {"all"},
            distance = 2.5 
    })

    exports['bt-target']:AddBoxZone("BurgerPay3", vector3(-1195.96,-891.31,14.09839), 0.8, 0.4, {
        name="BurgerPay3",
        heading=125.0,
        debugPoly=false,
        minZ=14.000,
        maxZ=14.30
    }, {
        options = {
            {
            event = "gl-burgershot:payorder",
            icon = "fas fa-cash-register",
            label = "Interact",
            },
        },
            job = {"all"},
            distance = 2.5 
    })

-- Storage Freezer
    exports['bt-target']:AddBoxZone("Freezer", vector3(-1204.23, -896.15, 13.0), 2.25, 2.25, {
        name="Freezer",
        heading=124.0,
        debugPoly=false,
        minZ=12.6,
        maxZ=14.75
    }, {
        options = {
       	{
        event = "gl-burgershot:grabBun",
        icon = "fas fa-hand-paper",
        label = "Grab a Bun",
        },        	
       	{
        event = "gl-burgershot:grabMeat",
        icon = "fas fa-hand-paper",
        label = "Grab Raw Meat",
        },
        {
        event = "gl-burgershot:grabPotatoe",
        icon = "fas fa-hand-paper",
        label = "Grab a Potatoe",
        },
    },
        job = {"burgershot"},
        distance = 3.0
    })

-- Frier
    exports['bt-target']:AddBoxZone("Frier", vector3(-1201.789, -899.025, 13.943), 0.8, 1.8, {
        name="Frier",
        heading=304.2,
        debugPoly=false,
        minZ=13.6,
        maxZ=14.3
    }, {
        options = {
        {
        event = "gl-burgershot:makeFries",
        icon = "fas fa-temperature-high",
        label = "Fry Fries",
        },
    },
        job = {"burgershot"},
        distance = 1.5
    })

    exports['bt-target']:AddBoxZone("PrepareBurger", vector3(-1197.48, -899.32, 13.909), 0.8, 2, {
        name="PrepareBurger",
        heading=34.0,
        debugPoly=false,
        minZ=13.6,
        maxZ=14.3
    }, {
        options = {
        {
        event = "gl-burgershot:prepareMoneyShot",
        icon = "fas fa-hamburger",
        label = "Prepare Moneyshot",
        },
        {
        event = "gl-burgershot:prepareBleeder",
        icon = "fas fa-hamburger",
        label = "Prepare Bleeder",
        },
        {
        event = "gl-burgershot:prepareHeartStopper",
        icon = "fas fa-hamburger",
        label = "Prepare Heartstopper",
        },
    },
        job = {"burgershot"},
        distance = 1.5
    })

    exports['bt-target']:AddBoxZone("DrinkMachineBS", vector3(-1199.679, -895.84, 13.909), 1.2, 1.7, {
        name="DrinkMachineBS",
        heading=302.679,
        debugPoly=false,
        minZ=13.6,
        maxZ=15.3
    }, {
        options = {
        {
        event = "gl-burgershot:grabDrink",
        icon = "fab fa-gulp",
        label = "Grab a drink",
        },
    },
        job = {"burgershot"},
        distance = 1.5
    })

    exports['bt-target']:AddBoxZone("CookMeat", vector3(-1202.791, -897.289, 13.96), 0.8, 1.2, {
        name="CookMeat",
        heading=302.679,
        debugPoly=false,
        minZ=13.6,
        maxZ=14.3
    }, {
        options = {
        {
        event = "gl-burgershot:cookMeat",
        icon = "fas fa-temperature-high",
        label = "Cook the patty",
        },
    },
        job = {"burgershot"},
        distance = 1.5
    })

    exports['bt-target']:AddBoxZone("MealStorage", vector3(-1197.69, -894.29, 14.0),5.0, 1.2, {
        name="MealStorage",
        heading=35.25,
        debugPoly=false,
        minZ=13.0,
        maxZ=14.25
    }, {
        options = {
        {
        event = "gl-burgershot:openHotbox",
        icon = "fas fa-box-open",
        label = "Open Hotbox",
        },
    },
        job = {"burgershot"},
        distance = 1.5
    })

    exports['bt-target']:AddBoxZone("MealTray", vector3(-1194.033, -894.24, 14.01),.3, .6, {
        name="MealStorage",
        heading=304.02,
        debugPoly=false,
        minZ=14.0,
        maxZ=14.25
    }, {
        options = {
        {
        event = "gl-burgershot:openTray1",
        icon = "fas fa-box-open",
        label = "Open Tray",
        },
    },
        job = {"all"},
        distance = 1.5
    })

    exports['bt-target']:AddBoxZone("MealTray2", vector3(-1195.322, -892.3327, 14.0),.3, .6, {
        name="MealStorage",
        heading=304.02,
        debugPoly=false,
        minZ=14.0,
        maxZ=14.25
    }, {
        options = {
        {
        event = "gl-burgershot:openTray2",
        icon = "fas fa-box-open",
        label = "Open Tray",
        },
    },
        job = {"all"},
        distance = 1.5
    })

    RequestModel(2372568234)
    CreateObject(2372568234, -1198.681, -898.76, 13.90, true, false)
end)

--STORAGE--
RegisterNetEvent('gl-burgershot:openHotbox')
AddEventHandler('gl-burgershot:openHotbox', function()
    exports["mf-inventory"]:openOtherInventory('burgerHotbox')
end)

RegisterNetEvent('gl-burgershot:openTray1')
AddEventHandler('gl-burgershot:openTray1', function()
    exports["mf-inventory"]:openOtherInventory('burgerFridge')
end)

RegisterNetEvent('gl-burgershot:openTray2')
AddEventHandler('gl-burgershot:openTray2', function()
    exports["mf-inventory"]:openOtherInventory('burgerFridge')
end)

-- PAYMENT STUFF --
RegisterNetEvent('gl-burgershot:payorder')
AddEventHandler('gl-burgershot:payorder', function()
    if PlayerJob.name == 'burgershot' then
        TriggerEvent('gl-burgershot:drawNui')
    else
        TriggerServerEvent('gl-burgershot:chargeMe')
        TriggerServerEvent('gl-burgershot:notifyPaymentServer')

    end
end)

RegisterNetEvent('gl-burgershot:notifyPaymentClient')
AddEventHandler('gl-burgershot:notifyPaymentClient', function(OrderTotal)
  if PlayerJob.name == 'burgershot' then
    exports['mythic_notify']:DoHudText('success', "An order was paid for, amount: $" .. OrderTotal, 8500)
  end
end)

-- Debug Command only for Video Recording 
RegisterCommand('chargeMe',function()
TriggerServerEvent('gl-burgershot:chargeMe')
TriggerServerEvent('gl-burgershot:notifyPaymentServer')
end)


                -- Grab raw Meat --
RegisterNetEvent('gl-burgershot:grabMeat')
AddEventHandler('gl-burgershot:grabMeat',function()
    TriggerServerEvent('gl-burgershot:addItem', 'meat')
    TriggerServerEvent('gl-burgershot:chargeSociety',Config.MeatPrice)
    exports['mythic_notify']:DoHudText('success', "For the Meat, Burgershot paid " .. Config.MeatPrice, 8500)
end)

                -- Grab Potatoe --
RegisterNetEvent('gl-burgershot:grabPotatoe')
AddEventHandler('gl-burgershot:grabPotatoe',function()
    TriggerServerEvent('gl-burgershot:addItem', 'potatoe')
    TriggerServerEvent('gl-burgershot:chargeSociety',Config.PotatoePrice)
    exports['mythic_notify']:DoHudText('success', "For the potatoe, Burgershot paid " .. Config.PotatoePrice, 8500)
end)

                -- Grab Bun --
RegisterNetEvent('gl-burgershot:grabBun')
AddEventHandler('gl-burgershot:grabBun',function()
    TriggerServerEvent('gl-burgershot:addItem', 'bun')
    TriggerServerEvent('gl-burgershot:chargeSociety',Config.BunPrice)
    exports['mythic_notify']:DoHudText('success', "For the bun, Burgershot paid " .. Config.BunPrice, 8500)
end)


RegisterNetEvent('gl-burgershot:getcharged')
AddEventHandler('gl-burgershot:getcharged', function(OrderTotal)
    print('triggered')
	if OrderTotal ~=0  then
        TriggerServerEvent('gl-burgershot:sendpayamount', OrderTotal)
        exports['mythic_notify']:DoHudText('success', "You paid " .. OrderTotal, 8500)
        TriggerServerEvent('gl-burgershot:createCharge',0)
	else
		exports['mythic_notify']:DoHudText('error', "No Pending Charges ", 8500)
	end
end)
-- END PAYMENT STUFF --



				-- Spawn Boss NPC --
RegisterNetEvent('gl-burgershot:spawnBoss')
AddEventHandler('gl-burgershot:spawnBoss',function(coords,heading)
	local hash = GetHashKey('u_m_y_burgerdrug_01')
	if not HasModelLoaded(hash) then
		RequestModel(hash)
		Wait(10)
	end
	while not HasModelLoaded(hash) do 
		Wait(10)
	end

    bossSpawned = true
	npc = CreatePed(5, hash, coords, heading, false, false)
	FreezeEntityPosition(npc, true)
	SetEntityInvincible(npc, true)
	SetBlockingOfNonTemporaryEvents(npc, true)
	while not TaskStartScenarioInPlace(npc,"WORLD_HUMAN_CLIPBOARD_FACILITY", 0, false) do
		Wait(200)
	end
end)

				-- Cook Meat --
RegisterNetEvent('gl-burgershot:cookMeat')
AddEventHandler('gl-burgershot:cookMeat',function()
TriggerServerEvent('gl-burgershot:checkCanCraft','cookedmeat')
end)
				-- Grab a Drink --
RegisterNetEvent('gl-burgershot:grabDrink')
AddEventHandler('gl-burgershot:grabDrink',function()
loadAnimDict( "anim@mp_player_intupperspray_champagne" )
TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intupperspray_champagne", "idle_a", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
Wait(2000)
ClearPedTasks(GetPlayerPed(-1))
TriggerServerEvent('gl-burgershot:addItem', 'cocacola')
end)

--[[ MEALS]]

				-- Make Money Shot Burger --
RegisterNetEvent('gl-burgershot:makeMeal1')
AddEventHandler('gl-burgershot:makeMeal1',function()
TriggerServerEvent('gl-burgershot:checkCanCraft','meal1')
end)

RegisterNetEvent('gl-burgershot:makeMeal2')
AddEventHandler('gl-burgershot:makeMeal2',function()
TriggerServerEvent('gl-burgershot:checkCanCraft','meal2')
end)

RegisterNetEvent('gl-burgershot:makeMeal3')
AddEventHandler('gl-burgershot:makeMeal3',function()
TriggerServerEvent('gl-burgershot:checkCanCraft','meal3')
end)


--[[ END MEALS ]]

				-- Make Money Shot Burger --
RegisterNetEvent('gl-burgershot:prepareMoneyShot')
AddEventHandler('gl-burgershot:prepareMoneyShot',function()
TriggerServerEvent('gl-burgershot:checkCanCraft','moneyshot')
end)

				-- Make Bleeder Burger --
RegisterNetEvent('gl-burgershot:prepareBleeder')
AddEventHandler('gl-burgershot:prepareBleeder',function()
TriggerServerEvent('gl-burgershot:checkCanCraft','bleeder')
end)


			-- Make Heart Stopper Burger --
RegisterNetEvent('gl-burgershot:prepareHeartStopper')
AddEventHandler('gl-burgershot:prepareHeartStopper',function()
TriggerServerEvent('gl-burgershot:checkCanCraft','heartstopper')
end)
-- Burger prepare animation
RegisterNetEvent('gl-burgershot:cookAnimation')
AddEventHandler('gl-burgershot:cookAnimation',function(Animation)
local ped = GetPlayerPed(-1)
TaskStartScenarioInPlace(ped,Animation, 0, false)
Wait(10000)
ClearPedTasks(ped)
end)

				-- Make Fries --
RegisterNetEvent('gl-burgershot:makeFries')
AddEventHandler('gl-burgershot:makeFries',function()
TriggerServerEvent('gl-burgershot:checkCanCraft','fries')
end)

-- Open Boss Menu
RegisterNetEvent('gl-burgershot:openBossMenu')
AddEventHandler('gl-burgershot:openBossMenu',function()
	TriggerEvent('esx_society:openBossMenu', 'burgershot', function(data, menu)
		menu.close()
	end)
end)

------- Functions if needed ----------

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end


-- NUI STUFF --

RegisterNetEvent('gl-burgershot:drawNui')
AddEventHandler('gl-burgershot:drawNui',function()
    SetDisplay(not display)
end)

--very important cb 
RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

-- this cb is used as the main route to transfer data back 
-- and also where we hanld the data sent from js
RegisterNUICallback("main", function(data)
	amount = tonumber(data.text)
	TriggerServerEvent('gl-burgershot:createCharge', amount)
    SetDisplay(false)
end)

RegisterNUICallback("error", function(data)
    SetDisplay(false)
end)


function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)
