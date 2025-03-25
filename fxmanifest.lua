fx_version 'cerulean'
game 'gta5'

author 'Hondo'
description 'Automatisk Nummerplade Genkender (ANPG) med ox_lib til ESX'
version '1.0.0'
lua54 'yes'

shared_scripts { 
    '@es_extended/imports.lua',
    'config/**.lua',
    '@ox_lib/init.lua'
}

client_script 'client/**.lua'

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/**.lua'
}

dependencies {
    'ox_lib',
    'oxmysql'
}

files {
    'cache.json'
}
