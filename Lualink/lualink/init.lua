--- Entry point for lualink
-- @module lualink
local M = {}

M.motor = require "lualink.motor"
M.time = require "lualink.time"
M.create = require "lualink.create"
M.sensor = require "lualink.sensor"
M.servo = require "lualink.servo"

M.PosMotor = require "lualink.PosMotor"
M.WheelController = require "lualink.WheelController"
M.Servo = require "lualink.Servo"

return M
