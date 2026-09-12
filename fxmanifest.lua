fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'icietzsche Development'
description 'Boss Menu - G6 Studio'
version '1.0'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config/config.lua',
    'locales/en.lua',
    'locales/tr.lua',
    'bridge/loader.lua',
    'bridge/framework/qb.lua',
    'bridge/framework/qbox.lua',
    'bridge/framework/esx.lua',
    'bridge/textui/ox_lib.lua',
    'bridge/textui/qb-core.lua',
    'bridge/textui/esx_textui.lua',
    'bridge/textui/drawtext3d.lua',
    'bridge/target/ox_target.lua',
    'bridge/target/qb-target.lua',
    'bridge/notify/ox_lib.lua',
    'bridge/notify/qb-core.lua',
    'bridge/notify/esx.lua',
    'bridge/banking/okokBanking.lua',
    'bridge/banking/qb-banking.lua',
    'bridge/banking/ox_banking.lua',
    'bridge/banking/renewed.lua',
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

dependencies {
    'oxmysql'
}