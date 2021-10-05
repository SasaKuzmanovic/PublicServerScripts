resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	"config.lua",
	'server/main.lua'
}

client_scripts {
	'client/main.lua',
	"config.lua"
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/ikona.png',
	'ui/pozicija.png',
	'ui/cp.png',
	'ui/vrijeme.png'
}