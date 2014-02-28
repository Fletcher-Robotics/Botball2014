--- @module motor
local M = require "lualink.motor_c"

--- PosMotor
-- @section PosMotor
M.PosMotor = {}

--- PosMotor constructor
-- @tparam int port port
-- @tparam int speed speed used when moving the motor (1-1000)
-- @tparam tbl pos_s positions table, in format {neutral = 0}
function M.PosMotor:new (port, speed, pos_s)
    if not port then error("No port argument", 2) end

    local o = {p = port, s = speed}
    setmetatable(o, self)
    self.__index = self
    self.__gc = function (o) o:off() end

    -- Setup positions
    for k,v in pairs(pos_s) do
        o[k] = function (self) self:set_position(v) end
    end

    M.clear_motor_position_counter(o.p)
    return o
end

--- Set PosMotor position
-- @tparam int pos absolute position
-- @see mtp
function M.PosMotor:set_position(pos)
    M.mtp(self.p, self.s, pos)
end

--- Wait until PosMotor has finished it's operations
-- @see bmd
function M.PosMotor:bmd()
    M.bmd(self.p)
end

--- Turn off the PosMotor
-- @see off
function M.PosMotor:off()
    M.off(self.p)
end

--- Freeze the PosMotor
-- @see freeze
function M.PosMotor:freeze()
    M.freeze(self.p)
end

return M