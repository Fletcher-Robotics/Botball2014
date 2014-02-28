--- Manages a positioned motor. A positioned motor acts like a servo,
-- but it can go on continuously. Ideal for something connected to a rope
-- or string.
-- @classmod PosMotor
local motor = require "lualink.motor"

local PosMotor = {}

--- PosMotor constructor
-- @tparam int port port
-- @tparam int speed speed used when moving the motor (1-1000)
-- @tparam tbl pos_s positions table, in format {neutral = 0}
function PosMotor:new (port, speed, pos_s)
    if not port then error("No port argument", 2) end

    local o = {p = port, s = speed}
    self.__index = self
    self.__gc = function (o) o:off() end
    setmetatable(o, self)

    -- Setup positions
    for k,v in pairs(pos_s) do
        o[k] = function (self) self:set_position(v) end
    end

    motor.clear_motor_position_counter(o.p)
    return o
end

--- Set position
-- @tparam int pos absolute position
-- @see motor.mtp
function PosMotor:set_position(pos)
    motor.mtp(self.p, self.s, pos)
end

--- Wait until it has finished it's operations
-- @see motor.bmd
function PosMotor:bmd()
    motor.bmd(self.p)
end

--- Turn it off
-- @see motor.off
function PosMotor:off()
    motor.off(self.p)
end

--- Freeze it
-- @see motor.freeze
function PosMotor:freeze()
    motor.freeze(self.p)
end

return PosMotor