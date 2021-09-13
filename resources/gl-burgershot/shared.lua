Config = {}

Config.EnableBlip = true
Config.MeatPrice = 10
Config.PotatoePrice = 5
Config.BunPrice = 3
Config.DeliveryCooldown = 1 -- In Minutes

Config.Recipes = {

['moneyshot'] = {
	Amount = 1,
	Animation = 'PROP_HUMAN_BUM_BIN',  -- Prepare or Cook (for Animation)
	Ingredients = { 
		['cookedmeat'] = 1,
		['bun'] = 1
	}

},
['bleeder'] = {
	Amount = 1,
	Animation = 'PROP_HUMAN_BUM_BIN', -- Prepare or Cook (for Animation)
	Ingredients = { 
		['cookedmeat'] = 2,
		['bun'] = 1
	}
},

['heartstopper'] = {
	Amount = 1,
	Animation = 'PROP_HUMAN_BUM_BIN', -- Prepare or Cook (for Animation)
	Ingredients = { 
		['cookedmeat'] = 4,
		['bun'] = 1
	}
},

['fries'] = {
	Amount = 1,
	Animation = 'PROP_HUMAN_BBQ', -- Prepare or Cook (for Animation)
	Ingredients = { 
		['potatoe'] = 1,
	}
},

['cookedmeat'] = {
	Amount = 1, 
	Animation = 'PROP_HUMAN_BBQ', -- Prepare or Cook (for Animation)
	Ingredients = { 
		['meat'] = 1
	}
},

-- Moneyshot Meal
['meal1'] = {
	Amount = 1, 
	Animation = 'PROP_HUMAN_BUM_BIN', 
	Ingredients = { 
		['moneyshot'] = 1,
		['fries'] = 1,
		['cocacola'] = 1,
	}
},

-- Bleeder Meal
['meal2'] = {
	Amount = 1, 
	Animation = 'PROP_HUMAN_BUM_BIN', 
	Ingredients = { 
		['bleeder'] = 1,
		['fries'] = 1,
		['cocacola'] = 1,
	}
},

-- Heartstopper Meal
['meal3'] = {
	Amount = 1, 
	Animation = 'PROP_HUMAN_BUM_BIN', 
	Ingredients = { 
		['heartstopper'] = 1,
		['fries'] = 1,
		['cocacola'] = 1,
	}
},




}