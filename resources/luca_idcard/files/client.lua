

local open = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)



RegisterNetEvent('luca_idcard:open')
AddEventHandler('luca_idcard:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

RegisterNetEvent('luca_idcard:useId')
AddEventHandler('luca_idcard:useId', function()
	local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then
			  TriggerServerEvent('luca_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'idcard')
			else
			  ESX.ShowNotification(Config.Nearby)
			end	
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if Config.EnableMenuHotkey then
			if IsControlJustReleased(0, Config.Hotkey) then
				openMenu()
			end
		end
	end
end)

RegisterCommand(Config.Command, function()
	if Config.EnableMenu then
		openMenu()
	end
end)

function openMenu()
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'id_card_menu',
	  {
		  title    = Config.MenuTitle,
		  elements = {
			  {label = 'View IDs', value = 'check'},
			  {label = 'Show IDs', value = 'show'}
		  }
	  },
	  function(data, menu)		  
		  if data.current.value == 'check' then
			openCheckMenu()
		  elseif data.current.value == 'show' then
			openShowMenu()
		  end
	  end,
	  function(data, menu)
		  menu.close()
	  end
  )
  end

function openCheckMenu()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'id_check_menu',
		{
			title    = Config.CheckMenuTitle,
			elements = Config.CheckElements
		},
		function(data, menu)		  
			TriggerServerEvent('luca_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), data.current.value)
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function openShowMenu()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'id_show_menu',
		{
			title    = Config.ShowMenuTitle,
			elements = Config.ShowElements
		},
		function(data, menu)
			local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then
			  TriggerServerEvent('luca_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), data.current.value)
			else
			  ESX.ShowNotification(Config.Nearby)
			end		end,
		function(data, menu)
			menu.close()
		end
	)
end
