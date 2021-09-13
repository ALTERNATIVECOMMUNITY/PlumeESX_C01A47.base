local beds = {
    { x = -462.76, y = -281.53, z = 35.64, h = 21.32, taken = false },
    { x = -466.51, y = -282.88, z = 35.84, h = 21.32, taken = false },
    { x = -469.77, y = -284.4, z = 35.84, h = 21.32, taken = false },
	{ x = -458.97, y = -279.84, z = 35.84, h = 21.32, taken = false },
	{ x = -455.11, y = -287.11, z = 35.84, h = 21.32, taken = false },
	{ x = -448.43, y = -283.67, z = 35.83, h = 198.73, taken = false },
	{ x = -451.68, y = -284.88, z = 35.83, h = 198.73, taken = false },
	{ x = -454.99, y = -286.35, z = 35.83, h = 198.73, taken = false },
	{ x = -460.32, y = -288.67, z = 35.83, h = 198.73, taken = false },
	{ x = -463.79, y = -290.01, z = 35.83, h = 198.73, taken = false },
	{ x = -467.11, y = -291.25, z = 35.84, h = 198.73, taken = false },
}

local bedsTaken = {}
local injuryBasePrice = 100
ESX = nil
local playerInjury = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('mythic_hospital:server:RequestBed')
AddEventHandler('mythic_hospital:server:RequestBed', function()
    for k, v in pairs(beds) do
        if not v.taken then
            v.taken = true
            --TriggerClientEvent('mythic_hospital:client:SendToBed', source, k, v)
            TriggerClientEvent('mythic_hospital:client:RPSendToBed', source, k, v)
            return
        end
    end

    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'No Beds Available' })
end)

RegisterServerEvent('mythic_hospital:server:RPRequestBed')
AddEventHandler('mythic_hospital:server:RPRequestBed', function(plyCoords)
    local foundbed = false
    for k, v in pairs(beds) do
        local distance = #(vector3(v.x, v.y, v.z) - plyCoords)
        if distance < 3.0 then
            if not v.taken then
                v.taken = true
                foundbed = true
                TriggerClientEvent('mythic_hospital:client:RPSendToBed', source, k, v)
                return
            else
                TriggerEvent('mythic_chat:server:System', source, 'That Bed Is Taken')
            end
        end
    end

    if not foundbed then
        TriggerEvent('mythic_chat:server:System', source, 'Not Near A Hospital Bed')
    end
end)

RegisterServerEvent('mythic_hospital:server:EnteredBed')
AddEventHandler('mythic_hospital:server:EnteredBed', function()
    local src = source
    local injuries = GetCharsInjuries(src)--GetCharsInjuries(src)

    local totalBill = 0
    if injuries ~= nil then
        for k, v in pairs(injuries.limbs) do
            if v.isDamaged then
                totalBill = totalBill + (injuryBasePrice * v.severity)
            end
        end
        if injuries.isBleeding > 0 then
            totalBill = totalBill + (injuryBasePrice * injuries.isBleeding)
        end
    end
	-- YOU NEED TO IMPLEMENT YOUR FRAMEWORKS BILLING HERE
	TriggerClientEvent('mythic_hospital:client:FinishServices', src)
end)

RegisterServerEvent('mythic_hospital:server:LeaveBed')
AddEventHandler('mythic_hospital:server:LeaveBed', function(id)
    beds[id].taken = false
end)

RegisterServerEvent('mythic_hospital:server:SyncInjuries')
AddEventHandler('mythic_hospital:server:SyncInjuries', function(data)
    playerInjury[source] = data
end)

function GetCharsInjuries(source)
    return playerInjury[source]
end