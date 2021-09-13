RegisterNetEvent('advanced_vehicles:Notify')
AddEventHandler('advanced_vehicles:Notify', function(type,msg)
    TriggerEvent("Notify",type,msg)
end)