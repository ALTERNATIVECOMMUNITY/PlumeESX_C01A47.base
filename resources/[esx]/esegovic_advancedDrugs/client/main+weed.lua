ESX = nil
Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                Config.ESXLibrary,
                function(a)
                    ESX = a
                end
            )
            Citizen.Wait(0)
        end
    end
)
local b = false
local c = false
local d = false
local e = false
osusenaIndica = osusenaIndica or 0
osusenaSativa = osusenaSativa or 0
osusenaPurple = osusenaPurple or 0
rawCocaine = rawCocaine or 0
mixedCocaine = mixedCocaine or 0
meth = meth or 0
meth2 = meth2 or 0
meth3 = meth3 or 0
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            local f = PlayerPedId()
            local g = GetEntityCoords(f)
            local h = true
            for i, j in pairs(Config.Teleports) do
                for k = 1, #j.TeleportForWeedIN, 1 do
                    local l = #(g - j.TeleportForWeedIN[k])
                    if l < 15 then
                        ESX.Game.Utils.DrawText3D(j.TeleportForWeedIN[k], Config.Translate[2], 0.6)
                        h = false
                        if l < 1 then
                            if IsControlJustReleased(0, 38) then
                                DoScreenFadeOut(100)
                                Citizen.Wait(750)
                                ESX.Game.Teleport(f, j.TeleportForWeedOUT[k])
                                DoScreenFadeIn(100)
                            end
                        end
                    end
                end
                for k = 1, #j.TeleportForWeedOUT, 1 do
                    local l = #(g - j.TeleportForWeedOUT[k])
                    if l < 15 then
                        ESX.Game.Utils.DrawText3D(j.TeleportForWeedOUT[k], Config.Translate[1], 0.6)
                        h = false
                        if l < 1 then
                            if IsControlJustReleased(0, 38) then
                                DoScreenFadeOut(100)
                                Citizen.Wait(750)
                                ESX.Game.Teleport(f, j.TeleportForWeedIN[k])
                                DoScreenFadeIn(100)
                            end
                        end
                    end
                end
                for k = 1, #j.TeleportForCokeIN, 1 do
                    local l = #(g - j.TeleportForCokeIN[k])
                    if l < 15 then
                        ESX.Game.Utils.DrawText3D(j.TeleportForCokeIN[k], Config.Translate[2], 0.6)
                        h = false
                        if l < 1 then
                            if IsControlJustReleased(0, 38) then
                                DoScreenFadeOut(100)
                                Citizen.Wait(750)
                                ESX.Game.Teleport(f, j.TeleportForCokeOUT[k])
                                DoScreenFadeIn(100)
                            end
                        end
                    end
                end
                for k = 1, #j.TeleportForCokeOUT, 1 do
                    local l = #(g - j.TeleportForCokeOUT[k])
                    if l < 15 then
                        ESX.Game.Utils.DrawText3D(j.TeleportForCokeOUT[k], Config.Translate[1], 0.6)
                        h = false
                        if l < 1 then
                            if IsControlJustReleased(0, 38) then
                                DoScreenFadeOut(100)
                                Citizen.Wait(750)
                                ESX.Game.Teleport(f, j.TeleportForCokeIN[k])
                                DoScreenFadeIn(100)
                            end
                        end
                    end
                end
            end
            for i, j in pairs(Config.Weed) do
                for k = 1, #j.WeedGatheringIndica, 1 do
                    local l = #(g - j.WeedGatheringIndica[k])
                    if l < 3 then
                        local m, n, o = table.unpack(j.WeedGatheringIndica[k])
                        local p = vector3(m, n, o - 0.1)
                        local q = vector3(m, n, o - 0.2)
                        local r = vector3(m, n, o - 0.3)
                        ESX.Game.Utils.DrawText3D(p, Config.Translate[3], 0.3)
                        ESX.Game.Utils.DrawText3D(q, Config.Translate[4], 0.3)
                        ESX.Game.Utils.DrawText3D(r, Config.Translate[9], 0.4)
                        h = false
                        if l < 1 then
                            if IsControlJustReleased(0, 38) then
                                PickupIndica()
                            end
                        end
                    end
                end
                for k = 1, #j.WeedGatheringSativa, 1 do
                    local l = #(g - j.WeedGatheringSativa[k])
                    if l < 3 then
                        local m, n, o = table.unpack(j.WeedGatheringSativa[k])
                        local p = vector3(m, n, o - 0.1)
                        local q = vector3(m, n, o - 0.2)
                        local r = vector3(m, n, o - 0.3)
                        ESX.Game.Utils.DrawText3D(p, Config.Translate[6], 0.3)
                        ESX.Game.Utils.DrawText3D(q, Config.Translate[5], 0.3)
                        ESX.Game.Utils.DrawText3D(r, Config.Translate[9], 0.4)
                        h = false
                        if l < 1 then
                            if IsControlJustReleased(0, 38) then
                                PickupSativa()
                            end
                        end
                    end
                end
                for k = 1, #j.WeedGatheringPurpleHaze, 1 do
                    local l = #(g - j.WeedGatheringPurpleHaze[k])
                    if l < 3 then
                        local m, n, o = table.unpack(j.WeedGatheringPurpleHaze[k])
                        local p = vector3(m, n, o - 0.1)
                        local q = vector3(m, n, o - 0.2)
                        local r = vector3(m, n, o - 0.3)
                        ESX.Game.Utils.DrawText3D(p, Config.Translate[7], 0.3)
                        ESX.Game.Utils.DrawText3D(q, Config.Translate[8], 0.3)
                        ESX.Game.Utils.DrawText3D(r, Config.Translate[9], 0.4)
                        h = false
                        if l < 1 then
                            if IsControlJustReleased(0, 38) then
                                PickupPurpleHaze()
                            end
                        end
                    end
                end
                for k = 1, #j.WeedProcessing, 1 do
                    local l = #(g - j.WeedProcessing[k])
                    if l < 3 then
                        local m, n, o = table.unpack(j.WeedProcessing[k])
                        local p = vector3(m, n, o)
                        local q = vector3(m, n, o - 0.2)
                        local r = vector3(m, n, o - 0.3)
                        ESX.Game.Utils.DrawText3D(p, Config.Translate[55], 0.3)
                        h = false
                        if l < 1 then
                            if IsControlJustReleased(0, 38) and not b then
                                Esegovicmenu()
                            end
                        end
                    end
                end
                for k = 1, #j.WeedPacking, 1 do
                    local l = #(g - j.WeedPacking[k])
                    if l < 10 then
                        local m, n, o = table.unpack(j.WeedPacking[k])
                        local p = vector3(m, n, o)
                        local q = vector3(m, n, o + 0.1)
                        local r = vector3(m, n, o + 0.2)
                        local s = vector3(m, n, o + 0.3)
                        ESX.Game.Utils.DrawText3D(p, Config.Translate[64], 0.3)
                        ESX.Game.Utils.DrawText3D(
                            q,
                            Config.Translate[65] .. osusenaIndica .. Config.Translate[888],
                            0.3
                        )
                        ESX.Game.Utils.DrawText3D(
                            r,
                            Config.Translate[75] .. osusenaSativa .. Config.Translate[888],
                            0.3
                        )
                        ESX.Game.Utils.DrawText3D(
                            s,
                            Config.Translate[76] .. osusenaPurple .. Config.Translate[888],
                            0.3
                        )
                        h = false
                        if l < 1 and not c then
                            if IsControlJustReleased(0, 38) then
                                PackWeed()
                            end
                        end
                    end
                end
            end
            for i, j in pairs(Config.Coke) do
                for k = 1, #j.RawCoke, 1 do
                    local l = #(g - j.RawCoke[k])
                    if l < 10 then
                        local m, n, o = table.unpack(j.RawCoke[k])
                        local p = vector3(m, n, o + 0.3)
                        ESX.Game.Utils.DrawText3D(j.RawCoke[k], Config.Translate[599], 0.4)
                        ESX.Game.Utils.DrawText3D(p, Config.Translate[600] .. rawCocaine .. "g", 0.4)
                        h = false
                        if l < 1 then
                            if IsControlJustReleased(0, 38) then
                                RawCoke()
                                local t = 1
                                local u = 2
                                rawCocaine = rawCocaine + math.random(t, u)
                            end
                        end
                    end
                end
                for k = 1, #j.MixingCoke, 1 do
                    local l = #(g - j.MixingCoke[k])
                    if l < 10 then
                        local m, n, o = table.unpack(j.MixingCoke[k])
                        local v = vector3(m, n, o + 0.6)
                        ESX.Game.Utils.DrawText3D(j.MixingCoke[k], Config.Translate[605], 0.4)
                        ESX.Game.Utils.DrawText3D(v, Config.Translate[604] .. mixedCocaine .. "g", 0.4)
                        h = false
                        if l < 1 then
                            if IsControlJustReleased(0, 38) and not d then
                                if rawCocaine >= 1 then
                                    ESX.TriggerServerCallback(
                                        "esegovic:checkMixItem",
                                        function(w)
                                            if w == true then
                                                d = true
                                                MixCocaine()
                                                mixedCocaine = mixedCocaine + 2
                                                rawCocaine = rawCocaine - 1
                                                d = false
                                            else
                                                ESX.ShowNotification(Config.Translate[606])
                                            end
                                        end
                                    )
                                else
                                    ESX.ShowNotification(Config.Translate[603])
                                end
                            end
                        end
                    end
                end
                for k = 1, #j.PackingCoke, 1 do
                    local l = #(g - j.PackingCoke[k])
                    if l < 10 then
                        local m, n, o = table.unpack(j.PackingCoke[k])
                        local x = vector3(m, n, o + 0.6)
                        ESX.Game.Utils.DrawText3D(x, Config.Translate[610] .. mixedCocaine .. "g", 0.4)
                        ESX.Game.Utils.DrawText3D(j.PackingCoke[k], Config.Translate[607], 0.4)
                        h = false
                        if l < 1 then
                            if IsControlJustReleased(0, 38) and not e then
                                if mixedCocaine >= 10 then
                                    e = true
                                    PackCocaine()
                                    mixedCocaine = mixedCocaine - 10
                                    TriggerServerEvent("esegovic:dodajCocaine")
                                    e = false
                                else
                                    ESX.ShowNotification(Config.Translate[608])
                                end
                            end
                        end
                    end
                end
            end
            for i, j in pairs(Config.Amfetamin) do
                for k = 1, #j.DrawText1, 1 do
                    local l = #(g - j.DrawText1[k])
                    if l < 7 then
                        ESX.Game.Utils.DrawText3D(
                            j.DrawText1[k],
                            Config.Translate[120] .. meth .. Config.Translate[121],
                            0.5
                        )
                        h = false
                    end
                end
                for k = 1, #j.DrawText2, 1 do
                    local l = #(g - j.DrawText2[k])
                    if l < 7 then
                        ESX.Game.Utils.DrawText3D(
                            j.DrawText2[k],
                            Config.Translate[122] .. meth2 .. Config.Translate[121],
                            0.5
                        )
                        h = false
                    end
                end
                for k = 1, #j.DrawText3, 1 do
                    local l = #(g - j.DrawText3[k])
                    if l < 7 then
                        ESX.Game.Utils.DrawText3D(
                            j.DrawText3[k],
                            Config.Translate[123] .. meth2 .. Config.Translate[121],
                            0.5
                        )
                        h = false
                    end
                end
                for k = 1, #j.DrawText4, 1 do
                    local l = #(g - j.DrawText4[k])
                    if l < 7 then
                        ESX.Game.Utils.DrawText3D(
                            j.DrawText4[k],
                            Config.Translate[124] .. meth3 .. Config.Translate[121],
                            0.5
                        )
                        h = false
                    end
                end
                for k = 1, #j.Meth1st, 1 do
                    local l = #(g - j.Meth1st[k])
                    if l < 7 then
                        ESX.Game.Utils.DrawText3D(j.Meth1st[k], Config.Translate[125], 0.7)
                        h = false
                        if l < 1.5 then
                            if IsControlJustReleased(0, 38) then
                                Fluid1stFunction()
                                meth = meth + 0.25
                            end
                        end
                    end
                end
                for k = 1, #j.Meth2nd, 1 do
                    local l = #(g - j.Meth2nd[k])
                    if l < 7 then
                        ESX.Game.Utils.DrawText3D(j.Meth2nd[k], Config.Translate[126], 0.7)
                        h = false
                        if l < 1.5 then
                            if IsControlJustReleased(0, 38) then
                                if meth >= 5 then
                                    funkcija1123453()
                                    meth2 = meth2 + 5
                                    meth = meth - 5
                                else
                                    ESX.ShowNotification(Config.Translate[129])
                                end
                            end
                        end
                    end
                end
                for k = 1, #j.Meth3rd, 1 do
                    local l = #(g - j.Meth3rd[k])
                    if l < 7 then
                        ESX.Game.Utils.DrawText3D(j.Meth3rd[k], Config.Translate[127], 0.7)
                        h = false
                        if l < 1.5 then
                            if IsControlJustReleased(0, 38) then
                                if meth2 >= 5 then
                                    funkcija1123423453()
                                    meth2 = meth2 - 5
                                    meth3 = meth3 + 10
                                    ESX.ShowNotification(Config.Translate[141])
                                else
                                    ESX.ShowNotification(Config.Translate[130])
                                end
                            end
                        end
                    end
                end
                for k = 1, #j.Meth4th, 1 do
                    local l = #(g - j.Meth4th[k])
                    if l < 7 then
                        ESX.Game.Utils.DrawText3D(j.Meth4th[k], Config.Translate[128], 0.4)
                        h = false
                        if l < 1.5 then
                            if IsControlJustReleased(0, 38) then
                                if meth3 >= 10 then
                                    funckija089()
                                    meth3 = meth3 - 10
                                    local y = vector3(434.28, -1179.0, 29.66)
                                    local z = math.random(0, 100)
                                    if z > 27 then
                                        TriggerServerEvent("esegovic:notifiPolice", y)
                                    end
                                else
                                    ESX.ShowNotification(Config.Translate[131])
                                end
                            end
                        end
                    end
                end
            end
            for i, j in pairs(Config.MoneyWash) do
                for k = 1, #j.WashMoney, 1 do
                    local l = #(g - j.WashMoney[k])
                    if l < 7 then
                        ESX.Game.Utils.DrawText3D(j.WashMoney[k], Config.Translate[151], 0.5)
                        h = false
                        if l < 1.5 then
                            if IsControlJustReleased(0, 38) then
                                WashFuckingMoney()
                            end
                        end
                    end
                end
            end
            for i, j in pairs(Config.Sell) do
                for k = 1, #j.SellPoint, 1 do
                    local l = #(g - j.SellPoint[k])
                    if l < 10 then
                        ESX.Game.Utils.DrawText3D(j.SellPoint[k], Config.Translate[160], 0.4)
                        h = false
                        if l < 1 then
                            if IsControlJustReleased(0, 38) then
                                SellItems()
                            end
                        end
                    end
                end
            end
            if h then
                Citizen.Wait(1000)
            end
        end
    end
)
PickupIndica = function()
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 7500,
            label = Config.Translate[442],
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
                anim = "weed_inspecting_high_base_inspector",
                flags = 49
            }
        },
        function(A)
            if not A then
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("esegovic:dodajIndicu")
            else
                ClearPedTasks(PlayerPedId())
            end
        end
    )
    Citizen.Wait(7700)
end
PickupSativa = function()
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 7500,
            label = Config.Translate[443],
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
                anim = "weed_inspecting_high_base_inspector",
                flags = 49
            }
        },
        function(A)
            if not A then
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("esegovic:dodajSativa")
            else
                ClearPedTasks(PlayerPedId())
            end
        end
    )
    Citizen.Wait(7700)
end
PickupPurpleHaze = function()
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 7500,
            label = Config.Translate[444],
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
                anim = "weed_inspecting_high_base_inspector",
                flags = 49
            }
        },
        function(A)
            if not A then
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("esegovic:dodajPurple")
            else
                ClearPedTasks(PlayerPedId())
            end
        end
    )
    Citizen.Wait(7700)
end
DryWeed = function(B)
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 3500,
            label = "PLANT >>> DRYING. . .",
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {animDict = "amb@prop_human_movie_bulb@base", anim = "base"},
            prop = {
                model = "prop_weed_02",
                bone = 6286,
                coords = {x = 0.0, y = 0.0, z = 0.0},
                rotation = {x = 0.0, y = 0.0, z = 0.0}
            }
        },
        function(A)
            if not A then
                ClearPedTasks(PlayerPedId())
            else
                ClearPedTasks(PlayerPedId())
            end
        end
    )
    Citizen.Wait(3700)
    esegaSupak(B)
end
local C = 0
esegaSupak = function(B)
    b = true
    C = 60
    for k = 1, 60 do
        Citizen.Wait(1000)
        C = C - 1
    end
    b = false
    ESX.ShowNotification(Config.Translate[432])
end
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if b then
                for i, j in pairs(Config.Weed) do
                    for k = 1, #j.WeedProcessing, 1 do
                        local m, n, o = table.unpack(j.WeedProcessing[k])
                        local p = vector3(m, n, o)
                        local q = vector3(m, n, o - 0.2)
                        ESX.Game.Utils.DrawText3D(q, Config.Translate[56] .. C .. " ~w~sec", 0.5)
                    end
                end
            else
                Citizen.Wait(500)
            end
        end
    end
)
Esegovicmenu = function()
    local z = math.random(0, 100)
    local y = vector3(-428.64, -1728.36, 19.8)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        "default",
        GetCurrentResourceName(),
        "drying",
        {
            css = "meni",
            title = Config.Translate[66],
            align = "bottom-right",
            elements = {
                {label = "| Indica |", value = "indika"},
                {label = "| Sativa |", value = "sativa"},
                {label = "| Purple Haze |", value = "supak"}
            }
        },
        function(D, E)
            if D.current.value == "indika" then
                if z > 27 then
                    TriggerServerEvent("esegovic:notifiPolice", y)
                end
                ESX.TriggerServerCallback(
                    "esegovic:checkPlant",
                    function(w)
                        if w == true then
                            b = true
                            E.close()
                            DryWeed()
                            osusenaIndica = osusenaIndica + 1
                        else
                            ESX.ShowNotification(Config.Translate[111])
                        end
                    end
                )
            end
            if D.current.value == "sativa" then
                if z > 27 then
                    TriggerServerEvent("esegovic:notifiPolice")
                end
                ESX.TriggerServerCallback(
                    "esegovic:checkPlant2",
                    function(w)
                        if w == true then
                            b = true
                            E.close()
                            DryWeed()
                            osusenaSativa = osusenaSativa + 1
                        else
                            ESX.ShowNotification(Config.Translate[112])
                        end
                    end
                )
            end
            if D.current.value == "supak" then
                if z > 27 then
                    TriggerServerEvent("esegovic:notifiPolice")
                end
                ESX.TriggerServerCallback(
                    "esegovic:checkPlant3",
                    function(w)
                        if w == true then
                            b = true
                            E.close()
                            DryWeed()
                            osusenaPurple = osusenaPurple + 1
                        else
                            ESX.ShowNotification(Config.Translate[113])
                        end
                    end
                )
            end
        end,
        function(D, E)
            E.close()
        end
    )
end
PackWeed = function()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        "default",
        GetCurrentResourceName(),
        "packing",
        {
            css = "meni",
            title = Config.Translate[433],
            align = "bottom-right",
            elements = {
                {label = "| Pack Indica |", value = "pack_indica"},
                {label = "| Pack Sativa |", value = "pack_sativa"},
                {label = "| Pack Purple Haze |", value = "pack_purple"}
            }
        },
        function(D, E)
            if D.current.value == "pack_indica" then
                if osusenaIndica >= 1 then
                    c = true
                    E.close()
                    PackIndica()
                    osusenaIndica = osusenaIndica - 1
                else
                    ESX.ShowNotification(Config.Translate[333])
                end
            end
            if D.current.value == "pack_sativa" then
                if osusenaSativa >= 1 then
                    c = true
                    E.close()
                    PackSativa()
                    osusenaSativa = osusenaSativa - 1
                else
                    ESX.ShowNotification(Config.Translate[333])
                end
            end
            if D.current.value == "pack_purple" then
                if osusenaPurple >= 1 then
                    c = true
                    E.close()
                    PackPurple()
                    osusenaPurple = osusenaPurple - 1
                else
                    ESX.ShowNotification(Config.Translate[333])
                end
            end
        end,
        function(D, E)
            E.close()
        end
    )
end
PackIndica = function()
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 9500,
            label = Config.Translate[385],
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
                anim = "weed_inspecting_high_base_inspector",
                flags = 49
            }
        },
        function(A)
            if not A then
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("esegovic:packIndica")
            else
                ClearPedTasks(PlayerPedId())
            end
        end
    )
    Citizen.Wait(9700)
    c = false
end
PackSativa = function()
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 9500,
            label = Config.Translate[388],
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
                anim = "weed_inspecting_high_base_inspector",
                flags = 49
            }
        },
        function(A)
            if not A then
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("esegovic:packSativa")
            else
                ClearPedTasks(PlayerPedId())
            end
        end
    )
    Citizen.Wait(9700)
    c = false
end
PackPurple = function()
    exports[Config.FolderNameMythicProgbar]:Progress(
        {
            name = "unique_action_name",
            duration = 9500,
            label = Config.Translate[387],
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
                anim = "weed_inspecting_high_base_inspector",
                flags = 49
            }
        },
        function(A)
            if not A then
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("esegovic:packPurple")
            else
                ClearPedTasks(PlayerPedId())
            end
        end
    )
    Citizen.Wait(9700)
    c = false
end
RegisterNetEvent("esegovic:policenotify")
AddEventHandler(
    "esegovic:policenotify",
    function(y)
        if Config.EnablePoliceNotify then
            local F = ESX.GetPlayerData()
            if F.job.name == "police" then
                local G = y
                ESX.ShowAdvancedNotification(
                    Config.Translate[355],
                    Config.Translate[358],
                    Config.Translate[357],
                    "CHAR_HUMANDEFAULT",
                    1
                )
                if not DoesBlipExist(esegovicBlip) then
                    esegovicBlip = AddBlipForCoord(G)
                    SetBlipSprite(esegovicBlip, Config.PoliceNotifyBlipSpirit)
                    SetBlipScale(esegovicBlip, Config.PoliceNotifyBlipScale)
                    SetBlipColour(esegovicBlip, Config.PoliceNotifyBlipColor)
                    PulseBlip(esegovicBlip)
                end
            end
        end
    end
)
if Config.EnableWeedBlip then
    Citizen.CreateThread(
        function()
            for i, j in pairs(Config.Teleports) do
                for k = 1, #j.TeleportForWeedIN, 1 do
                    local H = AddBlipForCoord(j.TeleportForWeedIN[k])
                    SetBlipSprite(H, 496)
                    SetBlipDisplay(H, 4)
                    SetBlipScale(H, 0.8)
                    SetBlipColour(H, 11)
                    SetBlipAsShortRange(H, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentSubstringPlayerName(Config.WeedBlipName)
                    EndTextCommandSetBlipName(H)
                end
            end
        end
    )
end
