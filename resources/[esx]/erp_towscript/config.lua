Config = {}

Config.Locale = 'en' -- Change to your preferred Language (de, en, nl, tr)
Config.JobRestriction = false -- Should the Tow Command & Event be restricted to Players with a specific Job?  true = restricted   | false = not restricted
Config.NeededJob = 'towing' -- Which Jobs should be allowed to Tow a Vehicle via Command/Event  !! ONLY WORKS WHEN "JobRestriction = true" !!
Config.EnableCommand = true -- Enable or disable Towing a Vehicle via command  true = enabled  | false = disabled
Config.VehicleRange = 10.0 -- Which range should be checked for checking for towable vehicles when trying to tow one
Config.OnlyStoppedEngines = true -- Should the engine of the vehicle you want to tow be running or not when trying to tow it.  true = Only allow stopped Vehicles | false = Allow started & stopped engines
Config.FlatbedDistance = -11.0 -- The Distance, a Vehicle should be teleported behind your Flatbed, when unloading it !! DONT MAKE IT TO LOW OR IT WILL BE STUCK IN YOUR FLATBED !!  !! NEEDS TO BE A NEGATIVE NUMBER !! 

Config.Flatbeds= { -- The Vehicle (spawn-names) of your Flatbed-Vehicles / cars which can load other Vehicles on them.  X, Y, Z - Where should the Vehicle be attached to the Tow-Truck? x = left/right, y = forwards/backwards, z = up/down
    ['flatbed'] = {x = 0.0, y = -1.5, z = 0.92}, -- default GTA V flatbed
    ['flatbedm2'] = {x = 0.0, y = -1.5, z = 0.92} 
}

Config.TowBlacklist = { -- Which Vehicles (spawn-names) are not allowed to be towed 
    'mule'
}
