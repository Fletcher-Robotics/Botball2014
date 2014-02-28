--- Sensor class, objectifying sensors
-- @classmod Sensor

local sensor = require "lualink.servo"
local Sensor = {}

--- Sensor constructor
-- @tparam int port sensor port
function Sensor:new(port)
	if not port then error("No port argument", 2) end

	local o = {p = port}
	self.__index = self
	setmetatable(o, self)

	return o
end

--- Gets the value of the sensor, defaults to using analog
-- @see sensor.analog
function Sensor:get_value()
	return sensor.analog(self.p)
end

--- Blocks the program until checking function is true
-- @tparam func f Function which, given the value of the servo, returns
-- whether desired condition is satisfied
function Sensor:block_until(f)
	repeat until f(self:get_value()) ~= false
end

return Sensor
