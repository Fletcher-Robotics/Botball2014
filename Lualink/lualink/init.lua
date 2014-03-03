--- Entry point for lualink
-- @module lualink
local M = {}

M.create = require "lualink.create"
M.motor = require "lualink.motor"
M.sensor = require "lualink.sensor"
M.servo = require "lualink.servo"
M.time = require "lualink.time"

M.managers = require "lualink.managers"

M.WheelController = require "lualink.WheelController"

return M
