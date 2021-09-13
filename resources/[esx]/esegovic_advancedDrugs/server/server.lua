ESX = nil
TriggerEvent(
    Config.ESXLibrary,
    function(a)
        ESX = a
    end
)
RegisterServerEvent("esegovic:dodajIndicu")
AddEventHandler(
    "esegovic:dodajIndicu",
    function()
        local b = source
        local c = ESX.GetPlayerFromId(b)
        if Config.UseNewESX then
            if c.canCarryItem("weed_indica", 1) then
                c.addInventoryItem("weed_indica", 1)
                c.showNotification(Config.Translate[35])
            else
                c.showNotification(Config.Translate[34])
            end
        else
            c.addInventoryItem("weed_indica", 1)
            c.showNotification(Config.Translate[35])
        end
    end
)
RegisterServerEvent("esegovic:dodajSativa")
AddEventHandler(
    "esegovic:dodajSativa",
    function()
        local b = source
        local c = ESX.GetPlayerFromId(b)
        if Config.UseNewESX then
            if c.canCarryItem("weed_sativa", 1) then
                c.addInventoryItem("weed_sativa", 1)
                c.showNotification(Config.Translate[35])
            else
                c.showNotification(Config.Translate[34])
            end
        else
            c.addInventoryItem("weed_sativa", 1)
            c.showNotification(Config.Translate[35])
        end
    end
)
RegisterServerEvent("esegovic:dodajPurple")
AddEventHandler(
    "esegovic:dodajPurple",
    function()
        local b = source
        local c = ESX.GetPlayerFromId(b)
        if Config.UseNewESX then
            if c.canCarryItem("weed_purple", 1) then
                c.addInventoryItem("weed_purple", 1)
                c.showNotification(Config.Translate[35])
            else
                c.showNotification(Config.Translate[34])
            end
        else
            c.addInventoryItem("weed_purple", 1)
            c.showNotification(Config.Translate[35])
        end
    end
)
ESX.RegisterServerCallback(
    "esegovic:checkPlant",
    function(source, d)
        local c = ESX.GetPlayerFromId(source)
        local e = c.getInventoryItem("weed_indica")
        if e.count >= 1 then
            d(true)
            c.removeInventoryItem("weed_indica", 1)
        else
            d(false)
        end
    end
)
ESX.RegisterServerCallback(
    "esegovic:checkPlant2",
    function(source, d)
        local c = ESX.GetPlayerFromId(source)
        local e = c.getInventoryItem("weed_sativa")
        if e.count >= 1 then
            d(true)
            c.removeInventoryItem("weed_sativa", 1)
        else
            d(false)
        end
    end
)
ESX.RegisterServerCallback(
    "esegovic:checkPlant3",
    function(source, d)
        local c = ESX.GetPlayerFromId(source)
        local e = c.getInventoryItem("weed_purple")
        if e.count >= 1 then
            d(true)
            c.removeInventoryItem("weed_purple", 1)
        else
            d(false)
        end
    end
)
ESX.RegisterServerCallback(
    "esegovic:checkMixItem",
    function(source, d)
        local c = ESX.GetPlayerFromId(source)
        local e = c.getInventoryItem("flour")
        if e.count >= 1 then
            d(true)
            c.removeInventoryItem("flour", 1)
        else
            d(false)
        end
    end
)
RegisterServerEvent("esegovic:packIndica")
AddEventHandler(
    "esegovic:packIndica",
    function()
        local b = source
        local c = ESX.GetPlayerFromId(b)
        local f = math.random(5, 10)
        if Config.UseNewESX then
            if c.canCarryItem("indica_weed", f) then
                c.addInventoryItem("indica_weed", f)
                c.showNotification(Config.Translate[356] .. f .. "g")
            else
                c.showNotification(Config.Translate[34])
            end
        else
            c.addInventoryItem("indica_weed", f)
            c.showNotification(Config.Translate[356] .. f .. "g")
        end
    end
)
RegisterServerEvent("esegovic:packSativa")
AddEventHandler(
    "esegovic:packSativa",
    function()
        local b = source
        local c = ESX.GetPlayerFromId(b)
        local f = math.random(5, 10)
        if Config.UseNewESX then
            if c.canCarryItem("sativa_weed", f) then
                c.addInventoryItem("sativa_weed", f)
                c.showNotification(Config.Translate[356] .. f .. "g")
            else
                c.showNotification(Config.Translate[34])
            end
        else
            c.addInventoryItem("sativa_weed", f)
            c.showNotification(Config.Translate[356] .. f .. "g")
        end
    end
)
RegisterServerEvent("esegovic:packPurple")
AddEventHandler(
    "esegovic:packPurple",
    function()
        local b = source
        local c = ESX.GetPlayerFromId(b)
        local f = math.random(5, 10)
        if Config.UseNewESX then
            if c.canCarryItem("purple_weed", f) then
                c.addInventoryItem("purple_weed", f)
                c.showNotification(Config.Translate[356] .. f .. "g")
            else
                c.showNotification(Config.Translate[34])
            end
        else
            c.addInventoryItem("purple_weed", f)
            c.showNotification(Config.Translate[356] .. f .. "g")
        end
    end
)
RegisterServerEvent("esegovic:dodajCocaine")
AddEventHandler(
    "esegovic:dodajCocaine",
    function()
        local b = source
        local c = ESX.GetPlayerFromId(b)
        if Config.UseNewESX then
            if c.canCarryItem("bag_cocaine", 1) then
                c.addInventoryItem("bag_cocaine", 1)
                c.showNotification(Config.Translate[609])
            else
                c.showNotification(Config.Translate[34])
            end
        else
            c.addInventoryItem("bag_cocaine", 1)
            c.showNotification(Config.Translate[609])
        end
    end
)
RegisterServerEvent("esegovic:notifiPolice")
AddEventHandler(
    "esegovic:notifiPolice",
    function(g)
        TriggerClientEvent("esegovic:policenotify", -1, g)
    end
)
RegisterServerEvent("esegovic:dodajGotovProizvod")
AddEventHandler(
    "esegovic:dodajGotovProizvod",
    function()
        local c = ESX.GetPlayerFromId(source)
        c.addInventoryItem("amfetamin", 1)
        c.showNotification(Config.Translate[140])
    end
)
RegisterServerEvent("esegovic:canWashMoney")
AddEventHandler(
    "esegovic:canWashMoney",
    function(h)
        local c = ESX.GetPlayerFromId(source)
        local i = c.getAccount("black_money").money
        if i >= h then
            c.removeAccountMoney("black_money", h)
            TriggerClientEvent("esegovic:MoneyWashFunc", source, h)
        else
            c.showNotification(Config.Translate[158])
        end
    end
)
RegisterServerEvent("esegovic:washMoney")
AddEventHandler(
    "esegovic:washMoney",
    function(h)
        local c = ESX.GetPlayerFromId(source)
        if Config.EnableTax then
            local j = Config.TaxRate
            local k = h / 100 * j
            local l = h - k
            c.addMoney(l)
            c.showNotification(Config.Translate[154] .. l .. "$")
        else
            c.addMoney(h)
            c.showNotification(Config.Translate[154] .. h .. "$")
        end
    end
)
ESX.RegisterServerCallback(
    "esegovic:checkIDCard",
    function(source, d)
        local c = ESX.GetPlayerFromId(source)
        local e = c.getInventoryItem("moneywash_card")
        if e.count >= 1 then
            d(true)
        else
            d(false)
        end
    end
)
RegisterServerEvent("esegovic:ProdajPredmet")
AddEventHandler(
    "esegovic:ProdajPredmet",
    function(m, n, o)
        local c = ESX.GetPlayerFromId(source)
        local p = ESX.GetItemLabel(o)
        if c.getInventoryItem(o).count >= m then
            c.removeInventoryItem(o, m)
            if Config.GetBlackMoney then
                c.addAccountMoney("black_money", n)
                c.showNotification(Config.Translate[164] .. m .. "x " .. p .. Config.Translate[165] .. "$")
            else
                c.addMoney(n)
                c.showNotification(Config.Translate[164] .. m .. "x " .. p .. Config.Translate[165] .. "$")
            end
        else
            c.showNotification(Config.Translate[166])
        end
    end
)
