Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.MaxInService               = -1
Config.Locale                     = 'hr'

Config.ZemunskiStations = {

  Zemunski = {

    Blip = {
      Pos     = { x = -1516.3908691406, y = 852.08935546875, z = 180.59471130372 },
      Sprite  = 378,
      Display = 4,
      Scale   = 1.2,
      Colour  = 40,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_COMBATPISTOL',     price = 2500 },
      { name = 'WEAPON_ASSAULTSMG',       price = 9200 },
      { name = 'WEAPON_ASSAULTRIFLE',     price = 5000 },
      { name = 'WEAPON_PUMPSHOTGUN',      price = 2500 },
      { name = 'WEAPON_APPISTOL',         price = 2000 },
      { name = 'WEAPON_CARBINERIFLE',     price = 5000 },
      { name = 'WEAPON_REVOLVER',         price = 4500 },
      { name = 'WEAPON_GUSENBERG',        price = 8200 }
	  
    },

	  AuthorizedVehicles = {
		  { name = '18performante',  label = 'Lamborghini Huracan Performante' },
		  { name = 'divo',  label = 'Bugatti Divo' },
		  { name = '19S650',      label = 'Mercedes-Benz S Class' },
		  { name = 'rmodgt63',      label = 'Mercedes-Benz AMG GT63S' },
		  { name = '911turbos',      label = 'Mercedes-Benz 911 Turbo S' },
		  { name = 'x6m',   	 label = 'BMW X6M' },
		  { name = 'guardian',   label = 'Guardian 4x4' },
		  { name = 'wraith',   label = 'Rolls Royce Wraith' },
		  { name = 'panamera17turbo',   label = 'Porsche Panamera' },
		  { name = 'p1',   label = 'McLaren P1' },
		  { name = 'bmwm8',   label = 'BMW M8 Coupe' },
		  { name = 'gtrc',   label = 'Mercedes-Benz GT-R' }
	  },
    Armories = {
      { x = -1564.6329345704, y = 776.19244384766, z = 188.1943359375 },
    },
	
    Vehicles = {
      { 
        Spawner    = { x = -1551.9250488282, y = 881.43914794922, z = 180.32540893554 },
        SpawnPoint = { x = -1541.2944335938, y = 879.79107666016, z = 179.81750488282 },
        Heading    = 282.73,
      }
    },
	
	Helicopters = {
      {
        Spawner    = { x = 20.312, y = 535.667, z = 173.627 },
        SpawnPoint = { x = 3.40, y = 525.56, z = 177.919 },
        Heading    = 0.0,
      }
    },
    VehicleDeleters = {
      { x = -1546.048461914, y = 887.47784423828, z = 180.344039917 }
    },
    BossActions = {
      { x = -1516.3908691406, y = 852.08935546875, z = 180.59471130372 }
    },

  },

}
