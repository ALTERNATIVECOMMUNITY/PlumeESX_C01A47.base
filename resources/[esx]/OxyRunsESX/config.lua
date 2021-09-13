Config = {}
Translation = {}

Config.Locale = 'en'




Config.Routes = {
	
	{
		PickupCoordinates = vector3(-232.77, -1725.05, 32.14), --Where AI and AI car will spawn vector3(-241.14, -1686.27, 32.91)
		PickupHeading     = 229.98, --AI heading 
		Destinations = {
			vector3(32.98, -1815.83, 24.62) --Meeting spot for delivery
		}
	},
	
	{
		PickupCoordinates = vector3(279.64, -1356.63, 31.52),
		PickupHeading     = 141.45,
		Destinations = {
			vector3(423.51, -1287.52, 30.25)
		}
	},
	--[[
	{
		PickupCoordinates = vector3(380.75, -84.48, 66.77),
		PickupHeading     = 115.7,
		Destinations = {
			vector3(136.37, -255.82, 51.40)
		}
	}
	]]--
}





-------------------------------------------------------------------------------------

Config.SpeedOfPedWhenDriving = 10.0

Config.MinAmount = 400
Config.MaxAmount = 500


