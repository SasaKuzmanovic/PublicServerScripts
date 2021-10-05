Config              = {}
Config.DrawDistance = 100.0
Config.MaxDelivery	= 10
Config.TruckPrice	= 0
Config.Locale       = 'hr'

Config.Trucks = {
	"mule"
}

Config.Cloakroom = {
			CloakRoom = {
					Pos   = {x = 844.74932861328, y = -902.7378540039, z = 24.251501083374},
					Size  = {x = 3.0, y = 3.0, z = 1.0},
					Color = {r = 204, g = 204, b = 0},
					Type  = 1,
					Id = 1
				}
}

Config.Zones = {
	VehicleSpawner = {
				Pos   = {x = 844.7650756836, y = -894.41888427734, z = 24.251501083374},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 204, g = 204, b = 0},
				Type  = 1
	},

	VehicleSpawnPoint = {
				Pos   = {x = 856.14172363282, y = -888.91998291016, z = 25.478912353516},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Type  = -1
	},
	VehicleSpawnPoint2 = {
				Pos   = {x = 852.41284179688, y = -896.01300048828, z = 25.536407470704},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Type  = -1
	},
	VehicleSpawnPoint3 = {
				Pos   = {x = 853.7289428711, y = -902.56219482422, z = 25.314809799194},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Type  = -1
	},
}

Config.Livraison = {
-------------------------------------------Los Santos
	-- Strawberry avenue et Davis avenue
	Delivery1LS = {
			Pos = {x = -1395.82, y = -653.76, z = 27.91},
			Dos = { x = -1413.43, y = -635.47, z = 27.67},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 730
		},
	-- a coté des flic
	Delivery2LS = {
			Pos = {x = 164.18, y = -1280.21, z = 28.38},
			Dos = { x = 136.5, y = -1278.69, z = 28.36},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 730
		},
	-- vers la plage
	Delivery3LS = {
			Pos = {x = 75.71, y = 164.41, z = 103.93},
			Dos = { x = 78.55, y = 180.44, z = 103.63},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 730
		},
	-- studio 1
	Delivery4LS = {
			Pos = {x = -226.62, y = 308.87, z = 91.4},
			Dos = { x = -229.54, y = 293.59, z = 91.19},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 730
		},
	-- popular street et el rancho boulevard
	Delivery5LS = {
			Pos = {x = -365.87, y = 297.27, z = 84.04},
			Dos = { x = -370.5, y = 277.98, z = 85.42},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 730
		},
	--Alta street et las lagunas boulevard
	Delivery6LS = {
			Pos = {x = -403.95, y = 196.11, z = 81.67},
			Dos = { x = -395.17, y = 208.6, z = 82.59},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 730
		},
	--Rockford Drive Noth et boulevard del perro
	Delivery7LS = {
			Pos = {x = -412.26, y = 297.95, z = 82.46},
			Dos = { x = -427.08, y = 294.19, z = 82.23},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 730
		},
	--Rockford Drive Noth et boulevard del perro
	Delivery8LS = {
			Pos = {x = -606.23, y = -901.52, z = 24.39},
			Dos = { x = -592.48, y = -892.76, z = 24.93},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 730
		},
	--New empire way (airport)
	Delivery9LS = {
			Pos = {x = -837.03, y = -1142.46, z = 6.44},
			Dos = { x = -841.89, y = -1127.91, z = 5.97},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 730
		},
	--Rockford drive south
	Delivery10LS = {
			Pos = {x = -1061.56, y = -1382.19, z = 4.44},
			Dos = { x = -1039.38, y = -1396.88, z = 4.55},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 730
		},
------------------------------------------- Blaine County
	-- panorama drive
	Delivery1BC = {
			Pos   = {x = 1999.5457, y = 3055.0686, z = 45.5},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 300
		},
	-- route 68
	Delivery2BC = {
			Pos   = {x = 555.4768, y = 2733.9533, z = 41.0},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 350
		},
	-- Algonquin boulevard et cholla springs avenue
	Delivery3BC = {
			Pos   = {x =1685.1549, y = 3752.0849, z = 33.0},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 400
		},
	-- Joshua road
	Delivery4BC = {
			Pos   = {x = 182.7030, y = 2793.9829, z = 44.5},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 450
		},
	-- East joshua road
	Delivery5BC = {
			Pos   = {x = 2710.6799, y = 4335.3168, z = 44.8},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 500
		},
	-- Seaview road
	Delivery6BC = {
			Pos   = {x = 1930.6518, y = 4637.5878, z = 39.3},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 300
		},
	-- Paleto boulevard
	Delivery7BC = {
			Pos   = {x = -448.2438, y = 5993.8686, z = 30.3},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 350
		},
	-- Paleto boulevard et Procopio drive
	Delivery8BC = {
			Pos   = {x = 107.9181, y = 6605.9750, z = 30.8},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 400
		},
	-- Marina drive et joshua road
	Delivery9BC = {
			Pos   = {x = 916.6915, y = 3568.7783, z = 32.7},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 450
		},
	-- Pyrite Avenue
	Delivery10BC = {
			Pos   = {x = -128.6733, y = 6344.5493, z = 31.0},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 500
		},
	
	RetourCamion = {
			Pos   = {x = 805.73858642578, y = -917.71398925782, z = 24.659790039062},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 0
		},
	
	AnnulerMission = {
			Pos   = {x = 875.91955566406, y = -890.31530761718, z = 24.98952293396},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 0
		},
}
