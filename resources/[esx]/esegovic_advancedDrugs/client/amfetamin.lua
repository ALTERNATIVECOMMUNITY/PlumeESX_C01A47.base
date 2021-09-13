Fluid1stFunction = function()
    local a = PlayerPedId()
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 3000,
            label = Config.Translate[132],
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {animDict = "mini@repair", anim = "fixing_a_player"}
        },
        function(b)
            if not b then
                ClearPedTasks(a)
                ESX.ShowNotification(Config.Translate[133])
            else
                ClearPedTasks(a)
            end
        end
    )
    Citizen.Wait(3000)
end
local c = false
funkcija1123453 = function()
    if not c then
        local a = PlayerPedId()
        exports[Config.FolderNameMythicProgbar]:Progress(
            {
                name = "unique_action_name",
                duration = 3000,
                label = Config.Translate[134],
                useWhileDead = true,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                },
                animation = {animDict = "mini@repair", anim = "fixing_a_player"}
            },
            function(b)
                if not b then
                    ClearPedTasks(a)
                else
                    ClearPedTasks(a)
                end
            end
        )
        Citizen.Wait(3000)
        esegaSupak2()
    end
end
esegaSupak2 = function()
    c = true
    second = 60
    for d = 1, 60 do
        Citizen.Wait(1000)
        second = second - 1
    end
    c = false
    ESX.ShowNotification(Config.Translate[135])
end
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if c then
                for e, f in pairs(Config.Amfetamin) do
                    for d = 1, #f.CoolingDrawText, 1 do
                        local g = PlayerPedId()
                        local h = GetEntityCoords(g)
                        local i = #(h - f.CoolingDrawText[d])
                        if i < 15 then
                            ESX.Game.Utils.DrawText3D(
                                f.CoolingDrawText[d],
                                Config.Translate[136] .. second .. Config.Translate[137],
                                0.7
                            )
                        end
                    end
                end
            else
                Citizen.Wait(500)
            end
        end
    end
)
funkcija1123423453 = function()
    local a = PlayerPedId()
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 10000,
            label = Config.Translate[138],
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {animDict = "mini@repair", anim = "fixing_a_player"}
        },
        function(b)
            if not b then
                ClearPedTasks(a)
            else
                ClearPedTasks(a)
            end
        end
    )
    Citizen.Wait(10000)
end
funckija089 = function()
    local a = PlayerPedId()
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 10000,
            label = Config.Translate[139],
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {animDict = "mp_fbi_heist", anim = "loop"}
        },
        function(b)
            if not b then
                ClearPedTasks(a)
                TriggerServerEvent("esegovic:dodajGotovProizvod")
            else
                ClearPedTasks(a)
            end
        end
    )
    Citizen.Wait(10000)
end
if Config.EnableAmfetamingBlip then
    Citizen.CreateThread(
        function()
            for e, f in pairs(Config.Amfetamin) do
                for d = 1, #f.DrawText1, 1 do
                    local j = AddBlipForCoord(f.DrawText1[d])
                    SetBlipSprite(j, 514)
                    SetBlipDisplay(j, 4)
                    SetBlipScale(j, 0.8)
                    SetBlipColour(j, 9)
                    SetBlipAsShortRange(j, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentSubstringPlayerName(Config.AmfetaminBlipName)
                    EndTextCommandSetBlipName(j)
                end
            end
        end
    )
end
