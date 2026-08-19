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

files {
  'stream/w_me_batteringram.ydr',
  'stream/anim@batteringram.ycd',
  'data/weapons.meta',
  'data/weaponarchetypes.meta',
  'locales/*.json',
}

data_file 'WEAPONINFO_FILE' 'data/weapons.meta'
data_file 'WEAPON_METADATA_FILE' 'data/weaponarchetypes.meta'

dependencies {
  'ox_lib',
  'ox_target',
  'ox_inventory',
  'ox_doorlock',
}

lua54 'yes'
