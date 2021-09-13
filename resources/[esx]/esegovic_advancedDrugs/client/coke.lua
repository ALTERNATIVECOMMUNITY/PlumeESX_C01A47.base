RawCoke = function(a)
    local b = PlayerPedId()
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 7500,
            label = Config.Translate[601],
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "anim@amb@business@coc@coc_unpack_cut_left@",
                anim = "coke_cut_v5_coccutter",
                flags = 49
            },
            prop = {
                model = "prop_cs_credit_card",
                bone = 6286,
                coords = {x = 0.12, y = 0.0, z = -0.06},
                rotation = {x = 0.0, y = 0.0, z = 0.0}
            }
        },
        function(c)
            if not c then
                ClearPedTasks(PlayerPedId())
            else
                ClearPedTasks(PlayerPedId())
            end
        end
    )
    Citizen.Wait(7700)
end
MixCocaine = function()
    local b = PlayerPedId()
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 13000,
            label = Config.Translate[602],
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "anim@amb@business@coc@coc_packing_hi@",
                anim = "full_cycle_v3_pressoperator",
                flags = 49
            },
            prop = {
                model = "bkr_prop_coke_spoon_01",
                bone = 6286,
                coords = {x = 0.12, y = 0.1, z = -0.06},
                rotation = {x = 180.0, y = 180.0, z = 0.0}
            }
        },
        function(c)
            if not c then
                ClearPedTasks(PlayerPedId())
            else
                ClearPedTasks(PlayerPedId())
            end
        end
    )
    Citizen.Wait(13700)
end
PackCocaine = function()
    local b = PlayerPedId()
    local d = GetHashKey("v_ind_meatboxsml")
    local e = 179.99
    RequestModel(d)
    while not HasModelLoaded(d) do
        Citizen.Wait(1)
    end
    local f = vector3(1100.36, -3199.5, -39.2)
    local g = CreateObject(d, f, false, false, true)
    SetEntityHeading(g, e)
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 15500,
            label = Config.Translate[618],
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "anim@amb@business@meth@meth_smash_weight_check@",
                anim = "break_weigh_v3_char01",
                flags = 49
            }
        },
        function(c)
            if not c then
                ClearPedTasks(PlayerPedId())
            else
                ClearPedTasks(PlayerPedId())
            end
        end
    )
    Citizen.Wait(15700)
    DeleteEntity(g, true)
    ESX.ShowNotification(Config.Translate[609])
    local h = math.random(0, 100)
    local i = vector3(-1321.88, -247.52, 42.48)
    if h > 27 then
        TriggerServerEvent("esegovic:notifiPolice", i)
    end
end
if Config.EnableCokeBlip then
    Citizen.CreateThread(
        function()
            for j, k in pairs(Config.Teleports) do
                for l = 1, #k.TeleportForCokeIN, 1 do
                    local m = AddBlipForCoord(k.TeleportForCokeIN[l])
                    SetBlipSprite(m, 499)
                    SetBlipDisplay(m, 4)
                    SetBlipScale(m, 0.8)
                    SetBlipColour(m, 0)
                    SetBlipAsShortRange(m, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentSubstringPlayerName(Config.CokeBlipName)
                    EndTextCommandSetBlipName(m)
                end
            end
        end
    )
end
