--- @module servo
local M = require "lualink.servo_c"

--- Servo
-- @section servo
M.Servo = {}
--- Servo constructor
-- @tparam int port port
-- @tparam tbl pos_s positions table, in format {neutral = 0}
function M.Servo:new (port, pos_s)
	if not port then error("No port argument", 2) end

	local o = {p = port}
	setmetatable(o, self)
	self.__index = self
	self.__gc = function (o) o:disable() end

	-- Setup posistions
	for k,v in pairs(pos_s) do
		o[k] = function (self) self:set_position(v) end
	end

	o:enable()
	return o
end

--- Set position of Servo
-- @tparam int pos position
-- @see set_servo_position
function M.Servo:set_position (pos)
	M.set_servo_position(self.p, pos)
end

--- Enable Servo
-- @see enable_servo
function M.Servo:enable ()
	M.enable_servo(self.p)
end

--- Disable Servo
-- @see disable_servo
function M.Servo:disable ()
	M.disable_servo(self.p)
end

return M
