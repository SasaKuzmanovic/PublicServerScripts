resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX War System'

version '1.0.0'

server_scripts {
  '@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua',
  '@es_extended/config.lua',
  '@es_extended/config.weapons.lua',
}

client_scripts {
  '@es_extended/locale.lua',
  'client/main.lua',
  '@es_extended/config.lua',
  '@es_extended/config.weapons.lua'
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/score.png',
	'ui/kill.png',
	'ui/death.png',
	'ui/time.png'
}
