Config = {
  Debug = false, -- disable after testing
  Locale = 'en', -- must provide your own locale file (locales directory) if not using 'en'

  UsingESX = true,                      -- using esx?
  DisplayESXHud = false,                 -- display esx hud once inventory has been closed?     
  ESXTriggers = {                       -- triggers to get esx object
    client = "esx:getSharedObject",
    server = "esx:getSharedObject",
  },  

  PickupDistance = 1.0,                -- distance from ground items to be displayed in ground container 
  AllowLocalVehicleInventories = true,  -- allow ped vehicles to have temporary storage? (lasts lifespan of server)
  BagsOfHolding = false,                -- allow container items to stack within one another? Potentially infinite inventory space if you enable this.
  ShowGroundItems = true,               -- display marker above ground items?
  MakeAmmoUsable = true,                -- auto generate usable ammo item function for all weapons?
  AddAmmoClips = 1,                     -- if above is true, using an ammo item will add weapons clip size in ammo, multiplied by this value.

  DegradeItems = true,   -- degrade all items over time?
  TimeToDegrade = 60,    -- seconds
  DegradeQuality = 0.1,  -- remove from quality after TimeToDegrade

  -- Check readme for information.
  ContainerItems = {
    basic_tools = {
      maxSlots = 5,
      maxWeight = 20.0,
    },
    backpack = {
      maxSlots = 20,
      maxWeight = 50.0,
    }
  },

  -- Items that close inventory on use.
  CloseOnUse = {
    lockpick = true,
    thermite = true,
    laptop = true,
    badge = true,
    mechanic_tools = true
  },

  -- Cash account name, for shops.
  CashAccountName = 'money',

  -- ESX accounts to display in inventory.
  DisplayAccounts = {
    'money',
    'black_money'
  },

  -- Default values for inventories.
  Defaults = {
    MaxWeights = {
      player          = 150.0,
      vehicleGloveBox = 20.0,
      vehicleTrunk    = 50.0,
      ground          = 5000.0,
    },

    MaxSlots = {
      player          = 30,
      vehicleGloveBox = 20,
      vehicleTrunk    = 40,
      ground          = 500,
    },
  },

  -- Degrade modifiers, responsible for modifying the levels of item degradation based on their parent container subtypes.
  -- NOTE: Can use item names if they're also "ContainerItems" (see above), e.g: "backpack" (see below).
  DegradeModifiers = {
    --[[
    player = {                  -- inventory subtype
      degradeModifier = 1.0,    -- degrade all items by their default value multiplied by this value.
    },
    vehicleGloveBox = {
      degradeModifier = 1.0,
    },
    vehicleTrunk = {
      degradeModifier = 1.0, 
    },
    ground = {
      degradeModifier = 20.0,  
      degradeItems = {
        'water_bottle',
        'sandwich'
      } 
    },
    fridge = {
      degradeModifier = 0.0,    -- degrade items listed below by their default value multiplied by this value.  
      degradeItems = {          -- inline table of item names to degrade by the above value. All other items will degrade by their default values.    
        'water_bottle', 
        'sandwich'
      }
    },
    gunsafe = {
      degradeModifier = 0.5,
      degradeItems = {
        'weapon_smg',
        'weapon_assaultrifle'
      }
    },
    backpack = {
      degradeModifier = 1.5,    -- degrade all items by their default value multiplied by this value, except the listed ones below.
      ignoreItems = {           -- these items will degrade by their default value, while all others in this inventory will degrade by the above value.
        'weapon_smg'
      }
    }
    --]]
  },

  Shops = {
    -- Example shop:
    --
    {
      identifier = "general_store:1",        -- Must be unique
      type = "shop",                        -- Must be "shop"
      label = "shop",                       -- Label for translation in NUI
      maxSlots = 25,                        -- Max slots, somewhat irrelevant. Ensure its more than your number of items for sale
      buyAccounts = {                       -- Accounts that you can buy items with 
        'money'
      },
      sellAccount = 'black_money',          -- Account that you receive money into when selling an item                      
      items = {
        {
          name = "bread",
          label = "Sandwich",
          price = 25,
          weight = 1.0,
        },
        {
          name = "water",
          label = "Water",
          price = 5,
          weight = 1.0,
        },
        {
          name = "cocacola",
          label = "Coca Cola",
          price = 10,
          weight = 1.0,
        },
        {
          name = "weapon_petrolcan",
          label = "Petrol Can",
          price = 100,
          weight = 30.0,
        }
      }
    },
    {
      identifier = "general_store:2",        -- Must be unique
      type = "shop",                        -- Must be "shop"
      label = "shop",                       -- Label for translation in NUI
      maxSlots = 25,                        -- Max slots, somewhat irrelevant. Ensure its more than your number of items for sale
      buyAccounts = {                       -- Accounts that you can buy items with 
        'money'
      },
      sellAccount = 'money',          -- Account that you receive money into when selling an item                      
      items = {
        {
          name = "bread",
          label = "Sandwich",
          price = 25,
          weight = 1.0,
        },
        {
          name = "water",
          label = "Water",
          price = 5,
          weight = 1.0,
        },
        {
          name = "cocacola",
          label = "Coca Cola",
          price = 10,
          weight = 1.0,
        },
        {
          name = "weapon_petrolcan",
          label = "Petrol Can",
          price = 100,
          weight = 30.0,
        },
        {
          name = "fishingrod",
          label = "Fishing Rod",
          price = 2000,
          weight = 2.0,
        },
        {
          name = "fish",
          label = "Fish (1lb)",
          buyPrice = 100,
          weight = 1.0,
        }
      }
    },
    {
      identifier = "pd_armory:1",        -- Must be unique
      type = "shop",                        -- Must be "shop"
      label = "Armory",                       -- Label for translation in NUI
      maxSlots = 25,                        -- Max slots, somewhat irrelevant. Ensure its more than your number of items for sale
      buyAccounts = {                       -- Accounts that you can buy items with 
        'money'
      },
      sellAccount = 'black_money',          -- Account that you receive money into when selling an item                      
      items = {
        {
          name = "WEAOPN_PISTOL50",
          label = "Police . 50",
          price = 1000,
          weight = 1.0,
        },
        {
          name = "WEAPON_STUNGUN",
          label = "Police Taser",
          price = 250,
          weight = 1.0,
        },
        {
          name = "WEAPON_ASSAULTRIFLE",
          label = "Assault Rifle",
          price = 10,
          weight = 1.0,
        },
        {
          name = "disc_ammo_pistol_large",
          label = "Pistol Ammo Large",
          price = 100,
          weight = 10.0,
        },
        {
          name = "disc_ammo_rifle",
          label = "Rifle Ammo",
          price = 200,
          weight = 10.0,
        }
      }
    },
    {
      identifier = "illegal_Hide:1",        -- Must be unique
      type = "shop",                        -- Must be "shop"
      label = "",                       -- Label for translation in NUI
      maxSlots = 25,                        -- Max slots, somewhat irrelevant. Ensure its more than your number of items for sale
      buyAccounts = {                       -- Accounts that you can buy items with 
        'money'
      },
      sellAccount = 'money',          -- Account that you receive money into when selling an item                      
      items = {
        {
          name = "leather_deer_bad",
          label = "Bad deer pelt",
          buyPrice = 300,
          weight = 1.0,
        },
        {
          name = "leather_deer_good",
          label = "Good deer pelt",
          buyPrice = 500,
          weight = 1.0,
        },
        {
          name = "leather_deer_perfect",
          label = "Perfect deer pelt",
          buyPrice = 1500,
          weight = 1.0,
        },
        {
          name = "leather_boar_bad",
          label = "Bad boar leather",
          buyPrice = 100,
          weight = 1.0,
        },
        {
          name = "leather_boar_good",
          label = "Good boar leather",
          buyPrice = 200,
          weight = 1.0,
        },
        {
          name = "leather_boar_perfect",
          label = "Perfect boar leather",
          buyPrice = 700,
          weight = 1.0,
        },
        {
          name = "leather_mlion_bad",
          label = "Bad mountain lion leather",
          buyPrice = 500,
          weight = 1.0,
        },
        {
          name = "leather_mlion_good",
          label = "Good mountain lion leather",
          buyPrice = 1200,
          weight = 1.0,
        },
        {
          name = "leather_mlion_perfect",
          label = "Perfect mountain lion leather",
          buyPrice = 3000,
          weight = 1.0,
        },
        {
          name = "leather_coyote_bad",
          label = "Bad coyote leather",
          buyPrice = 200,
          weight = 1.0,
        },
      }
    },
    {
      identifier = "ammunationStore:1",        -- Must be unique
      type = "shop",                        -- Must be "shop"
      label = "",                       -- Label for translation in NUI
      maxSlots = 25,                        -- Max slots, somewhat irrelevant. Ensure its more than your number of items for sale
      buyAccounts = {                       -- Accounts that you can buy items with 
        'money'
      },
      sellAccount = 'money',          -- Account that you receive money into when selling an item                      
      items = {
        {
          name = "WEAPON_KNUCKLE",
          label = "Knuckle Dusters",
          price = 300,
          weight = 1.0,
        },
        {
          name = "WEAPON_PISTOL",
          label = "Pistol",
          price = 3000,
          weight = 1.0,
        },
        {
          name = "disc_ammo_pistol",
          label = "Pistol Ammo",
          price = 200,
          weight = 1.0,
        },
      }
    },
    {
      identifier = "ammunationHuntingStore:1",        -- Must be unique
      type = "shop",                        -- Must be "shop"
      label = "",                       -- Label for translation in NUI
      maxSlots = 25,                        -- Max slots, somewhat irrelevant. Ensure its more than your number of items for sale
      buyAccounts = {                       -- Accounts that you can buy items with 
        'money'
      },
      sellAccount = 'money',          -- Account that you receive money into when selling an item                      
      items = {
        {
          name = "WEAPON_SNIPERRIFLE",
          label = "Hunting Rifle",
          price = 5000,
          weight = 1.0,
        },
        {
          name = "WEAPON_KNIFE",
          label = "Hunting Knife",
          price = 300,
          weight = 1.0,
        },
        {
          name = "disc_ammo_snp",
          label = "Hunting Rifle Ammo",
          price = 500,
          weight = 1.0,
        },
        {
          name = "animal_bait",
          label = "Animal Bait",
          price = 150,
          weight = 1.0,
        },
      }
    }
    --]]
  },

  CraftingRecipes = {
    -- Example recipe:
    --[[
    example_recipe = {
      type = "crafting",                  -- Must be "crafting"
      label = "crafting",                 -- Label for translation in NUI
      recipes = {
        { 
          name = "lockpick",              -- Item name (database name/esx item name)
          label = "Lockpick Set",         -- Label for item
          count = 5,                      -- Count of item created by recipe
          quality = 90,                   -- Quality of item (pre-degraded value) (0-100, 0 = full degrade, 100 = not degraded)
          weight = 1.0,                   -- Weight of item (database weight)
          required = {
            {
              name = "scrap_metal",       -- Required item name (database name/esx item name)
              label = "Scrap Metal",      -- Label for item
              count = 5,                  -- Count of required item
              keep = false,               -- Keep this item when crafting?
            },
            {
              name = "scrap_aluminum",
              label = "Scrap Alumnium",
              count = 1
            },
            {
              name = "basic_tools",
              label = "Basic Tools",
              count = 1,
              keep = true, 
            },
          }   
        },
        {
          name = "basic_tools",
          label = "Basic Tools",
          count = 1,
          quality = 50,
          weight = 1.0,                   
          required = {
            {
              name = "scrap_metal",
              label = "Scrap Metal",
              count = 5
            },
          }   
        },
      }
    }
    --]]
  },

  VehicleClassDefaults = {
    [0] = {
      name = 'compacts',        -- Should match your database 'vehicles_categories' table.
      gloveBox = {
        maxSlots = 10,          -- Max slot count for this vehicle types glovebox.
        maxWeight = 50.0,       -- Max weight for this vehicle types glovebox.
      },
      trunk = {
        maxSlots = 50,          -- Max slot count for this vehicle types trunk.
        maxWeight = 300.0,      -- Max weight for this vehicle types trunk.
      },
    },
    [1] = {
      name = 'sedans',
      gloveBox = {
        maxSlots = 10,        
        maxWeight = 50.0,      
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 300.0,       
      },
    },
    [2] = {
      name = 'suvs',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 400.0,       
      },
    },
    [3] = {
      name = 'coupes',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 300.0,       
      },
    },
    [4] = {
      name = 'muscle',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 300.0,       
      },
    },
    [5] = {
      name = 'sportsclassics',
      glovebox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 300.0,       
      },
    },
    [6] = {
      name = 'sports',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 300.0,       
      },
    },
    [7] = {
      name = 'super',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 300.0,       
      },
    },
    [8] = {
      name = 'motorcycles',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 150.0,       
      },
    },
    [9] = {
      name = 'offroad',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 300.0,       
      },
    },
    [10] = {
      name = 'industrial',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 300.0,       
      }, 
    },
    [11] = {
      name = 'utility',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 300.0,       
      },
    },
    [12] = {
      name = 'vans',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 300.0,       
      },
    },
    [13] = {
      name = 'cycles',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 50.0,       
      },
    },
    [14] = {
      name = 'boats',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 150.0,       
      },
    },
    [15] = {
      name = 'helicopters',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 150.0,       
      },
    },
    [16] = {
      name = 'planes',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 150.0,       
      },
    },
    [17] = {
      name = 'services',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 150.0,       
      },
    },
    [18] = {
      name = 'emergency',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 150.0,       
      },
    },
    [19] = {
      name = 'military',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 150.0,       
      },
    },
    [20] = {
      name = 'commercial',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 150.0,       
      },
    },
    [21] = {
      name = 'trains',
      gloveBox = {
        maxSlots = 10,           
        maxWeight = 50.0,       
      },
      trunk = {
        maxSlots = 50,           
        maxWeight = 150.0,       
      },
    },
  },

  Weapons = {
    'WEAPON_PISTOL',
    'WEAPON_COMBATPISTOL',
    'WEAPON_APPISTOL',
    'WEAPON_PISTOL50',
    'WEAPON_SNSPISTOL',
    'WEAPON_HEAVYPISTOL',
    'WEAPON_VINTAGEPISTOL',
    'WEAPON_MACHINEPISTOL',
    'WEAPON_SMG',
    'WEAPON_ASSAULTSMG',
    'WEAPON_MICROSMG',
    'WEAPON_MINISMG',
    'WEAPON_COMBATPDW',
    'WEAPON_PUMPSHOTGUN',
    'WEAPON_SAWNOFFSHOTGUN',
    'WEAPON_ASSAULTSHOTGUN',
    'WEAPON_BULLPUPSHOTGUN',
    'WEAPON_HEAVYSHOTGUN',
    'WEAPON_ASSAULTRIFLE',
    'WEAPON_CARBINERIFLE',
    'WEAPON_ADVANCEDRIFLE',
    'WEAPON_SPECIALCARBINE',
    'WEAPON_BULLPUPRIFLE',
    'WEAPON_COMPACTRIFLE',
    'WEAPON_MG',
    'WEAPON_COMBATMG',
    'WEAPON_GUSENBERG',
    'WEAPON_SNIPERRIFLE',
    'WEAPON_HEAVYSNIPER',
    'WEAPON_MARKSMANRIFLE',
    'WEAPON_MINIGUN',
    'WEAPON_RAILGUN',
    'WEAPON_STUNGUN',
    'WEAPON_RPG',
    'WEAPON_HOMINGLAUNCHER',
    'WEAPON_GRENADELAUNCHER',
    'WEAPON_COMPACTLAUNCHER',
    'WEAPON_FLAREGUN',
    'WEAPON_FIREEXTINGUISHER',
    'WEAPON_PETROLCAN',
    'WEAPON_FIREWORK',
    'WEAPON_FLASHLIGHT',
    'GADGET_PARACHUTE',
    'WEAPON_KNUCKLE',
    'WEAPON_HATCHET',
    'WEAPON_MACHETE',
    'WEAPON_SWITCHBLADE',
    'WEAPON_BOTTLE',
    'WEAPON_DAGGER',
    'WEAPON_POOLCUE',
    'WEAPON_WRENCH',
    'WEAPON_BATTLEAXE',
    'WEAPON_KNIFE',
    'WEAPON_NIGHTSTICK',
    'WEAPON_HAMMER',
    'WEAPON_BAT',
    'WEAPON_GOLFCLUB',
    'WEAPON_CROWBAR',
    'WEAPON_GRENADE',
    'WEAPON_SMOKEGRENADE',
    'WEAPON_STICKYBOMB',
    'WEAPON_PIPEBOMB',
    'WEAPON_BZGAS',
    'WEAPON_MOLOTOV',
    'WEAPON_PROXMINE',
    'WEAPON_SNOWBALL',
    'WEAPON_BALL',
    'WEAPON_FLARE',
    'WEAPON_REVOLVER',
    'WEAPON_MARKSMANPISTOL',
    'WEAPON_DOUBLEACTION',
    'WEAPON_DBSHOTGUN',
    'WEAPON_AUTOSHOTGUN',
    'WEAPON_MUSKET',
  },
}

-- No touch
local __weapons = {}
for k,v in ipairs(Config.Weapons) do
  __weapons[v:lower()] = true
end
Config.Weapons = __weapons
__weapons = nil

local __modifiers = {}
for k,v in pairs(Config.DegradeModifiers) do
  __modifiers[k] = {}
  if type(v.degradeItems) == "table" then
    __modifiers[k]["degrade"] = {}
    for _,name in ipairs(v.degradeItems) do
      __modifiers[k]["degrade"][name] = true
    end
  end

  if type(v.ignoreItems) == "table" then
    __modifiers[k]["ignore"] = {}
    for _,name in ipairs(v.ignoreItems) do
      __modifiers[k]["ignore"][name] = true
    end
  end
end

for k,v in pairs(__modifiers) do
  Config.DegradeModifiers[k].degradeItems = v.degrade
  Config.DegradeModifiers[k].ignoreItems  = v.ignore
end

if Config.UsingESX then
  if not IsDuplicityVersion() then
    TriggerEvent(Config.ESXTriggers.client,function(obj) ESX = obj; end)
  else
    TriggerEvent(Config.ESXTriggers.server,function(obj) ESX = obj; end)
  end
end