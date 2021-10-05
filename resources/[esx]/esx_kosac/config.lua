Config              = {}
Config.DrawDistance = 100.0
Config.MaxDelivery	= 10
Config.TruckPrice	= 0
Config.Locale       = 'en'

Config.Boats = {
	"seashark2"
}

Config.Cloakroom = {
			CloakRoom = {
					Pos   = {x = -1466.79, y = -1388.64, z = 3.10},
					Size  = {x = 2.0, y = 2.0, z = 1.0},
					Color = {r = 0, g = 0, b = 255},
					Type  = 1,
					Id = 1
				}
}

Config.Zones = {
	VehicleSpawner = {
				Pos   = {x = -1484.53, y = -1393.01, z = 1.3},
				Size  = {x = 1.0, y = 1.0, z = 1.0},
				Color = {r = 255, g = 30, b = 0},
				Type  = 1
	},

	VehicleSpawnPoint = {
				Pos   = {x = -1514.80, y = -1410.26, z = 1.00},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Type  = -1
	},
	
	VehicleDeletePoint = {
				Pos   = {x = -1510.33, y = -1411.69, z = 0.30},
				Size  = {x = 3.0, y = 3.0, z = 2.0},
				Color = {r = 255, g = 0, b = 0},
				Type  = 1
	}
}

Config.Uniforms = {
	job_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 46,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
}

Config.Objekti = {
	{x = -1675.51, y = -1455.58, z = 0.00},
	{x = -1742.67, y = -1465.50, z = 0.00},
	{x = -1757.42, y = -1562.78, z = 0.00},
	{x = -1785.53, y = -1313.02, z = 0.00},
	{x = -1637.69, y = -1301.09, z = 0.00},
	--{x = -1711.96, y = -1440.58, z = 0.10}
}
