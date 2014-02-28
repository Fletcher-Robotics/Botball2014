--- Manager for a servo. Similar to a PosMotor.
-- @classmod Servo
local servo = require "lualink.servo"
local Servo = {}

--- Servo constructor
-- @tparam int port port
-- @tparam tbl pos_s positions table, in format {neutral = 0}
function Servo:new (port, pos_s)
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
function Servo:set_position (pos)
	servo.set_servo_position(self.p, pos)
end

--- Enable Servo
-- Automatically executed by constructor
-- @see servo.enable_servo
function Servo:enable ()
	servo.enable_servo(self.p)
end

--- Disable Servo
-- Automatically executed by finalizer
-- @see servo.disable_servo
function Servo:disable ()
	servo.disable_servo(self.p)
end

return Servo