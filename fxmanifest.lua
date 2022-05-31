fx_version 'cerulean'
game 'gta5'

author 'Bama94'
description 'DMV School for QBCore'

shared_scripts {
  '@PolyZone/client.lua',
  '@PolyZone/CircleZone.lua',
  --'@PolyZone/shared/locale.lua',
  --'locale/en.lua',                -- replace with desired language
  'config.lua'
}

client_scripts { 
    "client/*.lua"
    }
    
server_scripts { 
    "server/*.lua"
}

ui_page 'html/ui.html'

files {
  'html/ui.html',
  'html/logo.png',
  'html/dmv.png',
  'html/cursor.png',
  'html/styles.css',
  'html/questions.js',
  'html/scripts.js',
  'html/debounce.min.js'
}