Config                            = {}
Config.DrawDistance               = 100.0
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.EnableVaultManagement      = true
Config.EnableHelicopters          = true
Config.EnableMoneyWash            = true
Config.MaxInService               = -1
Config.Locale                     = 'en'
Config.MissCraft                  = 10 -- %

Config.AuthorizedVehicles = {
    { name = 'stretch',  label = 'VIP Limousine' },
}

Config.Blips = {
    
    Blip = {
      Pos     = { x = 923.72, y = 47.12, z = 81.11 },
      Sprite  = 617,
      Display = 4,
      Scale   = 0.8,
      Colour  = 27,
    },

}

Config.Zones = {

    Cloakrooms = {
        Pos   = { x = 1118.08, y = 252.08, z = -46.84 },
        Size  = { x = 1.5, y = 1.5, z = 0.5 },
        Color = { r = 255, g = 187, b = 255 },
        Type  = 1,
    },

    Fridge = {
        Pos   = { x = 1113.09, y = 206.79, z = -50.44 },
        Size  = { x = 1.6, y = 1.6, z = 0.5 },
        Color = { r = 248, g = 248, b = 255 },
        Type  = 1,
    },

    Vehicles = {
        Pos          = { x = 920.07, y = 41.6, z = 80.1 },
        SpawnPoint   = { x = 918.2, y = 50.36, z = 80.9 },
        Size         = { x = 1.8, y = 1.8, z = 0.5 },
        Color        = { r = 255, g = 255, b = 0 },
        Type         = 1,
        Heading      = 331.09,
    },

    VehicleDeleters = {
        Pos   = { x = 922.76, y = 57.51, z = 79.9 },
        Size  = { x = 3.0, y = 3.0, z = 0.5 },
        Color = { r = 255, g = 255, b = 0 },
        Type  = 1,
    },

    Helicopters = {
        Pos          = { x = 978.33, y = 54.79, z = 123.28 },
        SpawnPoint   = { x = 965.83, y = 42.13, z = 123.13 },
        Size         = { x = 1.8, y = 1.8, z = 1.0 },
        Color        = { r = 0, g = 0, b = 255 },
        Type         = 34,
        Heading      = 325.12,
    },

    HelicopterDeleters = {
        Pos   = { x = 965.83, y = 42.13, z = 122.13 },
        Size  = { x = 12.0, y = 12.0, z = 0.3 },
        Color = { r = 0, g = 255, b = 0 },
        Type  = 1,
    },

    BossActions = {
        Pos   = { x = 1112.77, y = 241.65, z = -46.83 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 1,
    },
	
	Vaults = {
        Pos   = { x = 1108.7, y = 249.7, z = -46.84 },
        Size  = { x = 1.3, y = 1.3, z = 0.5 },
        Color = { r = 30, g = 144, b = 255 },
        Type  = 1,
    },

-----------------------
-------- BARS --------

    MainBar1 = {
        Pos   = { x = 1110.59, y = 207.1, z = -50.44 },
        Size  = { x = 1.4, y = 1.4, z = 0.5 },
        Color = { r = 255, g = 187, b = 255 },
        Type  = 1,
        Items = {
            { name = 'jager',      label = _U('jager'),   price = 3 },
            { name = 'vodka',      label = _U('vodka'),   price = 4 },
            { name = 'rhum',       label = _U('rhum'),    price = 2 },
            { name = 'whisky',     label = _U('whisky'),  price = 7 },
            { name = 'tequila',    label = _U('tequila'), price = 2 },
            { name = 'martini',    label = _U('martini'), price = 5 }
        },
    },
	
	MainBar2 = {
        Pos   = { x = 1111.81, y = 209.73, z = -50.44 },
        Size  = { x = 1.4, y = 1.4, z = 0.5 },
        Color = { r = 255, g = 187, b = 255 },
        Type  = 1,
        Items = {
            { name = 'jager',      label = _U('jager'),   price = 3 },
            { name = 'vodka',      label = _U('vodka'),   price = 4 },
            { name = 'rhum',       label = _U('rhum'),    price = 2 },
            { name = 'whisky',     label = _U('whisky'),  price = 7 },
            { name = 'tequila',    label = _U('tequila'), price = 2 },
            { name = 'martini',    label = _U('martini'), price = 5 }
        },
    },

}

-----------------------
----- TELEPORTERS -----

Config.TeleportZones = {

  EnterHeliport = {
    Pos       = { x = 927.34, y = 53.07, z = 80.1 },
    Size      = { x = 2.0, y = 2.0, z = 0.5 },
    Color     = { r = 204, g = 204, b = 0 },
    Marker    = 1,
    Hint      = _U('e_to_enter_2'),
    Teleport  = { x = 970.99, y = 59.26, z = 120.24 },
  },

  ExitHeliport = {
    Pos       = { x = 970.99, y = 59.26, z = 119.24 },
    Size      = { x = 2.0, y = 2.0, z = 0.5 },
    Color     = { r = 204, g = 204, b = 0 },
    Marker    = 1,
    Hint      = _U('e_to_exit_2'),
    Teleport  = { x = 927.34, y = 53.07, z = 80.1 },
  },
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
  barman_outfit = {
    male = {
        ['tshirt_1'] = 6,  ['tshirt_2'] = 0,
        ['torso_1'] = 40,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 11,
        ['pants_1'] = 26,   ['pants_2'] = 2,
        ['shoes_1'] = 10,   ['shoes_2'] = 0,
        ['chain_1'] = 18,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 8,    ['torso_2'] = 2,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 5,
        ['pants_1'] = 44,   ['pants_2'] = 4,
        ['shoes_1'] = 0,    ['shoes_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 2
    }
  },
}
