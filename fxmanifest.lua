fx_version 'cerulean'
game 'gta5'

author 'Howsn'
description 'Stormram script - Reworked by Greve'
version '2.0.0'

shared_scripts {
  '@ox_lib/init.lua',
  'shared/config.lua'
}

client_scripts {
  'client/client.lua',
}

server_scripts {
  'server/server.lua',
}

dependencies {
  'ox_lib',
  'ox_target',
  'ox_inventory',
  'ox_doorlock',
}

lua54 'yes'
