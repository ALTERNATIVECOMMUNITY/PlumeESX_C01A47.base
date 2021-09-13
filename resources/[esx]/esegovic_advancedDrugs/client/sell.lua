SellItems = function(amountToSell)
    local b = PlayerPedId()
    FreezeEntityPosition(b, true)
    local c = {}
    for d, e in pairs(Config.SellingItems) do
        table.insert(
            c,
            {
                label = e.label .. " | " .. ('<span style="color:green;">%s</span>'):format("$" .. e.SellPrice .. ""),
                DB_Name = e.DB_Name,
                SellPrice = e.SellPrice
            }
        )
    end
    ESX.UI.Menu.Open(
        "default",
        GetCurrentResourceName(),
        "sell_point_menu",
        {title = Config.Translate[161], align = "bottom-right", elements = c},
        function(f, g)
            if f.current.DB_Name == f.current.DB_Name then
                DialogMenuESX(f.current.DB_Name, f.current.SellPrice)
            end
        end,
        function(f, g)
            g.close()
            a = false
            FreezeEntityPosition(b, false)
        end,
        function(f, g)
        end
    )
end
function DialogMenuESX(h, i)
    ESX.UI.Menu.Open(
        "dialog",
        GetCurrentResourceName(),
        "dialogmenu_sell",
        {title = Config.Translate[162]},
        function(f, g)
            g.close()
            amountToSell = tonumber(f.value)
            totalSellPrice = i * amountToSell
            TriggerServerEvent("esegovic:ProdajPredmet", amountToSell, totalSellPrice, h)
        end,
        function(f, g)
            g.close()
        end
    )
end
if Config.EnableSellBlip then
    Citizen.CreateThread(
        function()
            for j, k in pairs(Config.Sell) do
                for l = 1, #k.SellPoint, 1 do
                    local m = AddBlipForCoord(k.SellPoint[l])
                    SetBlipSprite(m, 403)
                    SetBlipDisplay(m, 4)
                    SetBlipScale(m, 0.8)
                    SetBlipColour(m, 27)
                    SetBlipAsShortRange(m, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentSubstringPlayerName(Config.SellPointBlipName)
                    EndTextCommandSetBlipName(m)
                end
            end
        end
    )
end
