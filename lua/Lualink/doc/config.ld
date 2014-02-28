project = 'Lualink'
description = 'Lua Bindings for the KIPR Link Controller'
title = 'Lualink Documentation'
package = 'lualink'
format = 'markdown'
dir = 'api'
file = "../lualink"
merge = true
sort = true

local ldoctext, ldoc = "KIPR Manual: %s", "http://goo.gl/vVaGB8"

custom_see_handler('^([%w_]+) (#[%w_]+)$', function(name, section)
    return ldoctext:format(name), ldoc .. section
end)
