--Example

RegisterNUICallback("np-ui:test:input", function(data, cb)
    print("np-ui:test:input",json.encode(data))
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("t1ger_mechanicjob:sendCraft", function(data, cb)
    TriggerEvent('t1ger_mechanicjob:sendCraft', data.key)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("t1ger_mechanicjob:billClient", function(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent('t1ger_mechanicjob:billClient', tonumber(data[1].value), tonumber(data[2].value))
    cb("ok")
end)

RegisterNUICallback("t1ger_mechanicjob:mechRepairValue", function(data, cb)
    TriggerEvent('t1ger_mechanicjob:setRepairValue', data[1].value)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("t1ger_mechanicjob:mechActionMenu", function(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent('t1ger_mechanicjob:mechActionMenu', data.key)
    cb("ok")  
end)

RegisterNUICallback("t1ger_mechanicjob:buyMenu", function(data, cb)
    SetNuiFocus(false, false)
    exports['np-ui']:openApplication('textbox', {
        callbackUrl = 't1ger_mechanicjob:buyMenuName',
        key = 1,
        show = true,
        items = {
            {
                icon = "fas fa-pencil-alt",
                label = "Shop name:",
                name = "text",
            },
        },
    })
    TriggerEvent('t1ger_mechanicjob:buyMenu', data.key) 
    cb("ok")   
end)

RegisterNUICallback("t1ger_mechanicjob:buyMenuName", function(data, cb)
	print(data[1].value)
    TriggerEvent('t1ger_mechanicjob:setName', data[1].value)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("phone:PayPhoneDial", function(data, cb)
    TriggerEvent('phone:makepayphonecall', data[1])
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("advancedGarage:takeOut", function(data, cb)
    TriggerEvent('advancedGarage:takeOut', data.key)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("raid_clothes:sendOutfit", function(data, cb)
    SetNuiFocus(false, false)
    exports['np-ui']:openApplication('textbox', {
        callbackUrl = 'raid_clothes:sendOutfitName',
        key = 1,
        show = true,
        items = {
            {
                icon = "fas fa-pencil-alt",
                label = "Outfit Name:",
                name = "text",
            },
        },
    })
    cb("ok")
end)

RegisterNUICallback("raid_clothes:outfitsDelete", function(data, cb)
    TriggerEvent('raid_clothes:outfitsDeleteC', data.key)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("raid_clothes:sendOutfitName", function(data, cb)
    TriggerEvent('raid_clothes:sendOutfit', data[1].value)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("raid_clothes:outfitsChange", function(data, cb)
    TriggerEvent('raid_clothes:outfitsChange', data.key)
    print(json.encode(data))
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterCommand("testnewkeyboard", function()
    exports['np-ui']:openApplication('textbox', {
        callbackUrl = 'np-ui:test:input',
        key = 1,
        show = true,
        items = {
            {
                icon = "fas fa-pencil-alt",
                label = "Text",
                name = "text",
            },
            {
                icon = "fas fa-palette",
                label = "Color (white, red, green, yellow, blue)",
                name = "color",
            },
            {
                icon = "fas fa-people-arrows",
                label = "Distance (0.1 - 10)",
                name = "distance",
            },
        },
    })
end)

RegisterCommand("testtaskbar", function()
    exports["np-ui"]:sendAppEvent("taskbar", {
        display = true,
        duration = 5000,
        taskID = 1,
        label = "Test Taskbar",
    })
end)

RegisterCommand("fixfocus", function()
    SetNuiFocus(false, false)
end)