fx_version 'adamant'

game 'gta5'

description 'mythic_hospital'

Author 'Tyler -bbrp Base by: ElusionPDX'

version '1.0.0'

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/wound.lua',
	'client/main.lua',
	'client/items.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua',
}

dependencies {
	'mythic_notify',
}

exports {
    'IsInjuredOrBleeding',
}


