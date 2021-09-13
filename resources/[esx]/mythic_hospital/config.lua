Config = {}

--[[
    This Is How Damage Must Be Applied To Trigger The Limb Damage Aspect
]]
Config.HealthDamage = 10
Config.ArmorDamage = 5

--[[
    This Is The Timer For How Long The Player Will Be In The Bed When They Check-In To Be Healed Automatically, This Is In Seconds
]]
Config.AIHealTimer = 5

--[[ 
    TIMERS This Is In Seconds - This Will Decide How Long The Thread Controlling This Functionality Is Slept For
]]
Config.BleedTickRate = 30

--[[
    This is how many seconds is taken away from the bleed tick rate if the player is walking, jogging, or sprinting
]]
Config.BleedMovementTick = 20
Config.BleedMovementAdvance = 10

--[[ 
    How Many Bleed Ticks You Want To Occur Before A Screen Fade Happens
]]
Config.FadeOutTimer = 10

--[[
    This Is How Many Intervals Pass Before You Blackout | This Is Calculated By BleedTickRate * FadeOutTimer = 1 Blackouttimer Tick 
    So Setting This To 10 with the above set to default would be 10 minutes ((30 * 2) * 10) = 600
]]
Config.BlackoutTimer = 15

--[[
    How Many Bleed Ticks Occur Before Your Bleed Level Is Increased
]]
Config.AdvanceBleedTimer = 4

--[[
    How many times, in seconds, are certain injury types checked to have side-effects applied
]]
Config.HeadInjuryTimer = 30
Config.ArmInjuryTimer = 30
Config.LegInjuryTimer = 15

--[[
    The Chance, In Percent, That Certain Injury Side-Effects Get Applied
]]
Config.HeadInjuryChance = 25
Config.ArmInjuryChance = 25
Config.LegInjuryChance = {
    Running = 50,
    Walking = 15
}

Config.ArmourStaggerChance = 85 -- Note : Small caliber weapons are this % halved

--[[
    The Base Damage That Is Multiplied By Bleed Level Every Time A Bleed Tick Occurs
]]
Config.BleedTickDamage = 4

--[[ ------------------------------------------------------------------------------------------------------------------------------------- ]]
--[[ ------------------------------------------------------------------------------------------------------------------------------------- ]]
--[[ ------------------------------------------------------------------------------------------------------------------------------------- ]]
--[[ ------------------------------------------------------------------------------------------------------------------------------------- ]]
--[[ ------------------------------------------------------------------------------------------------------------------------------------- ]]
--[[ ------------------------------------------------------------------------------------------------------------------------------------- ]]

Config.WeaponClasses = {
    ['SMALL_CALIBER'] = 1,
    ['MEDIUM_CALIBER'] = 2,
    ['HIGH_CALIBER'] = 3,
    ['SHOTGUN'] = 4,
    ['CUTTING'] = 5,
    ['LIGHT_IMPACT'] = 6,
    ['HEAVY_IMPACT'] = 7,
    ['EXPLOSIVE'] = 8,
    ['FIRE'] = 9,
    ['SUFFOCATING'] = 10,
    ['OTHER'] = 11,
    ['WILDLIFE'] = 12,
    ['NOTHING'] = 13
}

Config.WoundStates = {
    'Irrited',
    'Painful',
    'Extremely painful',
    'Unbearable pain',
}

Config.BleedingStates = {
    'Minimal bleeding',
    'Heavy bleeding',
    'Major bleeding',
    'Extreme bleeding',
}

Config.MovementRate = {
    0.98,
    0.96,
    0.94,
    0.92,
}

Config.Bones = {
    [0]     = 'NONE',
    [31085] = 'Head',
    [31086] = 'Head',
    [39317] = 'Neck',
    [57597] = 'Back',
    [23553] = 'Back',
    [24816] = 'Back',
    [24817] = 'Back',
    [24818] = 'Back',
    [10706] = 'Upper body',
    [64729] = 'Upper body',
    [11816] = 'Lower body',
    [45509] = 'Lower body',
    [61163] = 'Lower body',
    [18905] = 'Left hand',
    [4089] = 'Left hand',
    [4090] = 'Left hand',
    [4137] = 'Left hand',
    [4138] = 'Left hand',
    [4153] = 'Left hand',
    [4154] = 'Left hand',
    [4169] = 'Left hand',
    [4170] = 'Left hand',
    [4185] = 'Left hand',
    [4186] = 'Left hand',
    [26610] = 'Left hand',
    [26611] = 'Left hand',
    [26612] = 'Left hand',
    [26613] = 'Left hand',
    [26614] = 'Left hand',
    [58271] = 'Left leg',
    [63931] = 'Left leg',
    [2108] =  'Left foot',
    [14201] = 'Left foot',
    [40269] = 'Right arm',
    [28252] = 'Right arm',
    [57005] = 'Right hand',
    [58866] = 'Right hand',
    [58867] = 'Right hand',
    [58868] = 'Right hand',
    [58869] = 'Right hand',
    [58870] = 'Right hand',
    [64016] = 'Right hand',
    [64017] = 'Right hand',
    [64064] = 'Right hand',
    [64065] = 'Right hand',
    [64080] = 'Right hand',
    [64081] = 'Right hand',
    [64096] = 'Right hand',
    [64097] = 'Right hand',
    [64112] = 'Right hand',
    [64113] = 'Right hand',
    [36864] = 'Right leg',
    [51826] = 'Right leg',
    [20781] = 'Right foot',
    [52301] = 'Right foot',
}

Config.Weapons = {
    --[[ Small Caliber ]]--
    [`WEAPON_PISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_COMBATPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_APPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_COMBATPDW`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MACHINEPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MICROSMG`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MINISMG`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_PISTOL_MK2`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_SNSPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_SNSPISTOL_MK2`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_VINTAGEPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],

    --[[ Medium Caliber ]]--
    [`WEAPON_ADVANCEDRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_ASSAULTSMG`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_BULLPUPRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_BULLPUPRIFLE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_CARBINERIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_CARBINERIFLE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_COMPACTRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_DOUBLEACTION`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_GUSENBERG`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_HEAVYPISTOL`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_MARKSMANPISTOL`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_PISTOL50`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_REVOLVER`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_REVOLVER_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SMG`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SMG_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SPECIALCARBINE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SPECIALCARBINE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],

    --[[ High Caliber ]]--
    [`WEAPON_ASSAULTRIFLE`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_ASSAULTRIFLE_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_COMBATMG`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_COMBATMG_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_HEAVYSNIPER`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_HEAVYSNIPER_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MARKSMANRIFLE`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MARKSMANRIFLE_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MG`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MINIGUN`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MUSKET`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_RAILGUN`] = Config.WeaponClasses['HIGH_CALIBER'],

    --[[ Shotguns ]]--
    [`WEAPON_ASSAULTSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_BULLUPSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_DBSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_HEAVYSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_PUMPSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_PUMPSHOTGUN_MK2`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_SAWNOFFSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_SWEEPERSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],

    --[[ Animals ]]--
    [`WEAPON_ANIMAL`] = Config.WeaponClasses['WILDLIFE'], -- Animal
    [`WEAPON_COUGAR`] = Config.WeaponClasses['WILDLIFE'], -- Cougar
    [`WEAPON_BARBED_WIRE`] = Config.WeaponClasses['WILDLIFE'], -- Barbed Wire
    
    --[[ Cutting Weapons ]]--
    [`WEAPON_BATTLEAXE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_BOTTLE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_DAGGER`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_HATCHET`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_KNIFE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_MACHETE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_SWITCHBLADE`] = Config.WeaponClasses['CUTTING'],

    --[[ Light Impact ]]--
    --[`WEAPON_GARBAGEBAG`] = Config.WeaponClasses['LIGHT_IMPACT'], -- Garbage Bag
    --[`WEAPON_BRIEFCASE`] = Config.WeaponClasses['LIGHT_IMPACT'], -- Briefcase
    --[`WEAPON_BRIEFCASE_02`] = Config.WeaponClasses['LIGHT_IMPACT'], -- Briefcase 2
    --[`WEAPON_BALL`] = Config.WeaponClasses['LIGHT_IMPACT'],
    --[`WEAPON_FLASHLIGHT`] = Config.WeaponClasses['LIGHT_IMPACT'],
    [`WEAPON_KNUCKLE`] = Config.WeaponClasses['LIGHT_IMPACT'],
    --[`WEAPON_NIGHTSTICK`] = Config.WeaponClasses['LIGHT_IMPACT'],
    --[`WEAPON_SNOWBALL`] = Config.WeaponClasses['LIGHT_IMPACT'],
    --[`WEAPON_UNARMED`] = Config.WeaponClasses['LIGHT_IMPACT'],
    --[`WEAPON_PARACHUTE`] = Config.WeaponClasses['LIGHT_IMPACT'],
    --[`WEAPON_NIGHTVISION`] = Config.WeaponClasses['LIGHT_IMPACT'],
    
    --[[ Heavy Impact ]]--
    [`WEAPON_BAT`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_CROWBAR`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_FIREEXTINGUISHER`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_FIRWORK`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_GOLFLCUB`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_HAMMER`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_PETROLCAN`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_POOLCUE`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_WRENCH`] = Config.WeaponClasses['HEAVY_IMPACT'],
    
    --[[ Explosives ]]--
    [`WEAPON_EXPLOSION`] = Config.WeaponClasses['EXPLOSIVE'], -- Explosion
    [`WEAPON_GRENADE`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_COMPACTLAUNCHER`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_HOMINGLAUNCHER`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_PIPEBOMB`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_PROXMINE`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_RPG`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_STICKYBOMB`] = Config.WeaponClasses['EXPLOSIVE'],
    
    --[[ Other ]]--
    [`WEAPON_FALL`] = Config.WeaponClasses['OTHER'], -- Fall
    [`WEAPON_HIT_BY_WATER_CANNON`] = Config.WeaponClasses['OTHER'], -- Water Cannon
    [`WEAPON_RAMMED_BY_CAR`] = Config.WeaponClasses['OTHER'], -- Rammed
    [`WEAPON_RUN_OVER_BY_CAR`] = Config.WeaponClasses['OTHER'], -- Ran Over
    [`WEAPON_HELI_CRASH`] = Config.WeaponClasses['OTHER'], -- Heli Crash
    [`WEAPON_STUNGUN`] = Config.WeaponClasses['OTHER'],
    
    --[[ Fire ]]--
    [`WEAPON_ELECTRIC_FENCE`] = Config.WeaponClasses['FIRE'], -- Electric Fence 
    [`WEAPON_FIRE`] = Config.WeaponClasses['FIRE'], -- Fire
    [`WEAPON_MOLOTOV`] = Config.WeaponClasses['FIRE'],
    [`WEAPON_FLARE`] = Config.WeaponClasses['FIRE'],
    [`WEAPON_FLAREGUN`] = Config.WeaponClasses['FIRE'],

    --[[ Suffocate ]]--
    [`WEAPON_DROWNING`] = Config.WeaponClasses['SUFFOCATING'], -- Drowning
    [`WEAPON_DROWNING_IN_VEHICLE`] = Config.WeaponClasses['SUFFOCATING'], -- Drowning Veh
    [`WEAPON_EXHAUSTION`] = Config.WeaponClasses['SUFFOCATING'], -- Exhaust
    [`WEAPON_BZGAS`] = Config.WeaponClasses['SUFFOCATING'],
    [`WEAPON_SMOKEGRENADE`] = Config.WeaponClasses['SUFFOCATING'],
}