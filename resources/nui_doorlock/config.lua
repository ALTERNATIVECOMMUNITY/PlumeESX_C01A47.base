Config = {}
Config.ShowUnlockedText = false
Config.CheckVersion = true
Config.CheckVersionDelay = 60 -- Minutes
Config.KeybingText = 'Interact with a door lock'

Config.DoorList = {}


-- mosleyGarageDoor1
table.insert(Config.DoorList, {
	objHeading = 22.389883041382,
	objCoords = vector3(1.02154, -1675.23, 28.71656),
	lockpick = false,
	maxDistance = 6.0,
	objHash = 1450521648,
	audioRemote = false,
	slides = 6.0,
	authorizedJobs = { ['mosleys_mech']=0 },
	garage = true,
	fixText = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- mosleyGateDoor1
table.insert(Config.DoorList, {
	objHeading = 230.00088500977,
	objCoords = vector3(-52.81712, -1673.777, 28.32813),
	lockpick = false,
	maxDistance = 6.0,
	objHash = -311402072,
	audioRemote = false,
	slides = true,
	authorizedJobs = { ['mosleys_mech']=0 },
	garage = false,
	fixText = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- mosleyGateDoor2
table.insert(Config.DoorList, {
	objHeading = 23.395977020264,
	objCoords = vector3(-37.37422, -1690.808, 28.31333),
	lockpick = false,
	maxDistance = 6.0,
	objHash = 2131887341,
	audioRemote = false,
	slides = true,
	authorizedJobs = { ['mosleys_mech']=0 },
	garage = false,
	fixText = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- mosleyGarageDoor2
table.insert(Config.DoorList, {
	objHeading = 140.00346374512,
	objCoords = vector3(-18.49778, -1674.178, 28.75193),
	lockpick = false,
	maxDistance = 6.0,
	objHash = 1450521648,
	audioRemote = false,
	slides = 6.0,
	authorizedJobs = { ['mosleys_mech']=0 },
	garage = true,
	fixText = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- mosleyGarageDoor3
table.insert(Config.DoorList, {
	objHeading = 320.0,
	objCoords = vector3(-11.17308, -1646.961, 28.54219),
	lockpick = false,
	maxDistance = 6.0,
	objHash = -648904721,
	audioRemote = false,
	slides = 6.0,
	authorizedJobs = { ['mosleys_mech']=0 },
	garage = true,
	fixText = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- mosleyGarageDoor3
table.insert(Config.DoorList, {
	objHeading = 320.0,
	objCoords = vector3(-11.17308, -1646.961, 28.54219),
	lockpick = false,
	maxDistance = 6.0,
	objHash = -648904721,
	audioRemote = false,
	slides = 6.0,
	authorizedJobs = { ['mosleys_mech']=0 },
	garage = true,
	fixText = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- mosleyGarageDoor4
table.insert(Config.DoorList, {
	objHeading = 49.999706268311,
	objCoords = vector3(-30.91102, -1647.468, 28.55916),
	lockpick = false,
	maxDistance = 6.0,
	objHash = -648904721,
	audioRemote = false,
	slides = 6.0,
	authorizedJobs = { ['mosleys_mech']=0 },
	garage = true,
	fixText = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

--mosleydoor1
table.insert(Config.DoorList, {
	authorizedJobs = { ['mosleys_mech']=0 },
	doors = {
		{objHash = -725970636, objHeading = 230.0, objCoords = vector3(-42.26137, -1660.963, 29.71504)},
		{objHash = 827574885, objHeading = 230.0, objCoords = vector3(-43.83181, -1662.835, 29.71685)}
 },
	audioRemote = false,
	lockpick = false,
	slides = false,
	maxDistance = 2.5,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- mosleyDoor3
table.insert(Config.DoorList, {
	objHeading = 139.99998474121,
	objCoords = vector3(-25.77276, -1672.344, 29.63385),
	lockpick = false,
	maxDistance = 2.0,
	objHash = 130864445,
	audioRemote = false,
	slides = false,
	authorizedJobs = { ['mosleys_mech']=0 },
	garage = false,
	fixText = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- mosleyDoor4
table.insert(Config.DoorList, {
	objHeading = 50.0,
	objCoords = vector3(-35.49793, -1676.592, 29.63518),
	lockpick = false,
	maxDistance = 2.0,
	objHash = 130864445,
	audioRemote = false,
	slides = false,
	authorizedJobs = { ['mosleys_mech']=0 },
	garage = false,
	fixText = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})


-- mosleyDoor2
table.insert(Config.DoorList, {
	locked = true,
	maxDistance = 2.5,
	audioRemote = false,
	lockpick = false,
	slides = false,
	doors = {
		{objHash = -725970636, objHeading = 320.0, objCoords = vector3(-41.32543, -1673.46, 29.71141)},
		{objHash = 827574885, objHeading = 320.0, objCoords = vector3(-39.44841, -1675.034, 29.71728)}
 },
	authorizedJobs = { ['mosleys_mech']=0 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- mosleyDoor5
table.insert(Config.DoorList, {
	objHeading = 22.785146713257,
	authorizedJobs = { ['mosleys_mech']=0 },
	maxDistance = 2.0,
	objHash = 130864445,
	slides = false,
	garage = false,
	objCoords = vector3(5.52079, -1673.308, 29.63902),
	lockpick = false,
	audioRemote = false,
	fixText = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- impoundGate1
table.insert(Config.DoorList, {
	objHeading = 180.00001525879,
	objHash = 1286535678,
	garage = false,
	authorizedJobs = { ['towing']=0, ['police'] = 0 },
	slides = true,
	lockpick = false,
	maxDistance = 6.0,
	locked = true,
	fixText = false,
	objCoords = vector3(-164.1268, -1160.677, 22.63864),
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- impoundGate2
table.insert(Config.DoorList, {
	objHeading = 90.000007629395,
	objHash = 1286535678,
	garage = false,
	authorizedJobs = { ['towing']=0, ['police'] = 0 },
	slides = true,
	lockpick = false,
	maxDistance = 6.0,
	locked = true,
	fixText = false,
	objCoords = vector3(-156.9067, -1177.122, 22.08962),
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- impoundGate3
table.insert(Config.DoorList, {
	objHeading = 90.000007629395,
	objHash = 1286535678,
	garage = false,
	authorizedJobs = { ['towing']=0, ['police'] = 0 },
	slides = true,
	lockpick = false,
	maxDistance = 6.0,
	locked = true,
	fixText = false,
	objCoords = vector3(-226.1463, -1176.322, 22.08302),
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- impoundGate4
table.insert(Config.DoorList, {
	objHeading = 180.00001525879,
	objHash = 1286535678,
	garage = false,
	authorizedJobs = { ['towing']=0, ['police'] = 0 },
	slides = true,
	lockpick = false,
	maxDistance = 6.0,
	locked = true,
	fixText = false,
	objCoords = vector3(-225.0743, -1158.825, 22.09534),
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- impoundDoor1
table.insert(Config.DoorList, {
	objHeading = 89.999961853027,
	objHash = -952356348,
	garage = false,
	authorizedJobs = { ['towing']=0, ['police'] = 0 },
	slides = false,
	lockpick = false,
	maxDistance = 2.0,
	locked = true,
	fixText = false,
	objCoords = vector3(-187.0614, -1162.349, 23.82124),
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- bobcat1
table.insert(Config.DoorList, {
	maxDistance = 2.5,
	lockpick = true,
	slides = false,
	audioRemote = false,
	locked = true,
	thermite = true,
	authorizedJobs = { ['police']=0 },
	name = 'bobcat1',
	doors = {
		{objHash = -1563799200, objHeading = 175.0022277832, objCoords = vector3(880.8951, -2258.308, 32.53486)},
		{objHash = -1259801187, objHeading = 355.0022277832, objCoords = vector3(883.4803, -2258.53, 32.53486)}
 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- bobcat2
table.insert(Config.DoorList, {
	name = 'bobcat2',
	maxDistance = 2.0,
	objHash = -551608542,
	lockpick = false,
	fixText = false,
	audioRemote = false,
	garage = false,
	slides = false,
	thermite = true,
	objCoords = vector3(881.6171, -2264.669, 32.59156),
	locked = true,
	authorizedJobs = { ['police']=0 },
	objHeading = 175.0022277832,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})
--bobcat3
table.insert(Config.DoorList, {
	maxDistance = 2.0,
	lockpick = false,
	audioRemote = false,
	slides = false,
	items = {'Green_Keycard'},
	locked = true,
	authorizedJobs = { ['police']=0 },	
	doors = {
		{objHash = 933053701, objHeading = 355.198364, objCoords = vector3(882.6199, -2268.408, 32.5916)},
		{objHash = 933053701, objHeading = 175.00221, objCoords = vector3(880.0298, -2268.182, 32.5916)}
 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})