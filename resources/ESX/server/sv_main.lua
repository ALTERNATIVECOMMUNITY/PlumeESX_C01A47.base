local ESX = nil;
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj; end);

ESX.RegisterServerCallback("showroom:purchaseVehicle", function(source, cb, model, price, amount, plate, label, category)
    local src = source;
    local xPlayer = ESX.GetPlayerFromId(src);
    local cash = xPlayer.getAccounts()
    if xPlayer.getMoney() >= price then
        print(tonumber(category))
        fcategory = getCategory(tonumber(category))
        xPlayer.removeMoney(price)
        local model = model
        print(plate)
        MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, category, name) VALUES (@owner, @plate, @vehicle, @type, @category, @name)', {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = plate,
            ['@vehicle'] = json.encode({model = GetHashKey(model), plate = plate}),
            ['@type'] = 'car',
            ['@category'] = fcategory,
            ['@name'] = label
            }, function(rowsChanged)
        end)
        cb(true, model, plate)
        return
    --elseif tonumber(cash[2].money) >= price then
       -- xPlayer.removeMoney(price)
        --PurchaseCar(src, model)
        --cb(true, model)
        --return
    end
end)

function getCategory(number)
    local categories = {'supers', 'compacts', 'motorcycles', 'muscles', 'offroads', 'offroads', 'suvs', 'sedans', 'sports', 'sportsclassics', 'offroad', 'vans'}
    return categories[number+1]
end


--[[function GeneratePlate()
    --local plate = math.random(0, 99) .. "" .. GetRandomLetter(3) .. "" ..
                     -- math.random(0, 999)
    --local result = exports.ghmattimysql:scalarSync(
                      -- 'SELECT plate FROM owned_vehicles WHERE plate=@plate',
                       {['@plate'] = plate})
    if result then
        plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) ..
                    tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    end
    return plate:upper()
end
]]--


local NumberCharset = {}
local Charset = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end
for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ''
    end
end
