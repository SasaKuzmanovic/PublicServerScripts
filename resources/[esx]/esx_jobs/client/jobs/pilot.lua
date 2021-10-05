Config.Jobs.pilot = {

	BlipInfos = {
		Sprite = 423,
		Color = 38
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = "miljet",
			Trailer = "none",
			HasCaution = false
		}
	},

	Zones = {

		CloakRoom = {
			Pos   = {x = -912.64, y = -3022.23, z = 12.95},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker= 1,
			Id = 1,
			Blip  = true,
			Name  = 'Pilot Locker Room',
			Type  = "cloakroom",
			Hint  = _U('cloak_change'),
			GPS = {x = -912.64, y = -3022.23, z = 12.95}
		},

		PilotSpot = {
			Pos   = {x = 1744.89, y = 3277.33, z = 40.28},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 110.0, y = 110.0, z = 10.0},
			Marker= 1,
			Id = 3,
			Blip  = true,
			Name  = 'Utovar zona',
			Foot = false,
			Type  = "work",
			Hint  = 'Pritisni ~INPUT_PICKUP~ za utovar.',
			GPS   = {x = 1744.89, y = 3277.33, z = 41.28},
			Item = {
				{
					name   = 'Osoba',
					db_name= "ljudi",
					time   = 2000,
					max    = 100,
					add    = 1,
					remove = 1,
					requires = "nothing",
					requires_name = "Nothing",
					drop   = 100
				}
			},

		},

		VehicleSpawner = {
			Pos   = {x = -1006.0, y = -3013.58, z = 12.95},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker= 1,
			Id = 2,
			Blip  = true,
			Name  = _U('spawn_veh'),
			Type  = "vehspawner",
			Spawner = 1,
			Hint  = _U('spawn_veh_button'),
			Caution = 0,
			GPS = {x = -1006.0, y = -3013.58, z = 13.95}
		},

		VehicleSpawnPoint = {
			Pos   = {x = -976.97, y = -2997.17, z = 15.11},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker= -1,
			Id = 69,
			Blip  = false,
			Name  = _U('service_vh'),
			Type  = "vehspawnpt",
			Spawner = 1,
			GPS = 0,
			Heading = 61.57
		},

		VehicleDeletePoint = {
			Pos   = {x = -1024.94, y = -2935.85, z = 12.95},
			Size  = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 255, g = 0, b = 0},
			Marker= 1,
			Id = 69,
			Blip  = true,
			Name  = _U('return_vh'),
			Type  = "vehdelete",
			Hint  = _U('return_vh_button'),
			Spawner = 1,
			Caution = 0,
			GPS = 0,
			Teleport = 0
		},

		Delivery = {
			Pos   = {x = -1338.62, y = -2680.8, z = 13.11},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Marker= 1,
			Id = 4,
			Blip  = true,
			Name  = _U('delivery_point'),
			Type  = "delivery",
			Foot = false,
			Spawner = 2,
			Hint  = 'Pritisnite ~INPUT_PICKUP~ za istovar.',
			GPS   = {x = -1338.62, y = -2680.8, z = 15.11},
			Item = {
				{
				name   = _U('delivery'),
				time   = 500,
				remove = 1,
				max    = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
				price  = 91,
				requires = "ljudi",
				requires_name = 'ljudi',
				drop   = 100
				}
			}
		}

	}
}