local M = require "lualink.common_c"

M.Servo = {}
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

function M.Servo:set_position (p)
	M.set_servo_position(self.p, p)
end

function M.Servo:enable ()
	M.enable_servo(self.p)
end

function M.Servo:disable ()
	M.disable_servo(self.p)
end

M.PosMotor = {}
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

function M.PosMotor:set_position(pos)
	M.mtp(self.p, self.s, pos)
end

function M.PosMotor:bmd()
	M.bmd(self.p)
end

function M.PosMotor:off()
	M.off(self.p)
end

function M.PosMotor:freeze()
	M.freeze(self.p)
end

return M
