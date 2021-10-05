resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Oglasi'

version '1.0.0'

ui_page "index.html"

files {
	"index.html",
	"assets/plugins/bootstrap-3.3.7-dist/css/bootstrap.css",
	"assets/plugins/jquery/jquery-3.2.1.min.js",
	"assets/plugins/bootstrap-3.3.7-dist/js/bootstrap.min.js"
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua'
}

client_scripts {
  'client/main.lua'
}
