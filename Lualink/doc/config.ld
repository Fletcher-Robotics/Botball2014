project = 'Lualink'
description = 'Lua Bindings for the KIPR Link Controller'
title = 'Lualink Documentation'
package = 'lualink'
format = 'markdown'
dir = 'api'
file = "../lualink"
merge = true
sort = true
sort_modules = true
topics = 'manual'
style = '!pale'
use_markdown_titles = true

local ldoctext, ldoc = "KIPR Manual: %s", "http://goo.gl/vVaGB8#"

custom_see_handler('^k:([%w_]+)$', function(name)
    return ldoctext:format(name), ldoc .. name
end)
