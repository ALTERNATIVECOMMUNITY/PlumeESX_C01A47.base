--Example

RegisterNUICallback("np-ui:test:input", function(data, cb)
    print("np-ui:test:input",json.encode(data))
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("phone:PayPhoneDial", function(data, cb)
    TriggerEvent('phone:makepayphonecall', data[1])
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