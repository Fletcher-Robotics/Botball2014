local M = require"linklib"

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

M.WheelController = {}
function M.WheelController:new (o)
	-- o should include left/right port (lp, rp), left/right speed mult (lm, rm),
	-- left/right wheel diameter (ld, rd), and left/right radial distance (lr, rr)
	if not o then error("Missing object argument") end
	M.build_left_wheel(o.lp, 1100, o.lm, o.ld, o.lr)
	M.build_right_wheel(o.rp, 1100, o.rm, o.rd, o.rr)

	setmetatable(o, self)
	self.__index = self
	self.__gc = function (o) M.off(o.lp) M.off(o.rp) end

	return o
end

function M.WheelController:both (f, ...)
	f(self.lp, ...)
	f(self.rp, ...)
end

function M.WheelController:straight (speed, dist)
	local power
	if dist > 0 then power = speed / 25 else power = speed / -25 end

	self:both(M.motor, power)
	M.msleep(40)
	M.straight(speed, dist)
end

function M.WheelController:spin (speed, angle)
	M.spin(speed, angle)
end

function M.WheelController:arc (speed, radius, angle)
	M.arc(speed, radius, angle)
end

return M
