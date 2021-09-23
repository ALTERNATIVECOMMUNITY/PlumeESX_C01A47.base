player = nil
coords = {}
curVehicle = nil
driver = nil
name = nil
repairVal = nil
health = {}
index = nil
spotsD = {}
spotsE = {}


  
Citizen.CreateThread(function()
	exports["bt-polyzone"]:AddBoxZone("tunah", vector3(136.9,-3029.97,7.04), 32, 30, {
        name="tunah",
		debugPoly = false,
        heading=93.1,
        minZ=6.0,
        maxZ=8.0
    })
	exports["bt-polyzone"]:AddBoxZone("auto", vector3(537.82,-182.79,54.43), 20, 20, {
        name="auto",
		debugPoly = false,
        heading=0,
        minZ=53.0,
        maxZ=56.0
    })
    while true do
		player = GetPlayerPed(-1)
		coords = GetEntityCoords(player)
        curVehicle = GetVehiclePedIsIn(player, false)
        driver = GetPedInVehicleSeat(curVehicle, -1)
		Citizen.Wait(500)
    end
end)

plyShopID 	= 0
emptyShops 	= {}
RegisterNetEvent('t1ger_mechanicjob:fetchMechShopsCL')
AddEventHandler('t1ger_mechanicjob:fetchMechShopsCL', function(shopID)
	plyShopID = shopID
	for k,v in pairs(shopBlips) do RemoveBlip(v) end
	ESX.TriggerServerCallback('t1ger_mechanicjob:getTakenShops', function(ownedShops)
		for k,v in pairs(ownedShops) do if v.shopID ~= plyShopID then emptyShops[v.shopID] = v.shopID end end
		for k,v in ipairs(Config.MechanicShops) do
			if plyShopID == k then
				for _,y in pairs(ownedShops) do if y.shopID == plyShopID then CreateShopBlips(k,v,y.name) break end end
			else if emptyShops[k] == k then for _,y in pairs(ownedShops) do if y.shopID == k then CreateShopBlips(k,v,y.name) end end
				else if Config.PurchasableMechBlip then CreateShopBlips(k,v,Lang["vacant_shops"]) end end
			end
		end
	end)
end)

-- ## BOSS MENU START ## --
local bossMenu, storageMenu, workbenchMenu = nil, nil, nil
local distance = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for k,v in pairs(Config.MechanicShops) do
			-- Boss Menu:
			distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.menuPos[1], v.menuPos[2], v.menuPos[3], false)
			if distance <= 6.0 then 
				bossMenuFunction(k,v,distance)
			end
			-- Storage Menu:
			distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.storage[1], v.storage[2], v.storage[3], false)
			if distance <= 6.0 then 
				storageMenuFunction(k,v,distance)
			end
			-- Workbench Menu:
			distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.workbench[1], v.workbench[2], v.workbench[3], false)
			if distance <= 6.0 then 
				workbenchMenuFunction(k,v,distance)
			end
		end
	end
end)

-- Boss Menu:
function bossMenuFunction(k,v,distToBoss)
	if bossMenu ~= nil then
		distToBoss = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, bossMenu.menuPos[1], bossMenu.menuPos[2], bossMenu.menuPos[3], false)
		while bossMenu ~= nil and distToBoss > 2.0 do
			bossMenu = nil
			Citizen.Wait(1)
		end
		if bossMenu == nil then
			ESX.UI.Menu.CloseAll()
		end
	else
		local mk = Config.MarkerSettings
		if distToBoss <= 10.0 and distToBoss >= 3.0 then
			if mk.enable then
				--DrawMarker(mk.type, v.menuPos[1], v.menuPos[2], v.menuPos[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)	
			end
			exports["np-ui"]:hideInteraction('manageShop')
		elseif distToBoss <= 2.0 then
			if plyShopID == k then
				--DrawText3Ds(v.menuPos[1], v.menuPos[2], v.menuPos[3], Lang['mech_shop_manage'])
				exports["np-ui"]:showInteraction('[E] Manage Shop','manageShop')
				if IsControlJustPressed(0, Config.KeyToManageShop) then
					bossMenu = v
					MechShopManageMenu(k,v)
					exports["np-ui"]:hideInteraction('manageShop')
				end
			else
				if emptyShops[k] == k then
					DrawText3Ds(v.menuPos[1], v.menuPos[2], v.menuPos[3], Lang['no_access_to_shop'])
				else
					if plyShopID == 0 then
						DrawText3Ds(v.menuPos[1], v.menuPos[2], v.menuPos[3], (Lang['press_to_buy_shop']:format(math.floor(v.price))))
						if IsControlJustPressed(0, Config.KeyToBuyMechShop) then
							bossMenu = v
							BuyMechShopMenu(k,v)
						end
					else
						DrawText3Ds(v.menuPos[1], v.menuPos[2], v.menuPos[3], Lang['only_one_mech_shop'])
					end
				end
			end	
		end
	end
end

-- Manage Mech Shop Menu:
function MechShopManageMenu(id,val)
	local elements = {
		{ label = Lang['rename_mech_shop'], value = "rename_mech_shop" },
		{ label = Lang['sell_mech_shop'], value = "sell_mech_shop" },
		{ label = Lang['employees_action'], value = "employees_menu" },
		{ label = Lang['accounts_action'], value = "accounts_menu" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "mech_shop_manage_menu",
		{
			title    = "Mech Shop ["..tostring(id).."]",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'rename_mech_shop') then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'mech_shop_rename', {
				title = "Rename Mech Shop"
			}, function(data2, menu2)
				menu2.close()
				local shopName = tostring(data2.value)
				ESX.TriggerServerCallback('t1ger_mechanicjob:renameMechShop', function(renamed)
					if renamed then
						exports['mythic_notify']:DoHudText('inform', (Lang['mech_shop_renamed']):format(shopName))
						TriggerServerEvent('t1ger_mechanicjob:fetchMechShops')
						menu.close()
						bossMenu = nil
					else
						exports['mythic_notify']:DoHudText('error', Lang['not_your_mech_shop'])
						menu.close()
						bossMenu = nil
					end
				end, id, val, shopName)
			end,
			function(data2, menu2)
				menu2.close()	
			end)
		end
        if(data.current.value == 'sell_mech_shop') then
			SellMechShopMenu(id,val)
			menu.close()
			bossMenu = nil
		end
        if(data.current.value == 'employees_menu') then
			EmployeesMainMenu(id,val)
			menu.close()
		end
        if(data.current.value == 'accounts_menu') then
			AccountsMainMenu(id,val)
			menu.close()
		end
		menu.close()
	end, function(data, menu)
		menu.close()
		bossMenu = nil
	end)
end

-- Acounts Main Menu:
function AccountsMainMenu(id,val)
	local elements = {
		{ label = Lang['account_withdraw'], value = "account_withdraw" },
		{ label = Lang['account_deposit'], value = "account_deposit" },
	}
	ESX.TriggerServerCallback('t1ger_mechanicjob:getShopAccounts', function(account)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "mech_shop_employees_list",
			{
				title    = "Account [$"..account.."]",
				align    = "center",
				elements = elements
			},
		function(data, menu)
			if(data.current.value == 'account_withdraw') then
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'mech_shop_withdraw_money', {
					title = "Account Money: $"..account
				}, function(data2, menu2)
					menu2.close()
					local withdrawAmount = tonumber(data2.value)
					TriggerServerEvent('t1ger_mechanicjob:withdrawMoney',id,withdrawAmount)
					MechShopManageMenu(id,val)
				end,
				function(data2, menu2)
					menu2.close()	
					AccountsMainMenu(id,val)
				end)
			end
			if(data.current.value == 'account_deposit') then
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'mech_shop_deposit_money', {
					title = "Account Money: $"..account
				}, function(data2, menu2)
					menu2.close()
					local depositAmount = tonumber(data2.value)
					TriggerServerEvent('t1ger_mechanicjob:depositMoney',id,depositAmount)
					MechShopManageMenu(id,val)
				end,
				function(data2, menu2)
					menu2.close()	
					AccountsMainMenu(id,val)
				end)
			end
			menu.close()
		end, function(data, menu)
			menu.close()
			MechShopManageMenu(id,val)
		end)
	end, id)
end

-- Employees Main Menu:
function EmployeesMainMenu(id,val)
	local elements = {
		{ label = Lang['hire_employee'], value = "reqruit_employee" },
		{ label = Lang['employee_list'], value = "employee_list" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "mech_shop_employees_main",
		{
			title    = "Mech Shop [Employees]",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'reqruit_employee') then
			menu.close()
			ESX.TriggerServerCallback('t1ger_mechanicjob:getOnlinePlayers', function(players)
				local elements = {}
				for i=1, #players, 1 do
					table.insert(elements, {
						label = players[i].name,
						value = players[i].source,
						name = players[i].name,
						identifier = players[i].identifier
					})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mech_shop_reqruit_player', {
					title    = "Recruit Employee",
					align    = 'center',
					elements = elements
				}, function(data2, menu2)
					-- YES / NO OPTION:
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mech_shop_reqruit_confirm', {
						title    = "Recruit: "..data2.current.name,
						align    = 'center',
						elements = {
							{label = Lang['button_no'],  value = 'no'},
							{label = Lang['button_yes'], value = 'yes'}
						}
					}, function(data3, menu3)
						menu2.close()
						if data3.current.value == 'yes' then
							menu3.close()
							local jobGrade = 0
							TriggerServerEvent('t1ger_mechanicjob:reqruitEmployee',id,data2.current.identifier,jobGrade,data2.current.name)
							EmployeesMainMenu(id,val)
						end
					end, function(data3, menu3)
						menu3.close()
						EmployeesMainMenu(id,val)
					end)

				end, function(data2, menu2)
					menu2.close()
					EmployeesMainMenu(id,val)
				end)
			end)
		end
        if(data.current.value == 'employee_list') then
			OpenEmployeeListMenu(id,val)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
		MechShopManageMenu(id,val)
	end)
end

-- Employe List Menu
function OpenEmployeeListMenu(id,val)
	local elements = {}
	ESX.TriggerServerCallback('t1ger_mechanicjob:getEmployees', function(employees)
		if employees ~= nil then 
			for k,v in pairs(employees) do
				table.insert(elements,{label = v.firstname.." "..v.lastname, identifier = v.identifier, jobGrade = v.jobGrade, data = v})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), "mech_shop_employees_list",
				{
					title    = "Employee List",
					align    = "center",
					elements = elements
				},
			function(data, menu)
				OpenEmployeeData(data.current,data.current.data,id,val)
				menu.close()
			end, function(data, menu)
				menu.close()
				EmployeesMainMenu(id,val)
			end)
		else
			exports['mythic_notify']:DoHudText('error', Lang['no_employees_hired'])
		end

	end, id)
end

-- Get Employee Menu Data
function OpenEmployeeData(info,user,id,val)
	local elements = {
		{ label = Lang['fire_employee'], value = "fire_employee" },
		{ label = Lang['employee_job_grade'], value = "job_grade_manage" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "mech_shop_employee_data_menu",
		{
			title    = "Employee: "..user.firstname,
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'fire_employee') then
			TriggerServerEvent('t1ger_mechanicjob:fireEmployee',id,user.identifier)
			menu.close()
			EmployeesMainMenu(id,val)
		end
		if(data.current.value == 'job_grade_manage') then
			menu.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'mech_shop_update_new_job_grade', {
				title = "Current Job Grade: "..user.jobGrade
			}, function(data2, menu2)
				menu2.close()
				local newJobGrade = tonumber(data2.value)
				TriggerServerEvent('t1ger_mechanicjob:updateEmployeJobGrade',id,user.identifier,newJobGrade)
				EmployeesMainMenu(id,val)
			end,
			function(data2, menu2)
				menu2.close()	
				EmployeesMainMenu(id,val)
			end)
		end
	end, function(data, menu)
		menu.close()
		OpenEmployeeListMenu(id,val)
	end)
end

-- Sell Mech Shop:
function SellMechShopMenu(id,val)
	local sellPrice = (val.price * Config.SellPercent)
	local elements = {
		{ label = Lang['button_yes'], value = "confirm_sale" },
		{ label = Lang['button_no'], value = "decline_sale" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "mech_shop_sell_menu",
		{
			title    = "Confirm Sale | Price: $"..math.floor(sellPrice),
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'confirm_sale') then
			ESX.TriggerServerCallback('t1ger_mechanicjob:sellMechShop', function(sold)
				if sold then
					TriggerServerEvent('t1ger_mechanicjob:fetchMechShops')
					exports['mythic_notify']:DoHudText('success', (Lang['mech_shop_sold']):format(math.floor(sellPrice)))
				else
					exports['mythic_notify']:DoHudText('error', Lang['not_your_mech_shop'])
				end
			end, id, val, math.floor(sellPrice))
			menu.close()
		end
		if(data.current.value == 'decline_sale') then
			menu.close()
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('t1ger_mechanicjob:buyMenu')
AddEventHandler('t1ger_mechanicjob:buyMenu', function(data)
	Citizen.CreateThread(function()
		while name == nil do
			Citizen.Wait(100)
		end
		ESX.TriggerServerCallback('t1ger_mechanicjob:buyMechShop', function(purchased)
			if purchased then
				exports['mythic_notify']:DoHudText('success', (Lang['mech_shop_bought']):format(math.floor(data.val.price)))
				TriggerServerEvent('t1ger_mechanicjob:fetchMechShops')
				bossMenu = nil
			else
				exports['mythic_notify']:DoHudText('error', Lang['not_enough_money'])
				bossMenu = nil
			end
		end, data.id, data.val, name)
		name = nil
	end)
end)

RegisterNetEvent('t1ger_mechanicjob:setName')
AddEventHandler('t1ger_mechanicjob:setName', function(n)
	name = n
end)

-- Buy Mech Shop:
function BuyMechShopMenu(id,val)
	local menuOptions = {}
	local key = {id = id, val = val}
	menuOptions = {
		{
			title = 'Purchase Shop',
			description = 'Price: $'..math.floor(val.price),
			action = 't1ger_mechanicjob:buyMenu',
			key = key
		}
	}
	exports["np-ui"]:showContextMenu(menuOptions)
end
-- ## BOSS MENU END ## --

-- ## STORAGE MENU START ## --
function storageMenuFunction(k,v,distToStorage)
	if storageMenu ~= nil then
		distToStorage = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, storageMenu.storage[1], storageMenu.storage[2], storageMenu.storage[3], false)
		while storageMenu ~= nil and distToStorage > 2.0 do
			storageMenu = nil
			Citizen.Wait(1)
		end
		if storageMenu == nil then
			ESX.UI.Menu.CloseAll()
		end
	else
		local mk = Config.MarkerSettings
		if distToStorage <= 10.0 and distToStorage >= 2.0 then
			if mk.enable then
				--DrawMarker(mk.type, v.storage[1], v.storage[2], v.storage[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
			end
			exports["np-ui"]:hideInteraction('storage')
		elseif distToStorage <= 2.0 then
			--DrawText3Ds( v.storage[1], v.storage[2], v.storage[3], Lang['press_to_storage'])
			exports["np-ui"]:showInteraction('[E] Storage','storage')
			if IsControlJustPressed(0, 38) then
				exports["np-ui"]:hideInteraction('storage')
				ESX.TriggerServerCallback('t1ger_mechanicjob:checkAccess', function(hasAccess)
					if hasAccess then 
						storageMenu = v
						MechShopStorageMenu(k,v)
					else
						exports['mythic_notify']:DoHudText('error', Lang['no_access'])
					end
				end, k)
			end
		end
	end
end

-- Storage Menu:
function MechShopStorageMenu(id, val)
	print(Config.MechanicShops[id].storageID)
	exports["mf-inventory"]:openOtherInventory(Config.MechanicShops[id].storageID)
end
-- ## STORAGE MENU END ## --

-- ## WORKBENCH MENU START ## --
function workbenchMenuFunction(k,v,distToWorkbench)
	if workbenchMenu ~= nil then
		distToWorkbench = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, workbenchMenu.workbench[1], workbenchMenu.workbench[2], workbenchMenu.workbench[3], false)
		while workbenchMenu ~= nil and distToWorkbench > 2.0 do
			workbenchMenu = nil
			Citizen.Wait(1)
		end
		if workbenchMenu == nil then ESX.UI.Menu.CloseAll() end
	else
		local mk = Config.MarkerSettings
		if distToWorkbench <= 10.0 and distToWorkbench >= 2.0 then
			if mk.enable then
				--DrawMarker(mk.type, v.workbench[1], v.workbench[2], v.workbench[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
			end
			exports["np-ui"]:hideInteraction('workbench')
		elseif distToWorkbench <= 2.0 then
			--DrawText3Ds( v.workbench[1], v.workbench[2], v.workbench[3], Lang['press_to_workbench'])
			exports["np-ui"]:showInteraction('[E] Workbench','workbench')
			if IsControlJustPressed(0, 38) then
				exports["np-ui"]:hideInteraction('workbench')
				ESX.TriggerServerCallback('t1ger_mechanicjob:checkAccess', function(hasAccess)
					if hasAccess then 
						workbenchMenu = v
						MechShopWorkbenchMenu(k,v)
					else
						exports['mythic_notify']:DoHudText('error', Lang['no_access'])
					end
				end, k)
			end
		end
	end
end

RegisterNetEvent('t1ger_mechanicjob:sendCraft')
AddEventHandler('t1ger_mechanicjob:sendCraft', function(data)
	if not IsEntityPlayingAnim(player, 'mini@repair', 'fixing_a_player', 3) then
        LoadAnim('mini@repair') 
        TaskPlayAnim(player, 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
    end
	exports['progressBars']:startUI((Config.CraftTime * 1000), (Lang['crafting_item']:format(string.upper(data.label))))
	Citizen.Wait((Config.CraftTime * 1000))
	TriggerServerEvent('t1ger_mechanicjob:craftItem', data.label, data.item, data.recipe, data.id, data.val)
	ClearPedSecondaryTask(player)
end)

-- Workbench Menu:
function MechShopWorkbenchMenu(id,val)
	local menuData = {}
	for i, v in pairs(Config.Workbench) do
		local description = ''
		for j, r in pairs(v.recipe) do
			description = description..Config.Materials[r.id].label..': '..r.qty..' '
		end
		v['id'] = id
		v['value'] = val
		menuData[i] = {title = v.label, description = description, action = 't1ger_mechanicjob:sendCraft', key = v}
	end
	exports["np-ui"]:showContextMenu(menuData)
end

-- View Recipe Function:
function ViewCraftingRecipe(item_label, item, recipe, id, val)
	local elements = {}
	for k,v in ipairs(recipe) do
		local material = Config.Materials[v.id]
		table.insert(elements, {label = material.label.." ["..v.qty.." pcs]", name = material.label, item = material.item, amount = v.qty})
	end
	table.insert(elements, {label = Lang['button_return'], value = "menu_return"})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "mech_workbench_recipe_menu",
		{
			title    = "Recipe for: "..item_label,
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if data.current.value == "menu_return" then 
			menu.close()
			MechShopWorkbenchMenu(id, val)
		end
	end, function(data, menu)
		menu.close()
		MechShopWorkbenchMenu(id, val)
	end)
end

-- ## WORKBENCH MENU END ## --

vehOnLift = {}
-- Lift Thread Function:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if PlayerData.job and PlayerData.job.name == 'mechanic' then
			for num,shop in pairs(Config.MechanicShops) do
				local shopDist = #(coords-vector3(shop.lifts[1].entry[1], shop.lifts[1].entry[2], shop.lifts[1].entry[3]))
				if shopDist < 25.0 then
					for k,v in pairs(shop.lifts) do
						local mk = v.marker
						-- Attach Vehicle to Lift:
						local liftDist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.entry[1], v.entry[2], v.entry[3], false)
						if liftDist < mk.drawDist and IsPedInAnyVehicle(player, 1) then
							if mk.enable and liftDist > 2.0 then
								DrawMarker(mk.type, v.entry[1], v.entry[2], v.entry[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
							end
							if liftDist < 2.0 then
								if not v.inUse then 
									exports["np-ui"]:showInteraction('[E] Park on lift','lift')
									if IsControlJustPressed(0, 38) then
										exports["np-ui"]:hideInteraction('lift')
										local plate = GetVehicleNumberPlateText(curVehicle):gsub("^%s*(.-)%s*$", "%1")
										v.currentVeh = curVehicle
										v.inUse = true
										TaskLeaveVehicle(player, v.currentVeh, 0)
										Citizen.Wait(2000)
										SetEntityCoordsNoOffset(v.currentVeh, v.pos[1], v.pos[2], v.pos[3], true, false, false, true)
										SetEntityHeading(v.currentVeh, v.pos[4])
										SetVehicleOnGroundProperly(v.currentVeh)
										FreezeEntityPosition(v.currentVeh, true)
										local newVehPos = GetEntityCoords(v.currentVeh)
										v.pos[3] = newVehPos.z
										vehOnLift[plate] = {entity = v.currentVeh, pos = v.pos, plate = plate, health = {}}
										TriggerServerEvent('t1ger_mechanicjob:liftStateSV', num, k, v, v.currentVeh, true)
										break
									end
								else
									
								end
							else
								exports["np-ui"]:hideInteraction('lift')
							end
						end
						-- Detach Vehicle or Move Up/Down:
						local controlDist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.control[1], v.control[2], v.control[3], false)
						if controlDist < mk.drawDist and not IsPedInAnyVehicle(player, 1) then 
							if mk.enable and controlDist > 1.5 then
								--DrawMarker(mk.type, v.control[1], v.control[2], v.control[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
							end
							if controlDist < 1.5 then
								if v.inUse then 
									--DrawText3Ds(v.control[1], v.control[2], v.control[3], Lang['remove_or_move_veh'])
									exports["np-ui"]:showInteraction('[G] Remove veh [↑] Move up [↓] Move down', 'lift')
									if IsControlJustPressed(0, 47) then
										Citizen.Wait(1000)
										FreezeEntityPosition(v.currentVeh, false)
										SetEntityCoords(v.currentVeh, v.entry[1], v.entry[2], v.entry[3], 1, 0, 0, 1)
										local plate = GetVehicleNumberPlateText(v.currentVeh):gsub("^%s*(.-)%s*$", "%1")
										vehOnLift[plate] = nil
										v.currentVeh = nil
										v.inUse = false
										TriggerServerEvent('t1ger_mechanicjob:liftStateSV', num, k, v, v.currentVeh, false)
										break
									elseif IsControlJustPressed(0, 172) then 
										if v.pos[3] < v.maxValue then 
											v.pos[3] = v.pos[3] + 0.1
											SetEntityCoordsNoOffset(v.currentVeh, v.pos[1], v.pos[2], v.pos[3], 1, 0, 0, 1)
											Wait(100)
										else
											exports['mythic_notify']:DoHudText('error', Lang['lift_cannot_go_higher'])
										end
									elseif IsControlJustPressed(0, 173) then 
										if v.pos[3] > v.minValue then
											v.pos[3] = v.pos[3] - 0.1
											SetEntityCoordsNoOffset(v.currentVeh, v.pos[1], v.pos[2], v.pos[3], 1, 0, 0, 1)
											Wait(100)
										else
											exports['mythic_notify']:DoHudText('error', Lang['lift_cannot_go_lower'])
										end
									end
								else
								end
							else
								exports["np-ui"]:hideInteraction('lift')
							end
						end
					end
				end
			end
		end
	end
end)

--Really unforunate that you dont have a switch case lua :(
RegisterNetEvent('t1ger_mechanicjob:mechActionMenu')
AddEventHandler('t1ger_mechanicjob:mechActionMenu', function(k) 
	local key = k
	local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
	local vehCoords = GetEntityCoords(vehicle, 1)
	local findObj = GetClosestObjectOfType(vehCoords.x, vehCoords.y, vehCoords.z, 1.0, GetHashKey("prop_carjack"), false, false, false)
	if key == 'Billing' then
		createBill()
	elseif key == 'CarJack' then
		--CarJackFunction('interact')
		if DoesEntityExist(findObj) then
			isJackRaised = true	
		end
			UseTheJackFunction(vehicle)		
	elseif key == 'InspectVehicle' then
		InspectVehicleFunction()
	elseif key == 'Engine' then
		RepairVehicleHealthPart(key)
	elseif key == 'Brakes' then 
		RepairVehicleHealthPart(key)
	elseif key == 'Radiator' then 
		RepairVehicleHealthPart(key)
	elseif key == 'Clutch' then 
		RepairVehicleHealthPart(key)
	elseif key == 'Transmission' then 
		RepairVehicleHealthPart(key)
	elseif key == 'Electronics' then 
		RepairVehicleHealthPart(key)
	elseif key == 'Drive Shaft' then 
		RepairVehicleHealthPart(key)
	elseif key == 'Fuel Injector' then 
		RepairVehicleHealthPart(key)
	elseif key == 'engineRepair' then 
		RepairVehicleEngine()
	elseif key == 'bodyRepair' then 
			if vehicle ~= 0 then
				if not vehAnalysed then
					local plate = GetVehicleNumberPlateText(vehicle):gsub("^%s*(.-)%s*$", "%1")
					vehicleData[plate] = {report = {}, entity = nil}
					wheelProperties[plate] = {}
					for i = 0, GetVehicleNumberOfWheels(vehicle) - 1 do
						wheelProperties[plate][i + 1] = {
							xOffset = GetVehicleWheelXOffset(vehicle, i),
							yRotation = GetVehicleWheelYRotation(vehicle, i)
						}
					end
					FetchVehicleBodyDamageReport(vehicle, plate)
				end
			end
	elseif key == 'Road Cone' then 
		carryObject(key)
	elseif key == 'Engine Hoist' then 
		carryObject(key)
	elseif key == 'Tool Trolley' then 
		carryObject(key)
	elseif key == 'Tool Box' then 
		print('tried toolbox')
		carryObject(key)
	elseif key == 'Remove Object' then 
		local coords = GetEntityCoords(GetPlayerPed(-1))
		ClearPedTasks(PlayerPedId())
		ClearPedSecondaryTask(PlayerPedId())
		Citizen.Wait(250)
		DetachEntity(carryModel)
		local allObjects = {"prop_roadcone02a", "prop_tool_box_04", "prop_cs_trolley_01", "prop_engine_hoist"}
		for i = 1, #allObjects, 1 do
			local object = GetClosestObjectOfType(coords, 2.5, GetHashKey(allObjects[i]), false, false, false)
			if DoesEntityExist(object) then
				DeleteObject(object)
			end
		end
	end 
end)

carryModel = 0
holdingObj = false
function carryObject(prop)
	local coords = GetEntityCoords(GetPlayerPed(-1))
	local selct 
	for _, v in pairs(Config.PropEmotes) do
		if prop == v.label then
			selct = v
		end
	end
	carryModel = 0
	holdingObj = true
	if selct.prop == "prop_cs_trolley_01" or selct.prop == "prop_engine_hoist" then PlayPushObjAnim() end
	ESX.Game.SpawnObject(selct.model, {x = coords.x, y = coords.y, z = coords.z}, function(spawnModel)
		carryModel = spawnModel
		local boneIndex = GetPedBoneIndex(PlayerPedId(), selct.bone)
		local pX, pY, pZ, rX, rY, rZ = round(selct.pos[1],2), round(selct.pos[2],2), round(selct.pos[3],2), round(selct.rot[1],2), round(selct.rot[2],2), round(selct.rot[3],2)
		AttachEntityToEntity(carryModel, PlayerPedId(), boneIndex, pX, pY, pZ, rX, rY, rZ, true, true, false, true, 2, 1)
	end)

end

RegisterNetEvent('t1ger_mechanicjob:billClient')
AddEventHandler('t1ger_mechanicjob:billClient', function(id, amount)
	TriggerServerEvent('t1ger_mechanicjob:sendBill', id, amount)
end)


function createBill()
	exports['np-ui']:openApplication('textbox', {
        callbackUrl = 't1ger_mechanicjob:billClient',
        key = 1,
        show = true,
        items = {
            {
                icon = "fas fa-user",
                label = "User ID: ",
                name = "id",
            },
			{
				icon = "fas fa-money-bill",
                label = "Amount to bill: ",
                name = "amount",
			}
        },
    })
end
-- Mechanic Action Menu:
function OpenMechanicActionMenu()
	if PlayerData.job and PlayerData.job.name == "mechanic" then
		local menuOptions = {}
		menuOptions = {
			{
				title = 'Billing',
				description = 'Bill someone for repair services.',
				action = 't1ger_mechanicjob:mechActionMenu',
				key = 'Billing'
			},
			{
				title = 'Car Jack',
				description = 'Use your car jack.',
				action = 't1ger_mechanicjob:mechActionMenu',
				key = 'CarJack'
			},
			{
				title = 'Inspect Vehicle',
				description = 'Assess the damage of the vehicle.',
				action = 't1ger_mechanicjob:mechActionMenu',
				key = 'InspectVehicle'
			},
			{
				title = 'Repair Vehicle Components',
				description = 'Do mantainance on the inner workings.',
				action = '',
				key = '',
				children = {
								{title = 'Engine', action = 't1ger_mechanicjob:mechActionMenu', key = 'Engine'},
								{title = 'Brakes', action = 't1ger_mechanicjob:mechActionMenu', key = 'Brakes'},
								{title = 'Radiator', action = 't1ger_mechanicjob:mechActionMenu', key = 'Radiator'},
								{title = 'Clutch', action = 't1ger_mechanicjob:mechActionMenu', key = 'Clutch'},
								{title = 'Transmission', action = 't1ger_mechanicjob:mechActionMenu', key = 'Transmission'},
								{title = 'Electronics', action = 't1ger_mechanicjob:mechActionMenu', key = 'Electronics'},
								{title = 'Drive Shaft', action = 't1ger_mechanicjob:mechActionMenu', key = 'Drive Shaft'},
								{title = 'Fuel Injector', action = 't1ger_mechanicjob:mechActionMenu', key = 'Fuel Injector'},
							}
				
			},
			{
				title = 'Vehicle Engine Repair',
				description = 'Repair the vehicles engine.',
				action = 't1ger_mechanicjob:mechActionMenu',
				key = 'engineRepair'
			},
			{
				title = 'Vehicle Body Repair',
				description = 'Repair the vehicles body.',
				action = 't1ger_mechanicjob:mechActionMenu',
				key = 'bodyRepair'
			},
			{
				title = 'Prop Emotes',
				description = "RP the hell out em'",
				action = '',
				key = '',
				children = {
					{title = 'Road Cone', action = 't1ger_mechanicjob:mechActionMenu', key = 'Road Cone'},
					{title = 'Engine Hoist', action = 't1ger_mechanicjob:mechActionMenu', key = 'Engine Hoist'},
					{title = 'Tool Trolley', action = 't1ger_mechanicjob:mechActionMenu', key = 'Tool Trolley'},
					{title = 'Tool Box', action = 't1ger_mechanicjob:mechActionMenu', key = 'Tool Box'},
					{title = 'Remove Object', action = 't1ger_mechanicjob:mechActionMenu', key = 'Remove Object'}
				}
			}
		}
	exports["np-ui"]:showContextMenu(menuOptions)

	end
end

RegisterNetEvent('t1ger_mechanicjob:mechActionContext')
AddEventHandler('t1ger_mechanicjob:mechActionContext', function()
	OpenMechanicActionMenu()
	exports["bt-target"]:RemoveZone('MechMenu')
end)


Citizen.CreateThread( function()
    while true do 
		Citizen.Wait(5)
		if IsControlJustPressed(0, Config.KeyToPushPickUpObjs) and carryModel ~= 0 then
			if PlayerData.job and PlayerData.job.name == 'mechanic' then
				local placedObjs = {"prop_roadcone02a", "prop_tool_box_04", "prop_cs_trolley_01", "prop_engine_hoist"}
				local coords, nearDist = GetEntityCoords(GetPlayerPed(-1)), -1
				carryModel = nil
				local objName, zk = nil, Config.PropEmotes
				for i = 1, #placedObjs, 1 do
					local object = GetClosestObjectOfType(coords, 1.5, GetHashKey(placedObjs[i]), false, false, false)
					if DoesEntityExist(object) then
						local objCoords = GetEntityCoords(object)
						local objDist  = GetDistanceBetweenCoords(coords, objCoords, true)
						if nearDist == -1 or nearDist > objDist then nearDist = objDist; carryModel = object; objName = placedObjs[i] end
					end
				end
				if holdingObj then 
					holdingObj = false
					if (objName == 'prop_roadcone02a') or (objName == 'prop_tool_box_04') then PlayPickUpAnim() end
					Citizen.Wait(250)
					DetachEntity(carryModel)
					ClearPedTasks(PlayerPedId())
					ClearPedSecondaryTask(PlayerPedId())
				else
					local Dist = GetDistanceBetweenCoords(GetEntityCoords(carryModel), GetEntityCoords(PlayerPedId()), true)
					if Dist < 1.75 then
						holdingObj = true
						if (objName == 'prop_roadcone02a') or (objName == 'prop_tool_box_04') then PlayPickUpAnim() end
						Citizen.Wait(250)
						ClearPedTasks(PlayerPedId())
						ClearPedSecondaryTask(PlayerPedId())
						if (objName == 'prop_cs_trolley_01') or (objName == 'prop_engine_hoist') then 
							PlayPushObjAnim()
						end
						Citizen.Wait(250)
						AttachEntityToEntity(carryModel, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), zk[objName].bone), zk[objName].pos[1], zk[objName].pos[2], zk[objName].pos[3], zk[objName].rot[1], zk[objName].rot[2], zk[objName].rot[3], true, true, false, true, 2, 1)

					end
				end
			end
		end
	end
end)

function PlayPushObjAnim()
	LoadAnim("anim@heists@box_carry@")
	TaskPlayAnim((PlayerPedId()), "anim@heists@box_carry@", "idle", 4.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function PlayPickUpAnim()
	LoadAnim("random@domestic")
	TaskPlayAnim(PlayerPedId(), "random@domestic", "pickup_low", 5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
end

RegisterNetEvent('t1ger_mechanicjob:RepairVehicleEngine')
AddEventHandler('t1ger_mechanicjob:RepairVehicleEngine', function(vehicle)
	-- inspect anim:
	print(vehicle)
	TaskTurnPedToFaceEntity(player, vehicle, 1.0)
	Citizen.Wait(1000)
	TaskStartScenarioInPlace(player, "WORLD_HUMAN_CLIPBOARD", 0, true)
	exports['progressBars']:startUI(2000, "INSPECTING: ENGINE")
	Citizen.Wait(2000)
	ClearPedTasks(player)
	local engineValue = (round((GetVehicleEngineHealth(vehicle)/10)/10,2))
	if engineValue < 10.0 then 
		local engineMaterials = {}
		for g,h in pairs(Config.HealthParts) do 
			if h.degName == "engine" then
				local array = {}
				engineMaterials = h.materials
				for k,v in pairs(h.materials) do 
					local item = Config.Materials[v.id]
					table.insert(array, item.label)
				end
				local items = table.concat(array,", ")
				local chatMsg = "^*"..h.label.." ^5[^6"..items.."^5] ^0» ^3"..round(engineValue,2).."^0 / ^210.0^0"
				TriggerEvent('chat:addMessage', { args = { chatMsg } })
			end
		end

		local engineAddVal = 0
		local newValue = 10.0
		local difference = (newValue - engineValue)
		if difference > 0 and difference <= 1.0 then engineAddVal = 1.0 else engineAddVal = math.floor(difference + 1.0) end
		ESX.TriggerServerCallback('t1ger_mechanicjob:getMaterialsForHealthRep', function(hasMaterials)
			if hasMaterials then 
				-- repair anim:
				SetEntityHeading(player, GetEntityHeading(vehicle))
				Citizen.Wait(500)
				TaskStartScenarioInPlace(player, "WORLD_HUMAN_VEHICLE_MECHANIC", 0, true)
				exports['progressBars']:startUI(3500, "REPAIRING: ENGINE")
				Citizen.Wait(3500)
				SetVehicleEngineHealth(vehicle, 1000.0)
				ClearPedTasks(player)
			else
				exports['mythic_notify']:DoHudText('error', Lang['need_more_materials'])
			end
		end, plate, "engine", engineMaterials, 10.0, engineAddVal, vehOnLift)
	else
		exports['mythic_notify']:DoHudText('error', "Engine is fully functional")
	end
	exports["bt-target"]:RemoveZone('spotER')	
end)

function RepairVehicleEngine()
	local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
	local plate = GetVehicleNumberPlateText(vehicle):gsub("^%s*(.-)%s*$", "%1")
	local repairingEngine = false
	if vehicle ~= 0 then 
		if vehOnLift[plate] ~= nil then 
			local heading = GetEntityHeading(vehicle)
			if GetEntityModel(GetHashKey(vehicle)) == GetEntityModel(GetHashKey(vehOnLift[plate].entity)) then 
				local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
				local bIndex = GetEntityBoneIndexByName(vehicle, 'engine')
				local spot = {pos = GetWorldPositionOfEntityBone(vehicle, bIndex), scenario = "WORLD_HUMAN_VEHICLE_MECHANIC", done = false}

				if bIndex == -1 then
					print('bIndex nil')
					spot = {pos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d2.y+0.2,0.0), scenario = "WORLD_HUMAN_VEHICLE_MECHANIC", done = false}
				end
				local z = spot.pos.z + 0.2
				exports["bt-target"]:AddBoxZone("spotER", vector3(spot.pos.x, spot.pos.y, z), 1.0, 1.0, {
					name="spotER",
					heading=heading,
					debugPoly=true,
					minZ=z-0.2,
					maxZ=z+0.2
					}, {
						options = {
							{
								event = "t1ger_mechanicjob:RepairVehicleEngine",
								icon = "fas fa-wrench",
								label = "Inspect",
								key = vehicle
							},
						},
						job = {"all"},
						distance = 4.0
						
				})
			end
		end
	end
end

RegisterNetEvent('t1ger_mechanicjob:setRepairValue')
AddEventHandler('t1ger_mechanicjob:setRepairValue', function(v)
	repairVal = v
end)

function RepairVehicleHealthPart(p)
	local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
	local plate = GetVehicleNumberPlateText(vehicle):gsub("^%s*(.-)%s*$", "%1")
	local selected
	local index 
	exports['np-ui']:openApplication('textbox', {
        callbackUrl = 't1ger_mechanicjob:mechRepairValue',
        key = 1,
        show = true,
        items = {
            {
                icon = "fas fa-wrench",
                label = "Repair Value: (1-10)",
                name = "text",
            },
        },
    })
	while repairVal == nil do
		Citizen.Wait(100)
	end
	for k,v in pairs(Config.HealthParts) do
		if v.label == p then
			selected = v
		end
	end
	if vehicle ~= 0 then 
		if vehOnLift[plate] ~= nil then 
			local newValue = tonumber(repairVal)
			if vehOnLift[plate].health[selected.degName] ~= nil then 
				if newValue > 10.0 then
					exports['mythic_notify']:DoHudText('error', Lang['health_part_exceeded'])
				elseif newValue < vehOnLift[plate].health[selected.degName].value then
					exports['mythic_notify']:DoHudText('error', Lang['not_decrease_health_val'])
				else
					local difference = (newValue - vehOnLift[plate].health[selected.degName].value)
					local valueToAdd = 0
					if difference <= 0 then
						exports['mythic_notify']:DoHudText('error', Lang['not_decrse_or_same_val'])
					else
						if difference > 0 and difference <= 1.0 then 
							valueToAdd = 1.0
						else 
							valueToAdd = math.floor(difference + 1.0)
						end
					RepairSelectedHealthPart(plate, selected.label, selected.degName, selected.materials, newValue, valueToAdd)
					end
				end
			else
				exports['mythic_notify']:DoHudText('error', Lang['veh_must_be_inspected'])
			end
		end
	end
	repairVal = nil
end

function RepairSelectedHealthPart(plate, label, degName, materials, newValue, addValue)
	local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
	local repairingPart = false
	if vehicle ~= 0 then 

		local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
		local enginePos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d2.y+0.2,0.0)
		local distance = (GetDistanceBetweenCoords(coords, vector3(enginePos.x, enginePos.y, enginePos.z), true)) 

		while true do 
			Citizen.Wait(1)
			distance = (GetDistanceBetweenCoords(coords, vector3(enginePos.x, enginePos.y, enginePos.z), true))
			if distance < 5.0 then
				DrawText3Ds(enginePos.x, enginePos.y, enginePos.z, Lang['health_rep_here'])
				if IsControlJustPressed(0, 38) and distance < 1.0 then
					SetEntityHeading(player, GetEntityHeading(vehicle))
					Citizen.Wait(500)
					TaskStartScenarioInPlace(player, "WORLD_HUMAN_VEHICLE_MECHANIC", 0, true)
					exports['progressBars']:startUI(3500, (Lang['lift_repairing_veh']:format(string.upper(label))))
					Citizen.Wait(3500)
					ClearPedTasks(player)
					ESX.TriggerServerCallback('t1ger_mechanicjob:getMaterialsForHealthRep', function(hasMaterials)
						if hasMaterials then 
							vehOnLift[plate].health[degName].value = newValue
							for i, v in pairs(health) do
								if v.part == degName then
									health[i].value = round((newValue*10),2)
									print(health[i].value)
									index = i
								end
							end
							print(plate)
							TriggerServerEvent('t1ger_mechanicjob:updateVehDegradation', plate, health)
							if degName == "engine" then
								local engineValue = round((vehOnLift[plate].health[degName].value * 10)*10,2)
								SetVehicleEngineHealth(vehicle, engineValue)
							end
						else
							exports['mythic_notify']:DoHudText('error', Lang['need_more_materials'])
						end
					end, plate, degName, materials, newValue, addValue, vehOnLift)
					break
				end
			end
			if distance > 5.0 then 
				repairingPart = false
				break
			end
		end
	else
		exports['mythic_notify']:DoHudText('error', Lang['no_vehicle_nearby'])
	end
end

RegisterNetEvent('t1ger_mechanicjob:fetchEngineDmgPeak')
AddEventHandler('t1ger_mechanicjob:fetchEngineDmgPeak', function(key)
	TaskTurnPedToFaceEntity(player, key[2], 1.0)
	Citizen.Wait(1000)
	TaskStartScenarioInPlace(player, key[3].scenario, 0, true)
	exports['progressBars']:startUI(1500, Lang['progbar_inspecting_veh'])
	Citizen.Wait(1500)
	ClearPedTasksImmediately(player)
	spotsE[tonumber(key[1])].done = true
	exports["bt-target"]:RemoveZone('spotE'..key[1])
end)

function InspectVehicleFunction()
	local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
	local plate = GetVehicleNumberPlateText(vehicle):gsub("^%s*(.-)%s*$", "%1")
	if vehicle ~= 0 then 
		if vehOnLift[plate] ~= nil then 
			if GetEntityModel(GetHashKey(vehicle)) == GetEntityModel(GetHashKey(vehOnLift[plate].entity)) then 
				local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
				local heading = GetEntityHeading(vehicle)
				local bIndexes = {GetEntityBoneIndexByName(vehicle, 'seat_dside_f'), GetEntityBoneIndexByName(vehicle, 'engine'), GetEntityBoneIndexByName(vehicle, 'seat_pside_f')}
				spotsE = {
					[1] = {pos = GetWorldPositionOfEntityBone(vehicle, bIndexes[1]), scenario = "WORLD_HUMAN_WELDING", done = false},
					[2] = {pos = GetWorldPositionOfEntityBone(vehicle, bIndexes[2]), scenario = "WORLD_HUMAN_VEHICLE_MECHANIC", done = false},
					[3] = {pos = GetWorldPositionOfEntityBone(vehicle, bIndexes[3]), scenario = "WORLD_HUMAN_MAID_CLEAN", done = false},
				}
				for i, v in pairs(spotsE) do
					if bIndexes[i] ~= -1 then
						local z = v.pos.z
						if i == 1 or i == 3 then
							z = z + 0.2
						end
						exports["bt-target"]:AddBoxZone("spotE"..i, vector3(v.pos.x, v.pos.y, z), 1.0, 1.0, {
							name="spotE"..i,
							heading=heading,
							debugPoly=true,
							minZ=z-0.2,
							maxZ=z+0.2
							}, {
								options = {
									{
										event = "t1ger_mechanicjob:fetchEngineDmgPeak",
										icon = "fas fa-wrench",
										label = "Inspect",
										key = {i, vehicle ,v}
									},
								},
								job = {"all"},
								distance = 4.0
							
						})
					else 
						print('spotE '..i..'=true')
						spotE[i].done = true
					end
				end
				local inspectingVeh = false
				while true do
					Citizen.Wait(1)
					if not inspectingVeh then
						if spotsE[1].done and spotsE[2].done and spotsE[3].done then
							inspectingVeh = true
							Wait(200)
							break
						end
					end
				end

				ESX.TriggerServerCallback('t1ger_mechanicjob:getVehDegradation', function(degradation)
					local vehHealth = {}
					if degradation ~= nil then 
						health = degradation
						-- insert values into health array:
						for k,v in pairs(degradation) do
							local partValue = (round(v.value/10,2))
							if v.part == "engine" then partValue = (round((GetVehicleEngineHealth(vehicle)/10)/10,2)) end
							-- Get materials:
							for g,h in pairs(Config.HealthParts) do 
								if h.degName == v.part then
									vehHealth[v.part] = {value = partValue, materials = h.materials}
									local array = {}
									for k,v in pairs(h.materials) do 
										local item = Config.Materials[v.id]
										table.insert(array, item.label)
									end
									local items = table.concat(array,", ")
									local chatMsg = "^*"..h.label.." ^5[^6"..items.."^5] ^0» ^3"..round(partValue,2).."^0 / ^210.0^0"
									TriggerEvent('chat:addMessage', { args = { chatMsg } })
								end
							end
						end
						vehOnLift[plate].health = vehHealth
					else
						exports['mythic_notify']:DoHudText('error', "Works with only player owned vehicles.")
					end
				end, plate)
			else
				print("veh not matched")
			end
		else
			exports['mythic_notify']:DoHudText('error', Lang['veh_must_be_on_lift'])
		end
	else
		exports['mythic_notify']:DoHudText('error', Lang['no_vehicle_nearby'])
	end
end

usingJack 	= false
isJackRaised 	= false
carJackObj	= nil
vehicleData = {}
wheelProperties = {}
vehAnalysed = false
function CarJackFunction(type)
	local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

	if vehicle ~= 0 then 
		if usingJack then return end 
		usingJack = true

		GetControlOfEntity(vehicle)

		local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
		local door = GetOffsetFromEntityInWorldCoords(vehicle, d2.x+0.2,0.0,0.0)
		local vehCoords = GetEntityCoords(vehicle, 1)
		local distance = (GetDistanceBetweenCoords(coords, vector3(door.x, door.y, door.z), true)) 
		
		while true do 
			Citizen.Wait(1)
			distance = #(coords - vector3(door.x, door.y, door.z))
			if distance < 6.0 then
				local label = ""
				local findObj = GetClosestObjectOfType(vehCoords.x, vehCoords.y, vehCoords.z, 1.0, GetHashKey("prop_carjack"), false, false, false)
				if DoesEntityExist(findObj) then
					isJackRaised = true
					if type == 'interact' then
						label = Lang['lower_jack']
					end
					if type == 'analyse' then
						if not vehAnalysed then 
							label = "Analyse Vehicle Body"
						else
							exports['mythic_notify']:DoHudText('error', Lang['veh_already_analyzed'])
							break
						end
					end
				else
					if type == 'interact' then
						isJackRaised = false
						label = Lang['raise_jack']
					elseif type == 'analyse' then 
						exports['mythic_notify']:DoHudText('error', Lang['raise_veh_b4_analyze'])
						break
					end
				end
				--DrawText3Ds(door.x, door.y, door.z, "~r~[E]~s~ "..label)
				exports["np-ui"]:showInteraction('[E] '..label, 'carjack')
				if IsControlJustPressed(0, 38) and distance < 1.0 then
					exports["np-ui"]:hideInteraction('carjack')
					if isJackRaised then
						if type == 'interact' then
							UseTheJackFunction(vehicle)
							break
						else
							if not vehAnalysed then
								local plate = GetVehicleNumberPlateText(vehicle):gsub("^%s*(.-)%s*$", "%1")
								vehicleData[plate] = {report = {}, entity = nil}
								wheelProperties[plate] = {}
								for i = 0, GetVehicleNumberOfWheels(vehicle) - 1 do
									wheelProperties[plate][i + 1] = {
										xOffset = GetVehicleWheelXOffset(vehicle, i),
										yRotation = GetVehicleWheelYRotation(vehicle, i)
									}
								end
								FetchVehicleBodyDamageReport(vehicle, plate)
								break
							end
						end
					else
						local item = Config.CarJackItem
						ESX.TriggerServerCallback('t1ger_mechanicjob:getInventoryItem', function(hasItem)
							if hasItem then 
								UseTheJackFunction(vehicle)
							else
								exports['mythic_notify']:DoHudText('error', Lang['car_jack_carry'])
							end
						end, item)
					end
					break
				end
			elseif IsControlJustPressed(0, 38) and distance > 1.0 then
				exports['mythic_notify']:DoHudText('error', 'Move to the passenger side of the vehicle')
			end
			if distance > 6.0 then 
				usingJack = false
				exports["np-ui"]:hideInteraction('carjack')
				break
			end
		end
	else
		exports['mythic_notify']:DoHudText('error', Lang['no_vehicle_nearby'])
	end
	usingJack = false
end

function UseTheJackFunction(vehicle)
	TaskTurnPedToFaceEntity(player, vehicle, 1.0)
	Citizen.Wait(1000)
	FreezeEntityPosition(vehicle, true)
	local vehPos = GetEntityCoords(vehicle)

	if not isJackRaised then 
		SpawnJackProp(vehicle)
		Citizen.Wait(250)
	else
		if DoesEntityExist(carJackObj) then
			GetControlOfEntity(carJackObj)
			SetEntityAsMissionEntity(carJackObj)
			SetVehicleHasBeenOwnedByPlayer(carJackObj, true)
		else
			carJackObj = GetClosestObjectOfType(vehPos.x, vehPos.y, vehPos.z, 1.2, GetHashKey("prop_carjack"), false, false, false)
			GetControlOfEntity(carJackObj)
			SetEntityAsMissionEntity(carJackObj)
			SetVehicleHasBeenOwnedByPlayer(carJackObj, true)
		end
	end

	local objPos = GetEntityCoords(carJackObj)
	-- Request & Load Animation:
	local anim_dict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
	local anim_lib	= "weed_crouch_checkingleaves_idle_02_inspector"
	LoadAnim(anim_dict)
	-- progbar:
	local label = ''
	if isJackRaised then label = Lang['progbar_lowering_jack'] else label = Lang['progbar_raising_jack'] end
	exports['progressBars']:startUI((6500), label)
	-- Raise Jack Task:
	TaskPlayAnim(player, anim_dict, anim_lib, 2.0, -3.5, -1, 1, false, false, false, false)
	Citizen.Wait(1000)
	ClearPedTasks(player)
	local count = 5
	while true do
		vehPos = GetEntityCoords(vehicle)
		objPos = GetEntityCoords(carJackObj)
		if count > 0 then 
			TaskPlayAnim(player, anim_dict, anim_lib, 3.5, -3.5, -1, 1, false, false, false, false)
			Citizen.Wait(1000)
			ClearPedTasks(player)
			if not isJackRaised then
				SetEntityCoordsNoOffset(vehicle, vehPos.x, vehPos.y, (vehPos.z+0.10), true, false, false, true)
				SetEntityCoordsNoOffset(carJackObj, objPos.x, objPos.y, (objPos.z+0.10), true, false, false, true)
			else
				SetEntityCoordsNoOffset(vehicle, vehPos.x, vehPos.y, (vehPos.z-0.10), true, false, false, true)
				SetEntityCoordsNoOffset(carJackObj, objPos.x, objPos.y, (objPos.z-0.10), true, false, false, true)
			end
			FreezeEntityPosition(vehicle, true)
			FreezeEntityPosition(carJackObj, true)
			count = count - 1
		end
		if count <= 0 then 
			ClearPedTasks(player)
			if isJackRaised then
				FreezeEntityPosition(vehicle, false)
				if DoesEntityExist(carJackObj) then 
					DeleteEntity(carJackObj)
					DeleteObject(carJackObj)
				end
				carJackObj = nil
				isJackRaised = false
			else
				isJackRaised = true
			end
			usingJack = false
			break
		end
	end
	ClearPedTasks(player)
end

RegisterNetEvent('t1ger_mechanicjob:fetchBodyDmgPeak')
AddEventHandler('t1ger_mechanicjob:fetchBodyDmgPeak', function(key)
	if key[1] == 2 then
		SetEntityHeading(player, GetEntityHeading(key[2]))
		Citizen.Wait(500)
	else
		TaskTurnPedToFaceEntity(player, key[2], 1.0)
		Citizen.Wait(1000)
	end
	TaskStartScenarioInPlace(player, key[3].scenario, 0, true)
	exports['progressBars']:startUI(2500, Lang['progbar_analyzing_veh'])
	Citizen.Wait(2500)
	ClearPedTasks(player)
	spotsD[tonumber(key[1])].done = true
	exports["bt-target"]:RemoveZone('spot'..key[1])
end)

function FetchVehicleBodyDamageReport(vehicle, plate)
	-- Interact To Veh Part:
	local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
	local heading = GetEntityHeading(vehicle)
	local bIndexes = {GetEntityBoneIndexByName(vehicle, 'seat_dside_f'), GetEntityBoneIndexByName(vehicle, 'engine'), GetEntityBoneIndexByName(vehicle, 'seat_pside_f'), GetEntityBoneIndexByName(vehicle, 'boot') }
	spotsD = {
		[1] = {pos = GetWorldPositionOfEntityBone(vehicle, bIndexes[1]), scenario = "WORLD_HUMAN_WELDING", done = false},
		[2] = {pos = GetWorldPositionOfEntityBone(vehicle, bIndexes[2]), scenario = "WORLD_HUMAN_VEHICLE_MECHANIC", done = false},
		[3] = {pos = GetWorldPositionOfEntityBone(vehicle, bIndexes[3]), scenario = "WORLD_HUMAN_MAID_CLEAN", done = false},
		[4] = {pos = GetWorldPositionOfEntityBone(vehicle, bIndexes[4]), scenario = "WORLD_HUMAN_CLIPBOARD", done = false},
	}
	for i, v in pairs(spotsD) do
		if bIndexes[i] ~= -1 then
			local z = v.pos.z
			if i == 1 or i == 3 or i == 2 then
				z = z + 0.2
			end
			exports["bt-target"]:AddBoxZone("spot"..i, vector3(v.pos.x, v.pos.y, z), 1.0, 1.0, {
				name="spot"..i,
				heading=heading,
				debugPoly=true,
				minZ=z-0.2,
				maxZ=z+0.2
				}, {
					options = {
						{
							event = "t1ger_mechanicjob:fetchBodyDmgPeak",
							icon = "fas fa-wrench",
							label = "Inspect",
							key = {i, vehicle ,v}
						},
					},
					job = {"all"},
					distance = 4.0
				
			})
		else 
			print('spotD '..i..'=true')
			spotD[i].done = true
		end
	end
	while true do
		Citizen.Wait(1)
		if spotsD[1].done and spotsD[2].done and spotsD[3].done and spotsD[4].done then 
			break
		end
	end
	
	local damageReport = {doors = {}, wheels = {}, engine = nil, body = nil}
	-- Doors Report:
	for i = 0, GetNumberOfVehicleDoors(vehicle) + 1 do
		if IsVehicleDoorDamaged(vehicle, i) then
			damageReport.doors[i + 1] = true
			local label, doorLabel = '', ''
			if i >= 0 and i <= 3 then 
				if i == 0 then doorLabel = 'Left Front' elseif i == 1 then doorLabel = 'Right Front' elseif i == 2 then doorLabel = 'Back Left' elseif i == 3 then doorLabel = 'Back Right' end
				label = "^*Door ^5[^6"..doorLabel.."^5] ^0» ^3 Damaged ^0» ^2Replace the Door"
			end
			if i == 4 then label = "^*Door ^5[^6Hood^5] ^0» ^3 Damaged ^0» ^2Replace the Hood"
			elseif i == 5 then label = "^*Door ^5[^6Trunk^5] ^0» ^3 Damaged ^0» ^2Replace the Trunk"
			elseif i == 6 then label = "^*Door ^5[^6Trunk2^5] ^0» ^3 Damaged ^0» ^2Replace the trunk" end
			TriggerEvent('chat:addMessage', { args = { label } })
		else
			damageReport.doors[i + 1] = false
		end
	end
	-- Wheels Report:
	for i = 0, GetVehicleNumberOfWheels(vehicle) - 1 do
		if i == 0 or i == 1 then 
			if IsVehicleTyreBurst(vehicle, i) or GetVehicleWheelXOffset(vehicle, i) == 9999.0 then
				damageReport.wheels[i + 1] = true
				local label = ''
				if i == 0 then
					label = "^*Wheel ^5[^6Left Front^5] ^0» ^3 Bursted ^0» ^2Replace the Wheel"
				elseif i == 1 then 
					label = "^*Wheel ^5[^6Right Front^5] ^0» ^3 Bursted ^0» ^2Replace the Wheel"
				end
				TriggerEvent('chat:addMessage', { args = { label } })
			else
				damageReport.wheels[i + 1] = false
			end
		end
		if i == 2 then 
			if IsVehicleTyreBurst(vehicle, 4) or GetVehicleWheelXOffset(vehicle, i) == 9999.0  then
				damageReport.wheels[i + 1] = true
				local label = "^*Wheel ^5[^6Back Left^5] ^0» ^3 Bursted ^0» ^2Replace the Wheel"
				TriggerEvent('chat:addMessage', { args = { label } })
			else
				damageReport.wheels[i + 1] = false
			end
		end
		if i == 3 then 
			if IsVehicleTyreBurst(vehicle, 5) or GetVehicleWheelXOffset(vehicle, i) == 9999.0 then
				damageReport.wheels[i + 1] = true
				local label = "^*Wheel ^5[^6Back Right^5] ^0» ^3 Bursted ^0» ^2Replace the Wheel"
				TriggerEvent('chat:addMessage', { args = { label } })
			else
				damageReport.wheels[i + 1] = false
			end
		end
	end
	-- Engine Report
	damageReport.engine = GetVehicleEngineHealth(vehicle)
	-- Body Report
	damageReport.body = GetVehicleBodyHealth(vehicle)
	SetVehicleCanDeformWheels(vehicle, false)
	Wait(500)
	vehicleData[plate] = {report = damageReport, entity = vehicle}
	vehAnalysed = true
	RefreshVehicleDamage(vehicleData[plate].entity, plate)
end

installingPart = false
carryObj = nil
RegisterNetEvent('t1ger_mechanicjob:installBodyPartCL')
AddEventHandler('t1ger_mechanicjob:installBodyPartCL', function(id, val)
	local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
	if vehicle ~= 0 then 
		if vehAnalysed then else return exports['mythic_notify']:DoHudText('error', Lang['analyze_veh_first']) end
		GetControlOfEntity(vehicle)
		local vehCoords = GetEntityCoords(vehicle, 1)
		local distance = GetDistanceBetweenCoords(coords, vehCoords, false)
		if not installingPart then
			if not DoesEntityExist(carryObj) then 
				local anim_dict = "anim@heists@box_carry@"
				LoadAnim(anim_dict)
				TaskPlayAnim(player, anim_dict, "idle", 6.0, -2.0, -1, 50, 0, false, false, false)
				ESX.Game.SpawnObject(val.prop, {x = coords.x, y = coords.y, z = coords.z}, function(spawnObj)
					carryObj = spawnObj
					local boneIndex = GetPedBoneIndex(player, 28422)
					AttachEntityToEntity(spawnObj, player, boneIndex, val.pos[1], val.pos[2], val.pos[3], val.rot[1], val.rot[2], val.rot[3], true, true, false, true, 1, true)
				end)
			end
			while true do 
				Citizen.Wait(1)
				distance = #(coords - vehCoords)
				if distance < 4.0 then
					local findObj = GetClosestObjectOfType(vehCoords.x, vehCoords.y, vehCoords.z, 1.0, GetHashKey("prop_carjack"), false, false, false)
					if DoesEntityExist(findObj) then
						--DrawText3Ds(vehCoords.x, vehCoords.y, vehCoords.z, Lang['install_body_part'])
						if distance < 1.5 then
							exports["np-ui"]:showInteraction('[G] to install part', 'installBody')
						
							if IsControlJustPressed(0, 47) then
								exports["np-ui"]:hideInteraction('installBody')
								installingPart = true
								local plate = GetVehicleNumberPlateText(vehicle):gsub("^%s*(.-)%s*$", "%1")
								if id == 1 then
									for i = 0, (GetNumberOfVehicleDoors(vehicleData[plate].entity) - 2) do
										if vehicleData[plate].report.doors[i + 1] == true then
											vehicleData[plate].report.doors[i + 1] = false
											TriggerServerEvent('t1ger_mechanicjob:syncVehicleBodySV', plate)
											TriggerServerEvent('t1ger_mechanicjob:removeItem', val.item, 1)
											break
										else
											if tonumber(i + 1) == tonumber(GetNumberOfVehicleDoors(vehicleData[plate].entity) - 2) then 
												exports['mythic_notify']:DoHudText('error',Lang['all_doors_intact'])
												break
											end
										end
									end
								end
								if id == 2 then 
									if vehicleData[plate].report.doors[4+1] == true then
										vehicleData[plate].report.doors[4+1] = false
										TriggerServerEvent('t1ger_mechanicjob:syncVehicleBodySV', plate)
										TriggerServerEvent('t1ger_mechanicjob:removeItem', val.item, 1)
									else
										exports['mythic_notify']:DoHudText('error',Lang['hood_already_installed'])
									end
								end
								if id == 3 then 
									if vehicleData[plate].report.doors[5+1] == true then
										vehicleData[plate].report.doors[5+1] = false
										TriggerServerEvent('t1ger_mechanicjob:syncVehicleBodySV', plate)
										TriggerServerEvent('t1ger_mechanicjob:removeItem', val.item, 1)
									else
										exports['mythic_notify']:DoHudText('error', Lang['trunk_already_installed'])
									end
								end
								if id == 4 then 
									for i = 0, (GetVehicleNumberOfWheels(vehicleData[plate].entity) - 1) do
										if GetVehicleWheelXOffset(vehicleData[plate].entity, i) == 9999.0 then
											if vehicleData[plate].report.wheels[i + 1] == true then 
												vehicleData[plate].report.wheels[i + 1] = false
												TriggerServerEvent('t1ger_mechanicjob:syncVehicleBodySV', plate)
												TriggerServerEvent('t1ger_mechanicjob:removeItem', val.item, 1)
												break
											end
										else
											if tonumber(i + 1) == tonumber(GetVehicleNumberOfWheels(vehicleData[plate].entity) - 1) then
												exports['mythic_notify']:DoHudText('error', Lang['all_wheels_intact'])
												SetVehicleCanDeformWheels(vehicle, true)
											end
										end
									end
								end
								DetachEntity(carryObj, 1, 0)
								ESX.Game.DeleteObject(carryObj)
								carryObj = nil
								ClearPedTasks(player)
								Citizen.Wait(100)

								local progression = GetBodyRepairProgression(vehicle)
								print(progression)
								exports['mythic_notify']:DoHudText('inform', "Progression: ["..progression.."/100]")
								if progression >= 100 then 
									SetVehicleCanDeformWheels(vehicle, true)
									Wait(100)
									SetVehicleFixed(vehicle)
									SetVehicleEngineHealth(vehicle, vehicleData[plate].report.engine)
									SetVehicleBodyHealth(vehicle, 1000.0)
									vehAnalysed = false
									exports['mythic_notify']:DoHudText('success', Lang['all_body_repairs_done'])
								end
								break
							end
						else
							exports["np-ui"]:hideInteraction('[G] '..Lang['install_body_part'], 'installBody')
						end
					else
						exports['mythic_notify']:DoHudText('error', Lang['raise_and_analyze'])
						break
					end
				end
				if distance > 4.0 then 
					break
				end
			end
		else
			exports['mythic_notify']:DoHudText('error', Lang['finish_current_install'])
		end
	else
		exports['mythic_notify']:DoHudText('error', Lang['no_vehicle_nearby'])
	end
	installingPart = false
end)

function RefreshVehicleDamage(vehicle, plate)
	SetVehicleFixed(vehicle)
	for i = 0, GetNumberOfVehicleDoors(vehicle) + 1 do
		if vehicleData[plate].report.doors[i + 1] == true then
			SetVehicleDoorBroken(vehicle, i, true)
		end
	end
	if vehicleData[plate].report.engine ~= nil then
		SetVehicleEngineHealth(vehicle, tonumber(vehicleData[plate].report.engine))
	else
		SetVehicleEngineHealth(vehicle, 0)
	end
	if vehicleData[plate].report.body ~= nil then
		SetVehicleBodyHealth(vehicle, tonumber(vehicleData[plate].report.body))
	else
		SetVehicleBodyHealth(vehicle, 800)
	end
	for i = 0, GetVehicleNumberOfWheels(vehicle) - 1 do
		if vehicleData[plate].report.wheels[i + 1] == true then
			SetVehicleWheelsCanBreak(vehicle, i, 0)
			SetVehicleWheelHealth(vehicle, i, 0.0)
			SetVehicleWheelXOffset(vehicle, i, 9999.0)
			SetVehicleWheelYRotation(vehicle, i, -90.0)
		else
			SetVehicleWheelsCanBreak(vehicle, i, false)
			SetVehicleWheelHealth(vehicle, i, 100.0)
			SetVehicleWheelXOffset(vehicle, i, wheelProperties[plate][i + 1].xOffset)
			SetVehicleWheelYRotation(vehicle, i, wheelProperties[plate][i + 1].yRotation)
		end
	end
	--RemoveVehicleWindow(vehicle, 0)
	--RemoveVehicleWindow(vehicle, 1)
	--RemoveVehicleWindow(vehicle, 2)
	--RemoveVehicleWindow(vehicle, 3)
end

-- On the road repairs:
local repairing = false
RegisterNetEvent('t1ger_mechanicjob:useRepairKit')
AddEventHandler('t1ger_mechanicjob:useRepairKit', function(type, val)
	local vehicle = nil

	vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

	if vehicle ~= 0 then
		if repairing then return end
		repairing = true

		-- Get Control of Vehicle:
		local netTime = 15
        NetworkRequestControlOfEntity(vehicle)
        while not NetworkHasControlOfEntity(vehicle) and netTime > 0 do 
            NetworkRequestControlOfEntity(vehicle)
            Citizen.Wait(100)
            netTime = netTime -1
		end

		-- Get Repair Veh Position:
		local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
		local hood = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d2.y+0.2,0.0)
		local distance = (GetDistanceBetweenCoords(GetEntityCoords(player, 1), vector3(hood.x, hood.y, hood.z), true))
		local vehRepaired = false

		-- Repair thread:
        while not vehRepaired do
            Citizen.Wait(1)
            distance = (GetDistanceBetweenCoords(GetEntityCoords(player, 1), vector3(hood.x, hood.y, hood.z), true))
			DrawText3Ds(hood.x, hood.y, hood.z, Lang['repair_here'])
			if IsControlJustPressed(0, 38) then 
				if distance < 1.0 then 
					SetVehicleDoorOpen(vehicle, 4, 0, 0)
					TaskTurnPedToFaceEntity(player, vehicle, 1.0)
					Citizen.Wait(1000)
					local animDict = "mini@repair"
					LoadAnim(animDict)
					if not IsEntityPlayingAnim(player, animDict, "fixing_a_player", 3) then
						TaskPlayAnim(player, animDict, "fixing_a_player", 5.0, -5, -1, 16, false, false, false, false)
					end
					-- repair options:
					RepairVehOptions(vehicle, type, val)
					-- Chance to destroy item:
					if math.random(100) > val.chanceToKeep then
						TriggerServerEvent('t1ger_mechanicjob:removeItem', val.item, 1)
						exports['mythic_notify']:DoHudText('error', Lang['repair_kit_broke'])
					end
					-- end:
					SetVehicleDoorShut(vehicle, 4, 1, 1)
					ClearPedTasks(player)
					exports['mythic_notify']:DoHudText('inform', Lang['repairkit_veh_repaired'])
					vehRepaired = true
					repairing = false
					break
				else
					distance = (GetDistanceBetweenCoords(GetEntityCoords(player, 1), vector3(hood.x, hood.y, hood.z), true))
				end
			end
        end
	end
	repairing = false
end)

-- Choose repairs with repairkit:
function RepairVehOptions(veh, type, val)
	local repairDuration = (((3000-GetVehicleEngineHealth(vehicle)) - (GetVehicleBodyHealth(vehicle)/2))*2 + val.repairTime)
	exports['progressBars']:startUI((repairDuration), val.progbar)
	Citizen.Wait(repairDuration)
	if type == 1 then 
		if GetVehicleEngineHealth(veh) < 200.0 then	SetVehicleEngineHealth(veh, 200.0) end
		if GetVehicleBodyHealth(veh) < 910.0 then SetVehicleBodyHealth(veh, 910.0) end
		for i = 0, math.random(5) do SetVehicleTyreFixed(veh, i) end
	end
	if type == 2 then 
		if GetVehicleEngineHealth(veh) < 200.0 then	SetVehicleEngineHealth(veh, 450.0) end
		if GetVehicleBodyHealth(veh) < 910.0 then SetVehicleBodyHealth(veh, 975.0) end
		for i = 0, 5 do SetVehicleTyreFixed(veh, i)  end
	end
end

-- Vehicle Value Saver:
Citizen.CreateThread(function()
	Citizen.Wait(1000)
	local count = 0
	while true do
		Citizen.Wait(1000)
		if IsPedInVehicle(player, curVehicle, false) then
			count = count + 1
			if count >= Config.WaitCountForHealth then
				if player == driver then 
					local plate = GetVehicleNumberPlateText(curVehicle):gsub("^%s*(.-)%s*$", "%1")
					local engine = math.ceil(GetVehicleEngineHealth(curVehicle))
					local body = math.ceil(GetVehicleBodyHealth(curVehicle))
					ApplyVehicledegradation(curVehicle, plate)
				end
				count = 0
			end
		end
	end
end)

function ApplyVehicledegradation(curVehicle, plate)
	ESX.TriggerServerCallback('esx_advancedgarage:isVehicleOwned', function(vehOwned)
		if vehOwned then 
			ESX.TriggerServerCallback('t1ger_mechanicjob:getVehDegradation', function(degradation)
				if degradation ~= nil then 
					local vehHealth = {}
					-- insert values into health array:
					for k,v in pairs(degradation) do
						local partValue = (round(v.value/10,2))
						vehHealth[v.part] = v.value
					end
					-- electronics:
					if vehHealth["electronics"] <= 40 then
						local chance, electronics = math.random(1,100), vehHealth["electronics"]
						if electronics <= 40 and electronics >= 25 and chance > 85 then
							for i = 0, 10 do Citizen.Wait(50) ElectronicsEffects(curVehicle) end
						end
						if electronics <= 24 and electronics >= 10 and chance > 70 then
							for i = 0, 10 do Citizen.Wait(100) ElectronicsEffects(curVehicle) end
						end
						if electronics <= 9 and electronics >= 0 and chance > 50 then
							for i = 0, 10 do Citizen.Wait(200) ElectronicsEffects(curVehicle) end
						end
					end
					-- Fuel Injector:
					if vehHealth["fuelinjector"] <= 40 then
						local chance, fuel_injector = math.random(1,100), vehHealth["fuelinjector"]
						if fuel_injector <= 40 and fuel_injector >= 25 and chance > 85 then
							FuelInjectorEffects(curVehicle, 200)
						end
						if fuel_injector <= 24 and fuel_injector >= 10 and chance > 70 then
							FuelInjectorEffects(curVehicle, 500)
						end
						if fuel_injector <= 9 and fuel_injector >= 0 and chance > 50 then
							FuelInjectorEffects(curVehicle, 1000)
						end
					end
					-- Brakes:
					if vehHealth["brakes"] <= 40 then
						local chance, brakes = math.random(1,100), vehHealth["brakes"]
						if brakes <= 40 and brakes >= 25 and chance > 85 then
							BrakesEffects(curVehicle, 1000)
						end
						if brakes <= 24 and brakes >= 10 and chance > 70 then
							BrakesEffects(curVehicle, 4000)
						end
						if brakes <= 9 and brakes >= 0 and chance > 50 then
							BrakesEffects(curVehicle, 8000)
						end
					end
					-- Radiator:
					if vehHealth["radiator"] <= 40 then
						local chance, radiator = math.random(1,100), vehHealth["radiator"]
						if radiator <= 40 and radiator >= 25 then
							RadiatorEffects(curVehicle, chance, 1000)
						end
						if radiator <= 24 and radiator >= 10 then
							RadiatorEffects(curVehicle, chance, 3000)
						end
						if radiator <= 9 and radiator >= 0 then
							RadiatorEffects(curVehicle, chance, 5000)
						end
					end
					-- Drive Shaft / Axle:
					if vehHealth["driveshaft"] <= 40 then
						local chance, axle = math.random(1,100), vehHealth["driveshaft"]
						if axle <= 40 and axle >= 25 and chance > 85 then
							DriveShaftEffects(curVehicle, 10)
						end
						if axle <= 24 and axle >= 10 and chance > 70 then
							DriveShaftEffects(curVehicle, 20)
						end
						if axle <= 9 and axle >= 0 and chance > 50 then
							DriveShaftEffects(curVehicle, 30)
						end
					end
					-- Transmission:
					if vehHealth["transmission"] <= 40 then
						local chance, transmission = math.random(1,100), vehHealth["transmission"]
						if transmission <= 40 and transmission >= 25 and chance > 85 then
							TransmissionEffects(curVehicle, 5, 2)
						end
						if transmission <= 24 and transmission >= 10 and chance > 70 then
							TransmissionEffects(curVehicle, 10, 4)
						end
						if transmission <= 9 and transmission >= 0 and chance > 50 then
							TransmissionEffects(curVehicle, 20, 8)
						end
					end
					-- Clutch:
					if vehHealth["clutch"] <= 40 then
						local chance, clutch = math.random(1,100), vehHealth["clutch"]
						if clutch <= 40 and clutch >= 25 and chance > 85 then
							ClutchEffects(curVehicle, 1500, 75)
						end
						if clutch <= 24 and clutch >= 10 --[[and chance > 70]] then
							ClutchEffects(curVehicle, 3000, 150)
						end
						if clutch <= 9 and clutch >= 0 and chance > 50 then
							ClutchEffects(curVehicle, 6000, 300)
						end
					end
				else
					return
				end
			end, plate)
		else
			return
		end
	end, plate)
end

function ElectronicsEffects(entity)
	local radios = {"RADIO_03_HIPHOP_NEW","RADIO_04_PUNK","RADIO_05_TALK_01","RADIO_14_DANCE_02","RADIO_20_THELAB","RADIO_17_FUNK","RADIO_18_90S_ROCK"}
	SetVehicleLights(entity, 1)
	SetVehRadioStation(entity, radios[math.random(1,#radios)])
	Citizen.Wait(500)
	SetVehicleLights(entity, 0)
end

function FuelInjectorEffects(entity, timer)
	SetVehicleEngineOn(entity, 0, 0, 1)
	SetVehicleUndriveable(entity, true)
	Citizen.Wait(timer)
	SetVehicleEngineOn(entity, 1, 0, 1)
	SetVehicleUndriveable(entity, false)
end

function BrakesEffects(entity, timer)
	SetVehicleHandbrake(entity, true)
	Citizen.Wait(timer)
	SetVehicleHandbrake(entity, false)
end

function RadiatorEffects(curVehicle, chance, timer)
	local lastTemp = GetVehicleEngineTemperature(curVehicle)
	local eh = GetVehicleEngineHealth(curVehicle)
	SetVehicleEngineTemperature(curVehicle, 500.0)
	Citizen.Wait(timer + 2000)
	if eh >= 900 then SetVehicleEngineHealth(curVehicle, (eh-10)) end
	if eh >= 450 then SetVehicleEngineHealth(curVehicle, (eh-15)) end
	if eh >= 250 then SetVehicleEngineHealth(curVehicle, (eh-25)) end
	SetVehicleEngineTemperature(curVehicle, lastTemp)
end

function DriveShaftEffects(curVehicle, timer)
	local steerBias = {-1.0,-0.9,-0.8,0.8,0.9,1.0}
	local value = steerBias[math.random(#steerBias)]
	local tick = 0
	while true do	
		Citizen.Wait(timer)	
		SetVehicleSteerBias(curVehicle, value)
		tick = tick + 1
		if tick >= 20 then
			tick = 0
			break
		end
	end
end

function TransmissionEffects(curVehicle, timer, count)
	for i = 0, count do						
		Citizen.Wait(timer)
		SetVehicleHandbrake(curVehicle, true)
		Citizen.Wait(1000)
		SetVehicleHandbrake(curVehicle, false)
	end
end

function ClutchEffects(curVehicle, timer, fuelTimer)
	SetVehicleHandbrake(curVehicle, true)
	FuelInjectorEffects(curVehicle, fuelTimer)
	for i = 1, 360 do
		SetVehicleSteeringScale(curVehicle ,i)
		Citizen.Wait(5)
	end
	Citizen.Wait(timer)
	SetVehicleHandbrake(curVehicle, false)
end

-- Vehicle Collision / Damage --
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local lastVehSpeed = 0.0
	local lastVehBodyhealth = 0.0
	local multiplier = 2.236936
	if Config.UseKMH then multiplier = 3.6 end
    while true do 
        Citizen.Wait(1)
        if curVehicle ~= nil and curVehicle ~= 0 then 
            if driver == PlayerPedId() then 
				local curVehicleEngine = GetVehicleEngineHealth(curVehicle)
                if curVehicleEngine < 0.0 then 
                    SetVehicleEngineHealth(curVehicle,0.0)
                end
                local crashed = HasEntityCollidedWithAnything(curVehicle)
				if crashed then
                    Citizen.Wait(100)
                    local newVehBodyHealth = GetVehicleBodyHealth(curVehicle)
                    local newVehSpeed = (GetEntitySpeed(curVehicle) * multiplier)

                    if curVehicleEngine > 0.0 and (lastVehBodyhealth - newVehBodyHealth) > 10 then 
                        if newVehSpeed < (lastVehSpeed * 0.5) and lastVehSpeed > 180.0 then
                            applyCrashDamage(curVehicle)
                            Citizen.Wait(1000)
                            lastVehSpeed = 0.0
                            lastVehBodyhealth = newVehBodyHealth
                        end
                    else
                        if curVehicleEngine > 10.0 and (curVehicleEngine < 199.0 or newVehBodyHealth < 100.0) then
                            applyCrashDamage(curVehicle)
                            Citizen.Wait(1000)
                        end
                        lastVehSpeed = newVehSpeed
                        lastVehBodyhealth = newVehBodyHealth
                    end
                else
                    lastVehSpeed = (GetEntitySpeed(curVehicle) * multiplier)
                    lastVehBodyhealth = GetVehicleBodyHealth(curVehicle)
                    if curVehicleEngine > 10.0 and (curVehicleEngine < 199.0 or lastVehBodyhealth < 100.0) then
                        applyCrashDamage(curVehicle)
                        Citizen.Wait(1000)
                    end 
				end
            end
        end
    end
end)

function applyCrashDamage(vehicle)
	if Config.SlashTires then 
		local tyres = {0,1,4,5}
		for i = 1, math.random(#tyres) do
			local num = math.random(#tyres)
			SetVehicleTyreBurst(vehicle, tyres[num], true, 1000)
			table.remove(tyres, num)
		end 
	end
	if Config.EngineDisable then 
		SetVehicleEngineHealth(vehicle, 0)
		SetVehicleEngineOn(vehicle, false, true, true)
	end
	local takenIDs = {}
	local damageArray = {}
	for i = 1, Config.AmountPartsDamage do
		math.randomseed(GetGameTimer())
		local id = math.random(#Config.HealthParts)
		if Config.HealthParts[id].degName ~= "engine" then 
			while takenIDs[id] == id do
				id = math.random(#Config.HealthParts)
				if Config.HealthParts[id].degName == "engine" then
					id = math.random(#Config.HealthParts)
				end
			end
		end
		takenIDs[id] = id
		local vehPart = Config.HealthParts[id]
		local degVal = math.random(Config.DegradeValue.min,Config.DegradeValue.max)
		damageArray[vehPart.degName] = {label = vehPart.label, degName = vehPart.degName, degValue = degVal}
		i = i + 1
	end
	local plate = GetVehicleNumberPlateText(curVehicle):gsub("^%s*(.-)%s*$", "%1")
	TriggerServerEvent('t1ger_mechanicjob:degradeVehHealth', plate, damageArray)
	takenIDs = {}
	damageArray = {}
    lastVehSpeed = 0.0
    lastVehBodyhealth = 0.0
end

-- ## NPC VEHICLE REPAIR JOBS ## --

local jobID = nil
function ManageNpcJobs()
	local elements = {
		{ label = "Find Call", value = "find_job" },
		{ label = "Cancel Job", value = "cancel_job" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "mech_npc_job_menu",
		{
			title    = "NPC Job Menu",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'find_job') then
			menu.close()
			local num = math.random(1,#Config.NPC_RepairJobs)
			local count = 0
			while Config.NPC_RepairJobs[num].inUse and count < 100 do
				count = count+1
				num = math.random(1,#Config.NPC_RepairJobs)
			end
			if count == 100 then
				ShowNotifyESX("Wait for a call")
			else
				Config.NPC_RepairJobs[num].inUse = true
				Wait(200)
				TriggerServerEvent('t1ger_mechanicjob:JobDataSV', Config.NPC_RepairJobs)
				TriggerEvent('t1ger_mechanicjob:startJobWithNPC', num)
			end
		end
		if(data.current.value == 'cancel_job') then
			menu.close()
			CancelCurrentJob()
		end
	end, function(data, menu)
		menu.close()
		OpenMechanicActionMenu()
	end)
end

local CancelJob = false
local JobVeh = nil
local JobPed = nil
RegisterNetEvent('t1ger_mechanicjob:startJobWithNPC')
AddEventHandler('t1ger_mechanicjob:startJobWithNPC', function(num)
	local JobDone = false
	local job = Config.NPC_RepairJobs[num]
	local blip = CreateJobBlip(job.pos)
	local jobVehSpawned = false
	local vehicleRepaired = false
	local pedCreated = false
	local pedShouted = false
	local buttonClicked = false

	while not JobDone and not CancelJob do 
		Citizen.Wait(0)

		if job.inUse then

			local coords = GetEntityCoords(GetPlayerPed(-1))
			local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, job.pos[1], job.pos[2], job.pos[3], false)

			if distance > 50.0 then
				if DoesEntityExist(JobVeh) then
					DeleteEntity(JobVeh)
					DeleteVehicle(JobVeh)
					SetEntityAsNoLongerNeeded(JobVeh)
					JobVeh = nil
					jobVehSpawned = false
				end
			end

			if distance < 50.0 and not jobVehSpawned then
				ClearAreaOfVehicles(job.pos[1], job.pos[2], job.pos[3], 5.0, false, false, false, false, false)
				jobVehSpawned = true
				Citizen.Wait(200)
				math.randomseed(GetGameTimer())
				local vehID = math.random(#Config.RepairVehicles)
				local jobVehicle = Config.RepairVehicles[vehID]
				ESX.Game.SpawnVehicle(jobVehicle, {x = job.pos[1], y = job.pos[2], z = job.pos[3]}, job.pos[4], function(vehicle)
					SetEntityCoordsNoOffset(vehicle, job.pos[1], job.pos[2], job.pos[3])
					SetEntityHeading(vehicle, job.pos[4])
					SetVehicleOnGroundProperly(vehicle)
					SetEntityAsMissionEntity(JobVeh, true, true)
					JobVeh = vehicle
					SetVehicleEngineHealth(JobVeh, 100.0)
					SetVehicleDoorOpen(JobVeh, 4, 0, 0)
					SetPedIntoVehicle(ped, JobVeh, -1)
				end)
			end

			if distance < 10.0 then
				if not pedCreated then 
					RequestModel(job.ped)
					while not HasModelLoaded(job.ped) do
						Wait(10)
					end
					local NPC = CreatePedInsideVehicle(JobVeh, 1, job.ped, -1, true, true)
					NetworkRegisterEntityAsNetworked(NPC)
					SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(NPC), true)
					SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(NPC), true)
					SetPedKeepTask(NPC, true)
					SetPedDropsWeaponsWhenDead(NPC, false)
					SetEntityInvincible(NPC, false)
					SetEntityVisible(NPC, true)
					JobPed = NPC
					SetEntityAsMissionEntity(JobPed)
					pedCreated = true
				end
				if not pedShouted and distance < 6.0 then
					ShowNotifyESX(Lang['npc_shout_msg'])
					pedShouted = true
				end
				local d1,d2 = GetModelDimensions(GetEntityModel(JobVeh))
				local enginePos = GetOffsetFromEntityInWorldCoords(JobVeh, 0.0,d2.y+0.2,0.0)
				local pedPos = GetEntityCoords(JobPed)
				local vehDistance = (GetDistanceBetweenCoords(coords, vector3(enginePos.x, enginePos.y, enginePos.z), true)) 
				local pedDistance = (GetDistanceBetweenCoords(coords, vector3(pedPos.x, pedPos.y, pedPos.z), false))
				
				if vehDistance < 5.0 and not vehicleRepaired then
					DrawText3Ds(enginePos.x, enginePos.y, enginePos.z, Lang['npc_repair_veh'])
					if IsControlJustPressed(0, 38) and vehDistance < 1.0 and not buttonClicked then
						buttonClicked = true
						ESX.TriggerServerCallback('t1ger_mechanicjob:getInventoryItem', function(hasItem)
							if hasItem then 
								SetVehicleDoorOpen(JobVeh, 4, 0, 0)
								TaskTurnPedToFaceEntity(GetPlayerPed(-1), JobVeh, 1.0)
								Citizen.Wait(1000)
								local animDict = "mini@repair"
								LoadAnim(animDict)
								if not IsEntityPlayingAnim(GetPlayerPed(-1), animDict, "fixing_a_player", 3) then
									TaskPlayAnim(GetPlayerPed(-1), animDict, "fixing_a_player", 5.0, -5, -1, 16, false, false, false, false)
								end
								exports['progressBars']:startUI((4000), Lang['progbar_npc_fix'])
								Citizen.Wait(4000)
								SetVehicleEngineHealth(JobVeh, 1000.0)
								SetVehicleBodyHealth(JobVeh, 1000.0)
								SetVehicleFixed(JobVeh)
								for i = 0, 5 do SetVehicleTyreFixed(JobVeh, i) end
								if math.random(100) > 10 then
									TriggerServerEvent('t1ger_mechanicjob:removeItem', "repairkit", 1)
									ShowNotifyESX(Lang['npc_kit_broke'])
								end
								SetVehicleDoorShut(vehicle, 4, 1, 1)
								ClearPedTasks(GetPlayerPed(-1))
								ShowNotifyESX(Lang['npc_veh_repaired'])
								vehicleRepaired = true
								buttonClicked = false
							else
								ShowNotifyESX(Lang['npc_need_repair_kit'])
								buttonClicked = false
							end
						end, "repairkit")
					end
				end

				if pedDistance < 5.0 and vehicleRepaired then
					DrawText3Ds(pedPos.x, pedPos.y, pedPos.z, Lang['npc_collect_cash'])
					if IsControlJustPressed(0, 38) and pedDistance < 1.5 then
						RollDownWindow(JobVeh, 0)
						SetVehicleCanBeUsedByFleeingPeds(JobVeh, true)
						LoadAnim("mp_common")
						TaskTurnPedToFaceEntity(PlayerPedId(), JobVeh, 1.0)
						Citizen.Wait(1000)
						TaskPlayAnim(GetPlayerPed(-1), "mp_common", "givetake2_a", 4.0, 4.0, -1, 0, 1, 0,0,0)
						exports['progressBars']:startUI((2000), Lang['progbar_npc_cash'])
						Citizen.Wait(2000)
						ClearPedTasks(GetPlayerPed(-1))
						RollUpWindow(JobVeh, 0)
						ShowNotifyESX(Lang['npc_thanking_msg'])
						TriggerServerEvent('t1ger_mechanicjob:JobReward')
						Wait(500)
						if DoesBlipExist(blip) then RemoveBlip(blip) end
						TaskVehicleDriveWander(JobPed, JobVeh, 80.0, 786603)
						Wait(2500)
						TaskSmartFleePed(JobPed, PlayerPedId(), 40.0, 20000)
						Wait(2500)
						CancelJob = true
					end
				end
			end

			if CancelJob then
				if DoesEntityExist(JobVeh) then DeleteVehicle(JobVeh) end
				if DoesEntityExist(JobPed) then DeleteEntity(JobPed) end
				if DoesBlipExist(blip) then RemoveBlip(blip) end
				Config.NPC_RepairJobs[num].inUse = false
				Wait(200)
				TriggerServerEvent('t1ger_mechanicjob:JobDataSV', Config.NPC_RepairJobs)
				JobVeh = nil
				JobPed = nil
				CancelJob = false
				break
			end
		end
	end
end)

-- Function for job blip in progress:
function CreateJobBlip(pos)
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip, 1)
	SetBlipColour(blip, 5)
	AddTextEntry('MYBLIP', Lang['npc_repair_job'])
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, 0.7) -- set scale
	SetBlipAsShortRange(blip, true)
	SetBlipRoute(blip, true)
	SetBlipRouteColour(blip, 5)
	return blip
end

AddEventHandler('esx:onPlayerDeath', function(data)
	CancelJob = true
	if JobVeh ~= nil or JobPed ~= nil then 
		ShowNotifyESX(Lang['npc_cancel_job_death'])
	end
	Wait(300)
	CancelJob = false
end)

function CancelCurrentJob()
	CancelJob = true
	if JobVeh ~= nil or JobPed ~= nil then 
		ShowNotifyESX(Lang['npc_job_cancel_by_ply'])
	end
	Wait(300)
	CancelJob = false
end

-- Update Lift State:
RegisterNetEvent('t1ger_mechanicjob:liftStateCL')
AddEventHandler('t1ger_mechanicjob:liftStateCL', function(k, id, val, vehicle, state)
    Config.MechanicShops[k].lifts[id] = val
    Config.MechanicShops[k].lifts[id].currentVeh = vehicle
    Config.MechanicShops[k].lifts[id].inUse = state
end)

RegisterNetEvent('t1ger_mechanicjob:syncVehicleBodyCL')
AddEventHandler('t1ger_mechanicjob:syncVehicleBodyCL', function(plate)
    RefreshVehicleDamage(vehicleData[plate].entity, plate)
end)

function GetBodyRepairProgression(vehicleEntity)
	print(vehicleEntity)
    if DoesEntityExist(vehicleEntity) then
        local numWheels = GetVehicleNumberOfWheels(vehicleEntity)
        local numDoors = (GetNumberOfVehicleDoors(vehicleEntity) - 2)
        local plate = GetVehicleNumberPlateText(vehicleEntity):gsub("^%s*(.-)%s*$", "%1")
        local numHood, numTrunk = 0, 0
        local totalValue = numDoors + numWheels + numHood + numTrunk + 2
        numWheels, numDoors = 0, 0
        for i = 0, (GetNumberOfVehicleDoors(vehicleEntity) - 2) - 1 do
            if vehicleData[plate].report.doors[i + 1] == false then
                numDoors = numDoors + 1
            end
        end
        if vehicleData[plate].report.doors[5] == false then
            numHood = numHood + 1
        end
        if vehicleData[plate].report.doors[6] == false then
            numTrunk = numTrunk + 1
        end
        for i = 0, GetVehicleNumberOfWheels(vehicleEntity) - 1 do
            if vehicleData[plate].report.wheels[i + 1] == false then
                numWheels = numWheels + 1
            end
        end
		print(newValue)
		print(totalValue)
        local newValue = numWheels + numDoors + numHood + numTrunk
        return (math.floor((newValue / totalValue) * 100))
    end
end

function SpawnJackProp(vehicle)
    local heading = GetEntityHeading(vehicle)
    local objPos = GetEntityCoords(vehicle)
    carJackObj = CreateObject(GetHashKey("prop_carjack"), objPos.x, objPos.y, objPos.z - 0.95, true, true, true)
    SetEntityHeading(carJackObj, heading)
    FreezeEntityPosition(carJackObj, true)
end

function GetControlOfEntity(entity)
    local netTime = 15
    NetworkRequestControlOfEntity(entity)
    while not NetworkHasControlOfEntity(entity) and netTime > 0 do
        NetworkRequestControlOfEntity(entity)
        Citizen.Wait(100)
        netTime = netTime - 1
    end
end

RegisterNetEvent('t1ger_mechanicjob:JobDataCL')
AddEventHandler('t1ger_mechanicjob:JobDataCL', function(data)
    Config.NPC_RepairJobs = data
end)
