fx_version 'bodacious'
games { 'gta5' }

shared_scripts {
    'lua/shared/sh_*.lua',
}

client_scripts {
    'esx/cl_esx.lua',
    'lua/client/cl_ui.lua',
    'lua/client/main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'esx/sv_esx.lua',
    'lua/server/*.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html',
    'html/app.js',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/css/*.css'
}
