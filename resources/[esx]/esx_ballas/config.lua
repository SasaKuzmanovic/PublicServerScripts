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

Config.BallasStations = {

  Ballas = {

    Blip = {
      Pos     = { x = 114.15933990478, y = -1961.0571289062, z = 21.334177017212 },
      Sprite  = 378,
      Display = 4,
      Scale   = 1.2,
      Colour  = 27,
    },

    AuthorizedWeapons = {
{ name = 'WEAPON_FLAREGUN',         price = 50000 },
      { name = 'WEAPON_APPISTOL',         price = 120000 },
	  { name = 'WEAPON_ASSAULTRIFLE',     price = 500000 },
      { name = 'WEAPON_SWITCHBLADE',      price = 5000 },
	  { name = 'WEAPON_REVOLVER',         price = 200000 },
	  { name = 'WEAPON_POOLCUE',          price = 100 },
	  { name = 'WEAPON_MICROSMG',        price = 300000 }, -- WEAPON_PISTOL50
	  { name = 'WEAPON_PISTOL50',        price = 150000 }
    },

	  AuthorizedVehicles = {
		  { name = 'Cognoscenti',  label = 'Cognoscenti 55' },
		  { name = 'Chino2',      label = 'Chino' },
		  { name = 'Faction2',   label = 'Faction' },
		  { name = 'Moonbeam2',      label = 'Moonbeam' },
		  { name = 'Buffalo2',   	  label = 'Buffalo' },
		  { name = 'Baller3',   	  label = 'Baller' },
		  { name = 'Bison',   	  label = 'Bison' },
		  { name = 'Manchez',   	  label = 'Manchez' },
		  { name = 'BMX',   	  label = 'BMX' }
	  },

    Armories = {
      { x = 108.3963546753, y = -1304.4448242188, z = 27.768783569336 },
    },
	
	Ulaz = {
      { x = 31.658597946166, y = -1314.5631103516, z = 28.52314376831 },
    },
	
	Izlaz = {
      { x = 1065.728881836, y = -3183.5126953125, z = -40.163543701172 },
    },
	
	Stack = {
      { x = 1044.084350586, y = -3194.8156738282, z = -39.159065246582 },
    },

    Vehicles = {
      {
        Spawner    = { x = 102.99222564698, y = -1958.615600586, z = 19.783502578736 },
        SpawnPoint = { x = 104.06053161622, y = -1951.1137695312, z = 19.307838439942 },
        Heading    = 265.5310974121,
      }
    },
	
	Helicopters = {
      {
        Spawner    = { x = -12.789277076721, y = -1428.5339355469, z = 34.15209197998 },
        SpawnPoint = { x = -12.203351974487, y = -1436.1190185547, z = 34.15209197998 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = 116.54390716552, y = -1949.3814697266, z = 19.722505569458 },
      { x = 116.54390716552, y = -1949.3814697266, z = 19.722505569458 },
    },

    BossActions = {
      { x = 94.532447814942, y = -1293.4813232422, z = 28.268760681152 }
    },

  },

}
