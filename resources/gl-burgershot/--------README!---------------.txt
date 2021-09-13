--------README!---------------

Hello there!

DO NOT RENAME THE RESOURCE OR YOU WILL BREAK THE NUI (The cash register)

YOU NEED A BURGERSHOT MAP! Here is a link to two

https://www.gta5-mods.com/maps/gtaiv-burgershot-interior-sp-and-fivem

https://www.gta5-mods.com/maps/burgershot-remastered-gta-v-interior-mod-gtadps

Make sure you have all dependencies and start them in this order

ESX


PolyZone
bt-target
gl-burgershot

mythic_notifications (doesn't matter where you put it)


RUN THE SQL! YOU NEED the society_burger, and the burger shot jobs
Make sure to change the salary to whatever you want

YOU WILL HAVE TO MANUALLY ADD THE ITEMS TO YOUR DATABASE, Since everyones item categories are different.

ADD THE FOLLOWING ITEMS! The first two are ingredients for the burgers, the last three ARE THE BURGERS

bun
cookedmeat
potatoe
meat

moneyshot
bleeder
heartstopper
fries
cocacola
meal1
meal2
meal3

the meals are moneyshot meal, bleeder meal, and heartstopper meal


Here is what you need to put in basic needs

-- Burger Shot Stuff
ESX.RegisterUsableItem('moneyshot', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('moneyshot', 1)
    TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
    TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('fries', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('fries', 1)
    TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
    TriggerClientEvent('esx_status:add', source, 'thirst', -50000)
    TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('bleeder', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('bleeder', 1)
    TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
    TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('heartstopper', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('heartstopper', 1)
    TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
    TriggerClientEvent('esx_basicneeds:onEat', source)
end)
