RegisterServerEvent("TropixRP:Bank:RemoveAccess")
AddEventHandler("TropixRP:Bank:RemoveAccess", function(target, name)
    local source = source

    if (not target) then
        TriggerClientEvent("TropixRP:Bank:Notify", source, "error", "No target!")
        return
    end

    if (type(target) ~= "string") then
        TriggerClientEvent("TropixRP:Bank:Notify", source, "error", "Invalid target!")
        return
    end

    local ply = ESX.GetPlayerFromId(source)
    local plyID = ply.getIdentifier()

    MySQL.Async.fetchAll("SELECT * FROM `banking_access` WHERE `owner_identifier` = @myID AND `target_identifier` = @targID", 
    {
        ["@myID"] = plyID,
        ["@targID"] = target
    }, function(data)
        if (data and #data >= 1) then
            local validPly = ESX.GetPlayerFromIdentifier(target)
    
            MySQL.Async.execute("DELETE FROM `banking_access` WHERE `owner_identifier` = @myID AND `target_identifier` = @targID",
            {
                ["@myID"] = plyID,
                ["@targID"] = target
            }, function(c)
                if (c and c >= 1) then
                    --validPly and validPly ~= nil
                    TriggerClientEvent("TropixRP:Bank:ExtNotify", source, "You have removed ".. name .." from your bank account!")
        
                    if (validPly ~= nil) then
                        local tID = validPly.playerId
                        TriggerClientEvent("TropixRP:Bank:ExtNotify", tID, ply.getName().." has removed you from their bank account!")
                        TriggerClientEvent("TropixRP:Bank:RefreshAccounts", tID)
                    end
        
                end
            end)
        else
            TriggerClientEvent("TropixRP:Bank:Notify", source, "error", "That target doesn't have access to your bank!")
            return
        end
    end)
end)

local function GiveAccountAccess(source, target)
    local source = source

    if (not target or target <= 0 or target == source) then
        TriggerClientEvent("TropixRP:Bank:Notify", source, "error", "Target `"..target.."` not found!")
        return
    end

    local targetPly = ESX.GetPlayerFromId(target)
    local ply = ESX.GetPlayerFromId(source)

    if (not targetPly or targetPly == ply) then
        TriggerClientEvent("TropixRP:Bank:Notify", source, "error", "Target `"..target.."` not found!")
        return
    end

    local plyID = ply.getIdentifier()
    local plyName = ply.getName()

    local targetID = targetPly.getIdentifier()
    local targetName = targetPly.getName()
    
    MySQL.Async.fetchAll("SELECT * FROM `banking_access` WHERE `owner_identifier` = @myID AND `target_identifier` = @targID", 
    {
        ["@myID"] = plyID,
        ["@targID"] = targetID
    }, function(data)
        if (data and #data >= 1) then
            TriggerClientEvent("TropixRP:Bank:ExtNotify", source, targetName.." already has access to your bank account!")
            return
        else
            MySQL.Async.execute("INSERT INTO `banking_access` (`owner_identifier`, `target_identifier`, `owner_name`, `target_name`) VALUES(@owner_id, @target_id, @owner_name, @target_name)",
            {
                ["@owner_id"] = plyID,
                ["@target_id"] = targetID,
                ["@owner_name"] = plyName,
                ["@target_name"] = targetName
            }, function(rc)
                if (rc and rc >= 1) then
                    TriggerClientEvent("TropixRP:Bank:ExtNotify", source, "You have given "..targetName.." access to your bank account!")
                    TriggerClientEvent("TropixRP:Bank:ExtNotify", target, plyName.." has given you access to their bank account!")
                    TriggerEvent("TropixRP:AddToMoneyLog", source, "personal", 0, "grant", targetName, "Gave account access to "..targetName)
                    TriggerEvent("TropixRP:AddToMoneyLog", target, "friend", 0, "grant", plyName, "Given access to "..plyName.."'s account")
                end
            end)
        end
    end)
end

RegisterCommand("sharebank", function(source, args)
    local source = source

    if (not args or not args[1]) then
        TriggerClientEvent("TropixRP:Bank:ExtNotify", source, "Invalid target!")
        return
    end

    local ply = ESX.GetPlayerFromId(source)
    local target = tonumber(args[1])
    local targPly = ESX.GetPlayerFromId(tonumber(args[1]))

    if (not targPly or targPly == ply) then
        TriggerClientEvent("TropixRP:Bank:ExtNotify", source, "Invalid target!")
        return
    end

    return GiveAccountAccess(source, target)
end, false)