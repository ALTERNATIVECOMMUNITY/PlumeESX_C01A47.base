currentRegister = 0
currentSafe = 0

Citizen.CreateThread(function() --Register and safe.
    local x,y,z
    while true do
        inRange = false
        for v = 1, #Config.Shops do --Runs for all the shops.
            if (GetDistanceBetweenCoords(globalPlayerCoords, Config.Shops[v].registerCoords, true) <= 3 and (not Config.Shops[v].shopKeeperState) and Config.Shops[v].canRob) then --Checks if he is close to the register, if the shopkeeper is dead, and if the register is not opened.
                x, y, z = table.unpack(Config.Shops[v].registerCoords) --Unpacks the register coords. I did it this method because calling the values themselves takes like 0.15 ms. Scary stuff lol.
                while (GetDistanceBetweenCoords(globalPlayerCoords, Config.Shops[v].registerCoords, true) <= 2 and not lockpicking and Config.Shops[v].canRob) do --This loops runs while the distance between the player and the register is smaller than 2. Was done for optimization 
                    if(canRob)then
                        if(not Config.Shops[v].registerOpened)then
                            DrawText3D(x, y, z, Languages[Config.Language]['crackRegister']) --The draw 3d text for the register.
                            currentRegister = v --Sets the current register to the store.
                            if IsControlJustPressed(1, Config.LockpickRegisterButton) then --If the control is pressed do the below code.

                                if not copsCalled then
                                    TriggerServerEvent("storeRobberies:server:callCops", currentStore)
                                    TriggerEvent("storeRobberies:client:callCops")
                                    copsCalled = true
                                end

                                TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, false)
                                LockpickAnim() --Does the lockpick animation.
                                lockpick(true) --Callsthe js part of the lockpicking through this function.
                            end
                        else
                            DrawText3D(x, y, z, Languages[Config.Language]['registerOpened']) --The draw 3d text for the safe.
                        end
                    elseif(canRobType == 'cops')then
                        DrawText3D(x, y, z, Languages[Config.Language]['no_cops']) --The draw 3d text for the safe.
                    end
                    Citizen.Wait(7) --A citizen.wait of 7 is the best for 3d text. No blinking and not as heavy as 0.
                end
                inRange = true --Sets the player that he is inrange of the register.
            elseif (GetDistanceBetweenCoords(globalPlayerCoords, Config.Shops[v].safeCoords, true) <= 3 and (not Config.Shops[v].safeOpened) and Config.Shops[v].canRob) then --Checks if the player is close to the safe and the safe is not opened.
                x, y, z = table.unpack(Config.Shops[v].safeCoords) --Unpacks the safebox coords. I did it this method because calling the values themselves takes like 0.15 ms. Scary stuff lol.
                while (GetDistanceBetweenCoords(globalPlayerCoords, Config.Shops[v].safeCoords, true) <= 2 and not safeboxing and Config.Shops[v].canRob) do --This loops runs while the distance between the player and the safebox is smaller than 2. Was done for optimization 
                    if(canRob and not safeboxing)then
                        if(not Config.Shops[v].safeOpened and not safeboxing)then
                                DrawText3D(x, y, z, Languages[Config.Language]['crackSafe']) --The draw 3d text for the safe.
                                
                                if IsControlJustPressed(1, Config.SafeButton) then --If the control is pressed do the below code.

                                    if not copsCalled then
                                        TriggerServerEvent("storeRobberies:server:callCops", currentStore)
                                        TriggerEvent("storeRobberies:client:callCops")
                                        copsCalled = true
                                    end

                                        currentSafe = v --Sets the current safe to the store.
                                        TriggerServerEvent("storeRobberies:server:canRobRunning", currentStore, false)
                                        safeboxing = true
                                            if Config.Shops[v].safeType == "keypad" then
                                                SendNUIMessage({
                                                    action = "openKeypad", 
                                                })
                                                SetNuiFocus(true, true) --Opens the keypad for the safebox. Sets the mouse active also.
                                            else
                                                TriggerEvent("safecracking:loop",5) --Starts the padlock minigame.
                                            end

                                            if(not(not Config.Shops[v].shopKeeperState or Config.Shops[v].registerOpened))then
                                                fightBack_function(currentStore, true)
                                            end
                                    
                                end
                        else
                            DrawText3D(x, y, z, Languages[Config.Language]['safeOpened']) --The draw 3d text for the safe.
                        end
                    elseif(canRobType == 'cops')then
                        DrawText3D(x, y, z, Languages[Config.Language]['no_cops']) --The draw 3d text for the safe.
                    end
                    Citizen.Wait(7) --A citizen.wait of 7 is the best for 3d text. No blinking and not as heavy as 0.
                end
                inRange = true --Sets the player that he is inrange of the safebox.
            end
        end

        if(lockpicking)then --We use this lockpicking value so we don't let peeps crack the register for a second time and get double the money.
            Citizen.Wait(500)
        end

        if(not inRange)then --We use this inRange value so we can optimize the script. If the player is not within range of any of the registers or safes it sleeps this loop for 1 second.
            Citizen.Wait(1000)
            currentRegister = 0
            currentSafe = 0
        else
            Citizen.Wait(100)
        end
    end
end)


Citizen.CreateThread(function()
    if(Config.UseBlips)then
        local StoreBlip = {}
        for v = 1, #Config.Shops do
            --SetBlipCoords(StoreBlip[v], Config.Shops[v].blip)

            StoreBlip[v] = AddBlipForCoord(Config.Shops[v].blip)

            SetBlipSprite(StoreBlip[v], 52)
            SetBlipScale(StoreBlip[v], 0.6)
            SetBlipColour(StoreBlip[v], 2)  

            SetBlipDisplay(StoreBlip[v], 4)
            SetBlipAsShortRange(StoreBlip[v], true)
        

            BeginTextCommandSetBlipName("STRING")
            --AddTextComponentSubstringPlayerName(Config.Shops[v].name)
            AddTextComponentSubstringPlayerName("Store")
            EndTextCommandSetBlipName(StoreBlip[v])
        end
        for v = 1, #Config.WeaponShops do
            --SetBlipCoords(StoreBlip[v], Config.Shops[v].blip)

            StoreBlip[v] = AddBlipForCoord(Config.WeaponShops[v].blip)

            SetBlipSprite(StoreBlip[v], 110)
            SetBlipScale(StoreBlip[v], 0.6)
            SetBlipColour(StoreBlip[v], 2)  

            SetBlipDisplay(StoreBlip[v], 4)
            SetBlipAsShortRange(StoreBlip[v], true)
        

            BeginTextCommandSetBlipName("STRING")
            --AddTextComponentSubstringPlayerName(Config.Shops[v].name)
            AddTextComponentSubstringPlayerName(Config.WeaponShops[v].name)
            EndTextCommandSetBlipName(StoreBlip[v])
        end
    end
end)

RegisterNetEvent('storeRobberies:client:alertBlip')
AddEventHandler('storeRobberies:client:alertBlip', function(store)
        local transG = Config.PoliceCallTimer * 2
        local blip = AddBlipForCoord(Config.Shops[store].blip)
        SetBlipSprite(blip, 487)
        SetBlipColour(blip, 43)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.2)
        SetBlipFlashes(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.Shops[store].name .. " - Robbery")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(500)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
end)