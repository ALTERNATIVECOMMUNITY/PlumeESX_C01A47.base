local notified = false
local lastNotified = 0

local banks = {
	{name="Bank", id=108, x=150.266, y=-1040.203, z=29.374},
	{name="Bank", id=108, x=-1212.980, y=-330.841, z=37.787},
	{name="Bank", id=108, x=-2962.582, y=482.627, z=15.703},
	{name="Bank", id=108, x=-112.202, y=6469.295, z=31.626},
	{name="Bank", id=108, x=314.187, y=-278.621, z=54.170},
	{name="Bank", id=108, x=-351.534, y=-49.529, z=49.042},
	{name="Bank", id=106, x=241.727, y=220.706, z=106.286},
	{name="Bank", id=108, x=1175.0643310547, y=2706.6435546875, z=38.094036102295}
}	

local bModels = {
    [-1126237515] = true,
    [506770882] = true,
    [-1364697528] = true,
    [-870868698] = true,
}

local function nearBank()
	local player = PlayerPedId()
	local playerloc = GetEntityCoords(player, 0)
	
	for _, search in pairs(banks) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		
		if distance <= 3 then
			return true
		end
	end

    return false
end

function nearATM()
	local ply = PlayerPedId()
	local pos = GetEntityCoords(ply, 0)
  
	for k,v in pairs(bModels) do
		ATMObject = GetClosestObjectOfType(pos, 0.6, k, false)
  
		if DoesEntityExist(ATMObject) then
			return true
		end
	end
	return false
end

RegisterCommand("openatm", function()
	if (nearATM() or nearBank() and not bMenuOpen) then
		ToggleUI()
	end
end)

RegisterKeyMapping("openatm", "Open ATM", "keyboard", "e")

RegisterNetEvent("TropixRP:Bank:ExtNotify")
AddEventHandler("TropixRP:Bank:ExtNotify", function(msg)
	if (not msg or msg == "") then return end

	exports['mythic_notify']:DoLongHudText('inform', msg, { ['background-color'] = "#4086EB", ['color'] = '#fff' })
end)

--[[ Show Things ]]--
Citizen.CreateThread(function()
	for k,v in ipairs(banks) do
	  local blip = AddBlipForCoord(v.x, v.y, v.z)
	  SetBlipSprite(blip, v.id)
	  SetBlipDisplay(blip, 4)
	  SetBlipScale  (blip, 0.9)
	  SetBlipColour (blip, 2)
	  SetBlipAsShortRange(blip, true)
	  BeginTextCommandSetBlipName("STRING")
	  AddTextComponentString(tostring(v.name))
	  EndTextCommandSetBlipName(blip)
	end
end)