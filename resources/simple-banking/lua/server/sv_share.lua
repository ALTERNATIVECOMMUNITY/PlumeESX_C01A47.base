RegisterServerEvent('TropixRP:Bank:AddFriend')
AddEventHandler('TropixRP:Bank:AddFriend', function(target)
    local source = source
    
    if (not target or target == source) then
        return
    end

    local ply = ESX.GetPlayerFromId(source)
    local plyId = ply.getIdentifier()
    local plyName = ply.getName()
    local sHexID = PlayerIdentifier('steam', source)
    local sSteamID = HexIdToSteamId(sHexID)
    
    local targetPly = ESX.GetPlayerFromId(target)

    if (not targetPly or targetPly == -1) then
        return
    end

    local targetHexID = PlayerIdentifier('steam', target)
    local targetSteamID = HexIdToSteamId(targetHexID)
    local targetName = target.getName()
    

    MySQL.Async.execute("INSERT INTO `account_access` (`identifier`, `steamid`, `owner_name`, `name`, `account_name`) VALUES(@id, @steamid, @own_name, @name, @acc_name)", {
        ["@id"] = plyId,
        ["@steamid"] = targetSteamID,
        ["@own_name"] = plyName,
        ["@name"] = targetName,
        ["@acc_name"] = sSteamID
    })
end)

RegisterServerEvent("TropixRP:Bank:RemoveFriend")
AddEventHandler("TropixRP:Bank:RemoveFriend", function(targetSteamID)
    local source = source
    local sHexID = PlayerIdentifier('steam', source)
    local sSteamID = HexIdToSteamId(sHexID)

    if (not targetSteamID or targetSteamID == "") then
        return
    end

    MySQL.Async.execute("DELETE FROM `account_access` WHERE `steamid` = @steamid AND `account_name` = @acc_name",
    {
        ["@steamid"] = targetSteamID,
        ["@acc_name"] = sSteamID
    })
end)