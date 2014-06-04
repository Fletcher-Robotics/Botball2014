--- Manager classes
-- @module manager

local M = {}

local Object = require "lualink.Object"
local sensor = require "lualink.sensor"
local servo = require "lualink.servo"
local motor = require "lualink.motor"
local time = require "lualink.time"

--- Sensor manager
-- @type Sensor
M.Sensor = Object:subclass("Sensor")

--- Sensor constructor
-- @tparam int port sensor port
function M.Sensor:__init__(port)
    if not port then error("No port argument", 2) end

    self.p = port
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
    repeat until f(self:get_value())
end

--- Sensor manager for a digital sensor
-- @type DigitalSensor
M.DigitalSensor = M.Sensor:subclass("DigitalSensor")
function M.DigitalSensor:get_value()
    return sensor.digital(self.p)
end

--- Manages a positioned motor. A positioned motor acts like a servo,
-- but it can go on continuously. Ideal for something connected to a rope
-- or string.
-- @type PosMotor
M.PosMotor = Object:subclass('PosMotor')

--- PosMotor constructor
-- @tparam int port port
-- @tparam int speed speed used when moving the motor (1-1000)
-- @tparam tbl pos_s positions table, in format {neutral = 0}
function M.PosMotor:__init__(port, speed, pos_s)
    if not port then error("No port argument", 2) end

    -- Setup vars
    self.p = port
    self.s = speed

    -- Setup positions
    for k,v in pairs(pos_s) do
        self[k] = function (self) self:set_position(v) end
    end

    self:clear_position()
end

--- Set position
-- @tparam int pos absolute position
-- @see motor.mtp
function M.PosMotor:set_position(pos)
    motor.mtp(self.p, self.s, pos)
end

--- Clear position
-- @see motor.clear_motor_position_counter
function M.PosMotor:clear_position()
    motor.clear_motor_position_counter(self.p)
end

--- Change the speed of PosMotor movement
-- @tparam int speed speed used when moving the motor (1-1000)
-- @see PosMotor:__init__
function M.PosMotor:set_speed(speed)
    self.s = speed
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

--- Move relatively to a position
-- @tparam int pos relative position
-- @see motor.mrp
function M.PosMotor:mrp(pos)
    motor.mrp(self.p, self.s, pos)
end

--- Set power for direct control
-- @tparam int p power
-- @see motor.motor
function M.PosMotor:power(p)
    motor.motor(self.p, p)
end

function M.PosMotor.__meta__:__gc()
    self:off()
end


--- Manager for a servo. Similar to a PosMotor.
-- @type Servo
M.Servo = Object:subclass('Servo')

--- Servo constructor
-- @tparam int port port
-- @tparam tbl pos_s positions table, in format {neutral = 0}
function M.Servo:__init__ (port, pos_s)
    if not port then error("No port argument", 2) end

    self.p = port

    -- Setup posistions
    for k,v in pairs(pos_s) do
        self[k] = function (self) self:set_position(v) end
    end

    self:enable()
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

function M.Servo.__meta__:__gc ()
    self:disable()
end

return M
