--- Manager classes
-- @module manager

local M = {}
local sensor = require "lualink.sensor"
local servo = require "lualink.servo"
local motor = require "lualink.motor"

--- Sensor manager
-- @type Sensor
M.Sensor = {}

--- Sensor constructor
-- @tparam int port sensor port
function M.Sensor:new(port)
    if not port then error("No port argument", 2) end

    local o = {p = port}
    self.__index = self
    setmetatable(o, self)

    return o
end

--- Gets the value of the sensor, defaults to using analog
-- @see sensor.analog
function M.Sensor:get_value()
    return sensor.analog(self.p)
end

--- Blocks the program until checking function is true
-- @tparam func f Function which, given the value of the servo, returns
-- whether desired condition is satisfied
function M.Sensor:block_until(f)
    repeat until f(self:get_value()) ~= false
end


--- Manages a positioned motor. A positioned motor acts like a servo,
-- but it can go on continuously. Ideal for something connected to a rope
-- or string.
-- @type PosMotor
M.PosMotor = {}

--- PosMotor constructor
-- @tparam int port port
-- @tparam int speed speed used when moving the motor (1-1000)
-- @tparam tbl pos_s positions table, in format {neutral = 0}
function M.PosMotor:new (port, speed, pos_s)
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
function M.PosMotor:set_position(pos)
    motor.mtp(self.p, self.s, pos)
end

--- Wait until it has finished it's operations
-- @see motor.bmd
function M.PosMotor:bmd()
    motor.bmd(self.p)
end

--- Turn it off
-- @see motor.off
function M.PosMotor:off()
    motor.off(self.p)
end

--- Freeze it
-- @see motor.freeze
function M.PosMotor:freeze()
    motor.freeze(self.p)
end


--- Manager for a servo. Similar to a PosMotor.
-- @type Servo
M.Servo = {}

--- Servo constructor
-- @tparam int port port
-- @tparam tbl pos_s positions table, in format {neutral = 0}
function M.Servo:new (port, pos_s)
    if not port then error("No port argument", 2) end

    local o = {p = port}
    self.__index = self
    self.__gc = function (o) o:disable() end
    setmetatable(o, self)

    -- Setup posistions
    for k,v in pairs(pos_s) do
        o[k] = function (self) self:set_position(v) end
    end

    o:enable()
    return o
end

--- Set position of Servo
-- @tparam int pos position
-- @see servo.set_servo_position
function M.Servo:set_position (pos)
    servo.set_servo_position(self.p, pos)
end

--- Enable Servo
-- Automatically executed by constructor
-- @see servo.enable_servo
function M.Servo:enable ()
    servo.enable_servo(self.p)
end

--- Disable Servo
-- Automatically executed by finalizer
-- @see servo.disable_servo
function M.Servo:disable ()
    servo.disable_servo(self.p)
end

return M
