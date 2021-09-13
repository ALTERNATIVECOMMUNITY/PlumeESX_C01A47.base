fx_version 'cerulean'
game 'gta5'

author 'Luca845LP'
description 'luca_idcard - A Reworked Version of jsfour-idcard'
version '1.0.0'

ui_page 'files/html/index.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'files/server.lua'
}

client_scripts {
	'files/client.lua'
}

shared_script 'config.lua'

files {
	'files/html/index.html',
	'files/html/assets/css/*.css',
	'files/html/assets/js/*.js',
	'files/html/assets/fonts/roboto/*.woff',
	'files/html/assets/fonts/roboto/*.woff2',
	'files/html/assets/fonts/justsignature/JustSignature.woff',
	'files/html/assets/images/*.png'
}
