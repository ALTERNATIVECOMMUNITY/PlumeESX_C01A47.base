Citizen.CreateThread(function()
    if(Config.UsingESX)then --Only runs if you are using ESX.
        ESX = nil
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

RegisterServerEvent('storeRobberies:server:callCops')
AddEventHandler('storeRobberies:server:callCops', function(store)
    if(Config.UseCopJob)then
        for _, playerId in ipairs(GetPlayers()) do --Runs for all the online players
            if(Config.UsingESX)then --Checks if your using esx.
                for k, jobname in pairs(Config.CopJobs) do --Runs for all the job names set in the config.
                    local Player = ESX.GetPlayerFromId(playerId) --Gets the player with an esx function.
                    if Player.job.name == jobname then --Checks if he is a cop or not.
                            local streetName, CCTV
                            streetName =  Config.Shops[store].name
                            CCTV = ""
                            for k, v in pairs(Config.Shops[store].camera) do
                                CCTV = CCTV .. "[" .. v .. "]"
                            end
                            
                            TriggerClientEvent('chat:addMessage', playerId, {
                                template = '<div class="chat-message-emergency"><b>[Dispatch]:</b> Store Robbery in progress at a {0}. <b>CCTV: {1}</b></div>',
                                args = {streetName, CCTV }
                            })

                        if(Config.PoliceCall)then
                            TriggerClientEvent('storeRobberies:client:alertBlip', playerId, store)
                        end
                    end
                end
            else
                for k, jobname in pairs(Config.CopJobs) do
                    --DO YOUR CHECK HERE. IF IT FINDS THE JOB IT NEEDS TO ADD +1 TO POLICE CHECK. CHECK THE ESX CODE ABOVE.
                end
            end
        end
    end
end)

RegisterServerEvent('storeRobberies:server:canRob')
AddEventHandler('storeRobberies:server:canRob', function(source, store)
    local copsChecker = CheckCops(store)

    if copsChecker then
        if not Config.Shops[store].registerOpened then
            TriggerClientEvent("storeRobberies:client:canRob", source, true, "none")
        else
            if(Config.Shops[store].registerOpened)then
                TriggerClientEvent("storeRobberies:client:canRob", source, false, "robbed")
            else
                TriggerClientEvent("storeRobberies:client:canRob", source, false, "dead")
            end
        end
    else
        TriggerClientEvent("storeRobberies:client:canRob", source, false, "cops")
    end
end)

RegisterServerEvent('storeRobberies:server:registerMoney')
AddEventHandler('storeRobberies:server:registerMoney', function(source, store, password)
    if(password ~= nil)then
        if(password == randomKeyGen)then
            if(Config.UsingESX)then --Checks if your using ESX.
                local xPlayer = ESX.GetPlayerFromId(source) --Gets the player from the server id.
                local randomAmount = math.random(Config.Shops[store].registerMoney[1], Config.Shops[store].registerMoney[2]) --Makes a random number between the low and high of the register.
                xPlayer.addMoney(randomAmount) --Adds the random amount of money to the player.
            else
                print(math.random(Config.Shops[store].registerMoney[1], Config.Shops[store].registerMoney[2]))
                --Give your money here This is for the register. The code for the randomiser is this: math.random(Config.Shops[store].registerMoney[1], Config.Shops[store].registerMoney[2])
            end
        else
            DropPlayer(source, 'Cheating')  
        end
    else
        DropPlayer(source, 'Cheating')  
    end
end)

RegisterServerEvent('storeRobberies:server:safeMoney')
AddEventHandler('storeRobberies:server:safeMoney', function(source, store, password)
    if(password ~= nil)then
        if(password == randomKeyGen)then
            if(Config.UsingESX)then --Checks if your using ESX.
                local xPlayer = ESX.GetPlayerFromId(source) --Gets the player from the server id.
                local randomAmount = math.random(Config.Shops[store].safeMoney[1], Config.Shops[store].safeMoney[2]) --Makes a random number between the low and high of the safe.
                xPlayer.addMoney(randomAmount) --Adds the random amount of money to the player.
            else
                print(math.random(Config.Shops[store].safeMoney[1], Config.Shops[store].safeMoney[2]))
                --Give your money here This is for the safe. The code for the randomiser is this: math.random(Config.Shops[store].safeMoney[1], Config.Shops[store].safeMoney[2])
            end
        else
            DropPlayer(source, 'Cheating')  
        end
    else
        DropPlayer(source, 'Cheating')  
    end
end)

function CheckCops(store) --Checks the current cops online.
    if(Config.UseCopJob)then
        local cops = 0 --Sets current cops to 0 to do the check.
        for _, playerId in ipairs(GetPlayers()) do --Runs for all the online players
            if(Config.UsingESX)then --Checks if your using esx.

                for k, jobname in pairs(Config.CopJobs) do --Runs for all the job names set in the config.
                    local Player = ESX.GetPlayerFromId(playerId) --Gets the player with an esx function.
                    if Player.job.name == jobname then --Checks if he is a cop or not.
                        cops = cops + 1 --Adds +1 if he a is a cop.
                    end
                end

            else
                for k, jobname in pairs(Config.CopJobs) do
                    --DO YOUR CHECK HERE. IF IT FINDS THE JOB IT NEEDS TO ADD +1 TO POLICE CHECK. CHECK THE ESX CODE ABOVE.
                end
            end
        end

        if(cops >= Config.Shops[store].copsNeeded)then --Checks if there are enough cops online.
            return true
        else
            return false
        end
    else
        return true --Returns true if you don't need a cop job. Feel free to do whatever the fuck you want here.
    end
end