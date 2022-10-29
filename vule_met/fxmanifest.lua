fx_version 'cerulean'
game 'gta5'
description 'Trenutna verzija | 2.0.0'
Author 'Vulegg#5757'

server_scripts {
    '__izvor/server.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    '__izvor/klijent.lua',
    'podesavanje.lua'
}

lua54        'yes'
shared_scripts {
    '@ox_lib/init.lua'
}

dependencies {
    'es_extended',
    'ox_inventory',
    'ox_lib',
    'qtarget',
    'PolyZone'
}