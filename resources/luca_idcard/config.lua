Config = {}

Config.EnableMenu = true
Config.EnableMenuHotkey = true

Config.Command = 'id' -- Only if Config.EnableMenu is on!
Config.Hotkey = 318 -- Only if Config.EnableMenuHotkey is on! (https://docs.fivem.net/docs/game-references/controls/)

-- Licenses

Licenses = {
    {
        Type = 'idcard',
        Needed = false,
        Needed1 = '',
        Needed2 = '',
        Needed3 = '',
        Background = 'url(assets/images/idcard.png)' -- The Background Image from the Card
    },
    {
        Type = 'driver',
        Needed = true,
        Needed1 = 'drive',
        Needed2 = 'drive_bike',
        Needed3 = 'drive_truck',
        Background = 'url(assets/images/license.png)' 
    },
    {
        Type = 'weapon',
        Needed = true,
        Needed1 = 'weapon',
        Needed2 = 'weapon',
        Needed3 = 'weapon',
        Background = 'url(assets/images/firearm.png)'
    },
    {
        Type = 'example', -- The Type of The License
        Needed = false, -- Is it Needed or has it Everyone?
        Needed1 = '', -- The First Needed License (Only if Needed is true)
        Needed2 = '', -- The Second Needed License (Only if Needed is true & when not Required put the Same in as in Needed1)
        Needed3 = '', -- The Second Needed License (Only if Needed is true & when not Required put the Same in as in Needed2 and Needed1)
        Background = 'url(assets/images/idcard.png)' -- The Background Image from the Card (Files Located in files/html/)
    }
}

    -- If you want to edit more than you can edit the Most Things in luca_idcard/files/assets/js/init.js
    -- (Only for Advanced People and not for the Most Server Owners!)
    

-- Only if Config.EnableMenu is Enabled!

Config.CheckElements = {
    {label = 'View ID', value = 'idcard'}, -- This MUST be the Type of the License that is Above /\
    {label = 'View Driving License', value = 'driver'},
    {label = 'View Weapon License', value = 'weapon'}, 
    {label = 'View Example', value = 'example'}
}

Config.ShowElements = {
    {label = 'Show ID', value = 'idcard'}, -- The value MUST be the Type of the License that is Above /\
    {label = 'Show Driving License', value = 'driver'},
    {label = 'Show Weapon License', value = 'weapon'}, 
    {label = 'Show Example', value = 'example'}
}

-- Locales

Config.NoLicense = 'You dont have that Type of License!'
Config.Nearby = 'No Players Nearby!'
Config.MenuTitle = 'ID Menu'
Config.CheckMenuTitle = 'View Your IDs'
Config.ShowMenuTitle = 'Show Your IDs'