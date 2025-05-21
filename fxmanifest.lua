fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.0.0'
author 'DevSync Studio'
description 'Creates a volume where water effects do not apply.'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'cl_main.lua'
}

dependencies {
    'ox_lib'
}
