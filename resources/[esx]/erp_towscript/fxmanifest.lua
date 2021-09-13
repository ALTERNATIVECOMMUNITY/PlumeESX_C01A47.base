fx_version 'adamant'

author '! 1« NoobKeks_TV »#1337'
description 'Top quality Tow-Scirpt'
game 'gta5'

client_script {
    '@es_extended/locale.lua',
    "client.lua",
    "config.lua",
    "locales/*.lua"
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "server.lua",
    "config.lua"
}

dependencies {
'es_extended'

}
