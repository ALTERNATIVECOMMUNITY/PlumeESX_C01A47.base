--[[
==========================================================================================================================
	PAY ATTENTION WHEN SETTING EVERYTHING, IF YOU BREAK ANYTHING DOWNLOAD THE ORIGINAL SETTING BACK AND TRY AGAIN
==========================================================================================================================
	To change the placement of the HUD open style.css and change the values ​​in lines 322 and 448
]]

Config = {}

Config.webhook = "WEBHOOK"						-- Webhook to send logs for discord
Config.lang = "en"								-- Set the file language [en/br]

Config.ESX = {									-- ESX settings, if you are using vRP, ignore
	['ESXSHAREDOBJECT'] = "esx:getSharedObject",-- Change your getshared object event here if you are using anti-cheat
}

Config.format = {
	['currency'] = 'USD',						-- This is the currency format, so your currency symbol appears correctly [Examples: BRL, USD]
	['location'] = 'en-US'						-- This is your country location, to format the decimal places according to your pattern [Examples: pt-BR, en-US]
}

Config.command = "status"						-- Command to open the menu (Event to open the menu if you want to trigger it from somewhere: TriggerEvent ('advanced_vehicles: showStatusUI'))
Config.Jobs = {'mechanic', 'police'}			-- Jobs to perform actions in menu (set to false to disable permission)
Config.UseT1gerMechanic = false                  -- If set to true Vehicles will use the CarJack (toolbox) and Lift (mechanic_toolbox) from the t1ger_mechanic script. Look at the Readme for using this

Config.allVehicles = false						-- true: only cars will be available / false: all vehicles will be available
Config.itemToInspect = "scanner"				-- Item required to inspect vehicles

Config.NitroAmount = 100						-- Amount of nitro for each charge
Config.NitroRechargeTime = 60					-- Nitro recharge time
Config.NitroRechargeAmount = 5					-- Quantity of loads
-- You can set 2 keys for nitro
Config.NitroKey1 = 19 	-- ALT
Config.NitroKey2 = 210 	-- CTRL

Config.oil = "oil"								-- Oil index configured in Config.maintenance
-- Config for car services
Config.maintenance = {
	['default'] = { -- default means if you don't have a setting for the specific vehicle, it will default to
		['oil'] = {								-- Index
			['lifespan'] = 1500,				-- Number of KMs until the car needs service
			['damage'] = {
				['type'] = 'engine',			-- Damage type: engine: this will damage the vehicle's engine
				['amount_per_km'] = 0.0001,		-- This is the base value (in percentage) that the car will suffer damage for every km it runs [maximum engine health is 1000, so 0.0001 of 1000 is 0.1 | The maximum value for handling is obtained from the vehicle's handling.meta file]
				['km_threshold'] = 100,			-- This is the limit to increase the multiplier, so the multiplier will increase each time the player passes this km [Set this value to 99999 if you don't want the multiplier to work]
				['multiplier'] = 1.2,			-- This is the damage multiplier, this value will cause the car to take even more damage after the player has used the car longer [This value cannot be less than 1.0 | Set this value to 1.0 if you don't want the multiplier to work]
				['min'] = 0,					-- This is the minimum value that the piece's health can reach when taking damage.
				['destroy_engine'] = false		-- Will cause the car to stop running if the engine reaches the minimum value [applicable only when type = engine]
			},
			['repair_item'] = {
				['name'] = 'oil',				-- Item to do the car service
				['amount'] = 2,					-- Quantity of items
				['time'] = 10					-- repair time
			},
			['interface'] = {
				['name'] = 'Motor oil',					-- Interface name
				['icon_color'] = '#ffffff00',				-- Background color in interface
				['icon'] = 'images/maintenance/oil.png',	-- Image
				['description'] = 'You must always have a new, clean oil to keep your engine running.',	-- Description
				['index'] = 0								-- This index means that items are ordered in the interface, 0 will be first, 1...
			}
		},
		['tires'] = {
			['lifespan'] = 5000,
			['damage'] = {
				['type'] = 'CHandlingData',			-- This will damage the physics of the vehicle (handling.meta)
				['handId'] = 'fTractionCurveMax',	-- Index on handling.meta
				['amount_per_km'] = 0.0001,			-- By setting 0.0001 (in quantity_per_km), 100 (in km limit) and 1.2 (in multiplier), the car will run approximately 1,300 km before reaching the minimum value
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0.5
			},
			['repair_item'] = {
				['name'] = 'tires',
				['amount'] = 4,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Pneus',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/tires.png',
				['description'] = 'Tires are used to keep your vehicle straight, worn tires will make your vehicle skidding easier',
				['index'] = 1
			}
		},
		['brake_pads'] = {
			['lifespan'] = 4000,
			['damage'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fBrakeForce',
				['amount_per_km'] = 0.0001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0.1
			},
			['repair_item'] = {
				['name'] = 'brake_pads',
				['amount'] = 4,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'brake pad',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/brake_pads.png',
				['description'] = 'Brake pads are useful to make your car stop during deceleration.',
				['index'] = 2
			}
		},
		['transmission_oil'] = {
			['lifespan'] = 30000,
			['damage'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fInitialDriveMaxFlatVel',
				['amount_per_km'] = 0.0001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 100.0
			},
			['repair_item'] = {
				['name'] = 'transmission_oil',
				['amount'] = 2,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'transmission oil',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/transmission_oil.png',
				['description'] = 'You must keep your oil clean for your transmission to work.',
				['index'] = 3
			}
		},
		['shock_absorber'] = {
			['lifespan'] = 10000,
			['damage'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fSuspensionForce',
				['amount_per_km'] = 0.0001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0.1
			},
			['repair_item'] = {
				['name'] = 'shock_absorber',
				['amount'] = 4,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'shock absorber',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/shocks.png',
				['description'] = 'Your suspension depends on a good shock absorber.',
				['index'] = 4
			}
		},
		['clutch'] = {
			['lifespan'] = 35000,
			['damage'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fClutchChangeRateScaleUpShift',
				['amount_per_km'] = 0.0001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0.1
			},
			['repair_item'] = {
				['name'] = 'clutch',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Clutch',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/clutch.png',
				['description'] = 'Clutch speed in gear changes',
				['index'] = 5
			}
		},
		['air_filter'] = {
			['lifespan'] = 10000,
			['damage'] = {
				['type'] = 'engine',
				['amount_per_km'] = 0.00005,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0,
				['destroy_engine'] = false
			},
			['repair_item'] = {
				['name'] = 'air_filter',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Air filter',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/air_filter.png',
				['description'] = 'Your engine needs to breathe through a new air filter',
				['index'] = 6
			}
		},
		['fuel_filter'] = {
			['lifespan'] = 10000,
			['damage'] = {
				['type'] = 'engine',
				['amount_per_km'] = 0.00005,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0,
				['destroy_engine'] = false
			},
			['repair_item'] = {
				['name'] = 'fuel_filter',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Fuel filter',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/fuel_filter.png',
				['description'] = 'The name speaks volumes for the function: to prevent the passage of dirt from the vehicles tank to the engine',
				['index'] = 7
			}
		},
		['spark_plugs'] = {
			['lifespan'] = 15000,
			['damage'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fInitialDriveForce',
				['amount_per_km'] = 0.0001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0
			},
			['repair_item'] = {
				['name'] = 'spark_plugs',
				['amount'] = 4,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Spark plugs',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/spark_plugs.png',
				['description'] = 'Spark plugs are needed to generate the energy needed for the engine to work properly',
				['index'] = 8
			}
		},
		['serpentine_belt'] = {
			['lifespan'] = 20000,
			['damage'] = {
				['type'] = 'engine',
				['amount_per_km'] = 0.001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0,
				['destroy_engine'] = true
			},
			['repair_item'] = {
				['name'] = 'serpentine_belt',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'timing belt',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/serpentine_belt.png',
				['description'] = 'The timing belt coordinates the opening and closing of the engine valves, as well as the movement of the pistons in the cylinder and crankshaft',
				['index'] = 9
			}
		},
	},
	--[[['panto'] = {	-- If you enable this, the panto car will have these settings
		['example'] = {
			['lifespan'] = 999,
			['damage'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fInitialDriveForce',
				['amount_per_km'] = 0.0001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0
			},
			['repair_item'] = {
				['name'] = 'example',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Example',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/example.png',
				['description'] = 'Example',
				['index'] = 9
			}
		},
	}]]
}

-- Upgrades availables
Config.upgrades = {
	['default'] = {
		['susp'] = {	-- Index
			['improvements'] = {
				['type'] = 'CHandlingData',			-- CHandlingData: will affect vehicle physics
				['handId'] = 'fSuspensionRaise',	-- The index in handling.meta
				['value'] = -0.2,					-- Changing value
				['fixed_value'] = false				-- This means whether the value will be relative or absolute (fixed)
			},
			['item'] = {
				['name'] = 'susp',					-- Item required to update
				['amount'] = 1,						-- Quantity of items
				['time'] = 10						-- Time
			},
			['interface'] = {
				['name'] = 'Very low suspension',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/susp.png',
				['description'] = 'Exchange the suspension for an extremely reduced set. Suitable for pickup trucks and tall vehicles only',
				['index'] = 0
			},
			['class'] = 'suspension'
		},
		['susp1'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fSuspensionRaise',
				['value'] = -0.1,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'susp1',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'low suspension',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/susp1.png',
				['description'] = 'Installs a set of short springs to lower the vehicle to the extreme. It can make your vehicle unstable. Not suitable for low vehicles',
				['index'] = 1
			},
			['class'] = 'suspension'
		},
		['susp2'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fSuspensionRaise',
				['value'] = -0.05,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'susp2',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'sports suspension',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/susp2.png',
				['description'] = 'Installs a sport spring to reduce vehicle height. Not suitable for vehicles that are already low',
				['index'] = 2
			},
			['class'] = 'suspension'
		},
		['susp3'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fSuspensionRaise',
				['value'] = 0.1,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'susp3',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Comfortable suspension',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/susp3.png',
				['description'] = 'Slightly increases the height of the suspension to give more comfort and safety to passengers',
				['index'] = 3
			},
			['class'] = 'suspension'
		},
		['susp4'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fSuspensionRaise',
				['value'] = 0.2,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'susp4',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'high suspension',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/susp4.png',
				['description'] = 'Dramatically raises suspension height for vehicles desiring an offroad adventure',
				['index'] = 4
			},
			['class'] = 'suspension'
		},

		['garett'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fInitialDriveForce',
				['value'] = 0.04,
				['turbo'] = true,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'garett',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Turbo Garett GTW',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/turbo.png',
				['description'] = 'Installs a larger turbine to generate more pressure and admit more cold air into the engine intake, generating more power',
				['index'] = 5
			},
			['class'] = 'turbo'
		},
		['nitrous'] = {
			['improvements'] = {
				['type'] = 'nitrous'	-- Nitro
			},
			['item'] = {
				['name'] = 'nitrous',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Nitro',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/nitrous.png',
				['description'] = 'Nitro increases the amount of oxygen entering the engines cylinders. Its as if, for a few seconds, he expands the engine volume to generate power',
				['index'] = 6
			},
			['class'] = 'nitro'
		},
		['AWD'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fDriveBiasFront',
				['value'] = 0.5,
				['powered_wheels'] = {0,1,2,3},	-- If the update changes fDriveBiasFront, the wheels that will receive power from the vehicle must also be changed
				['fixed_value'] = true
			},
			['item'] = {
				['name'] = 'AWD',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Conversion to AWD',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/awd.png',
				['description'] = 'An AWD transmission means that the engine turns all 4 wheels of your vehicle',
				['index'] = 7
			},
			['class'] = 'differential'
		},
		['RWD'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fDriveBiasFront',
				['value'] = 0.0,
				['powered_wheels'] = {2,3},
				['fixed_value'] = true
			},
			['item'] = {
				['name'] = 'RWD',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Conversion to RWD',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/rwd.png',
				['description'] = 'An RWD transmission means that the engine turns the 2 rear wheels of your vehicle',
				['index'] = 8
			},
			['class'] = 'differential'
		},
		['FWD'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fDriveBiasFront',
				['value'] = 1.0,
				['powered_wheels'] = {0,1},
				['fixed_value'] = true
			},
			['item'] = {
				['name'] = 'FWD',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Conversion to FWD',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/fwd.png',
				['description'] = 'A FWD transmission means that the engine turns the 2 front wheels of your vehicle',
				['index'] = 9
			},
			['class'] = 'differential'
		},

		['semislick'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fTractionCurveMax',
				['value'] = 0.4,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'semislick',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Semi Slick Tires',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/semislick.png',
				['description'] = 'The semi-slick tire is a street homologated tire used to fully exploit the performance of vehicles',
				['index'] = 10
			},
			['class'] = 'tires'
		},
		['slick'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fTractionCurveMax',
				['value'] = 0.8,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'slick',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Slick Tires',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/slick.png',
				['description'] = 'Slick tires, as they are smooth, have a greater area of ​​contact with the ground, thus ensuring better performance',
				['index'] = 11
			},
			['class'] = 'tires'
		},

		['race_brakes'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fBrakeForce',
				['value'] = 2.0,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'race_brakes',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Brembo brakes',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/race_brakes.png',
				['description'] = 'Racing brakes have a much greater braking power and dont overheat like regular brakes.',
				['index'] = 12
			},
			['class'] = 'brakes'
		},
	}
}

-- Repair config
Config.repair = {
	['engine'] = {			-- Part index (do not change)
		['items'] = {		-- Items needed to repair the part
			['piston'] = 4,
			['rod'] = 4,
			['oil'] = 3
		},
		['time'] = 10,		-- time to repair
		['repair'] = {		-- The handling.meta indices that will return to default
			"engine",		-- engine: will fix engine health
			"fInitialDriveForce",
		}
	},
	['transmission'] = {
		['items'] = {
			['gear'] = 5,
			['transmission_oil'] = 2
		},
		['time'] = 10,
		['repair'] = {
			"fClutchChangeRateScaleUpShift"
		}
	},
	['chassis'] = {
		['items'] = {
			['iron'] = 10,
			['aluminum'] = 2
		},
		['time'] = 10,
		['repair'] = {
			"body"		-- body: will fix the chassis health
		}
	},
	['brakes'] = {
		['items'] = {
			['brake_discs'] = 4,
			['brake_pads'] = 4,
			['brake_caliper'] = 2
		},
		['time'] = 10,
		['repair'] = {
			"fBrakeForce"
		}
	},
	['suspension'] = {
		['items'] = {
			['shock_absorber'] = 4,
			['springs'] = 4
		},
		['time'] = 10,
		['repair'] = {
			"fTractionCurveMax",
			"fSuspensionForce"
		}
	}
}

Config.infoTextsPage = {
	[1] = {
		['icon'] = "images/info.png",
		['title'] = "Basic information",
		['text'] = "This is the vehicle maintenance panel. You need to take care of your vehicle to keep it in good condition for use. There are several maintenance items to be done every X KM, for example, the engine oil needs to be changed every 1500 Kms or your engine will start to damage. Other revisions need to be made to a higher KM, take the vehicle to a mechanic so he can inform you of the useful life of your vehicle parts."
	},
	[2] = {
		['icon'] = "images/services.png",
		['title'] = "How to perform reviews",
		['text'] = "You need to carry out preventive maintenance at the correct time, for this, just take the vehicle to a trusted mechanic. He will be able to scan the parts of your car and after passing the scanner he will have the updated information of each part that needs to be replaced.."
	},
	[3] = {
		['icon'] = "images/repair.png",
		['title'] = "Repairs",
		['text'] = "The repair tab is used when any part of your vehicle is losing performance, this happens when maintenance is not performed on the expected date. Repairs are expensive and need to be done, as damaged parts seriously harm your vehicle's performance, so be sure to do any maintenance.."
	},
	[4] = {
		['icon'] = "images/performance.png",
		['title'] = "Upgrades",
		['text'] = "If you want to spice up the experience with your vehicle you can install some performance parts on it, but <b>CAUTION!!</b> The performance parts are extremely powerful and directly affect the physics of your vehicle, so you must choose wisely which part to install or your vehicle may become unstable or even overturn. The mechanic is not responsible for inappropriate upgrades."
	}
}
Config.createTable = false