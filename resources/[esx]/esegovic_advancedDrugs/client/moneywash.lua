WashFuckingMoney = function(a)
    if Config.NeedIDCardToWashMoney then
        ESX.TriggerServerCallback(
            "esegovic:checkIDCard",
            function(b)
                if b == true then
                    ESX.UI.Menu.Open(
                        "dialog",
                        GetCurrentResourceName(),
                        "moneywash_CANCER",
                        {title = Config.Translate[152]},
                        function(c, d)
                            d.close()
                            a = tonumber(c.value)
                            if a == 0 or a == nil then
                                return
                            end
                            TriggerServerEvent("esegovic:canWashMoney", a)
                        end,
                        function(c, d)
                            d.close()
                        end
                    )
                else
                    ESX.ShowNotification(Config.Translate[159])
                end
            end
        )
    else
        ESX.UI.Menu.Open(
            "dialog",
            GetCurrentResourceName(),
            "moneywash_CANCER",
            {title = Config.Translate[152]},
            function(c, d)
                d.close()
                a = tonumber(c.value)
                if a == 0 or a == nil then
                    return
                end
                TriggerServerEvent("esegovic:canWashMoney", a)
            end,
            function(c, d)
                d.close()
            end
        )
    end
end
RegisterNetEvent("esegovic:MoneyWashFunc")
AddEventHandler(
    "esegovic:MoneyWashFunc",
    function(a)
        exports[Config.FolderNameMythicProgbar]:Progress(
            {
                name = "unique_action_name",
                duration = 25000,
                label = Config.Translate[157],
                useWhileDead = true,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = true,
                    disableCombat = true
                }
            },
            function(e)
                if not e then
                    ClearPedTasks(PlayerPedId())
                else
                    ClearPedTasks(PlayerPedId())
                end
            end
        )
        Citizen.Wait(25000)
        TriggerServerEvent("esegovic:washMoney", a)
        local f = vector3(5.36, 42.08, 71.52)
        local g = math.random(0, 100)
        if g > 27 then
            TriggerServerEvent("esegovic:notifiPolice", f)
        end
    end
)
if Config.EnableMoneyWashBlip then
    Citizen.CreateThread(
        function()
            for h, i in pairs(Config.MoneyWash) do
                for j = 1, #i.WashMoney, 1 do
                    local k = AddBlipForCoord(i.WashMoney[j])
                    SetBlipSprite(k, 483)
                    SetBlipDisplay(k, 4)
                    SetBlipScale(k, 0.8)
                    SetBlipColour(k, 17)
                    SetBlipAsShortRange(k, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentSubstringPlayerName(Config.WashMoneyBlipName)
                    EndTextCommandSetBlipName(k)
                end
            end
        end
    )
end
