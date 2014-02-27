local WheelController = {}
local wheel = require "lualink.wheel_c"
local common = require "lualink.common"

function WheelController:new (o)
    -- o should include left/right port (lp, rp), left/right speed mult (lm, rm),
    -- left/right wheel diameter (ld, rd), and left/right radial distance (lr, rr)
    if not o then error("Missing object argument") end
    wheel.build_left_wheel(o.lp, 1100, o.lm, o.ld, o.lr)
    wheel.build_right_wheel(o.rp, 1100, o.rm, o.rd, o.rr)

    setmetatable(o, self)
    self.__index = self
    self.__gc = function (o) common.off(o.lp) common.off(o.rp) end

    return o
end

function WheelController:both (f, ...)
    f(self.lp, ...)
    f(self.rp, ...)
end

function WheelController:straight (speed, dist)
    self:both(common.motor, speed / 25)
    common.msleep(40)
    wheel.straight(speed, dist)
end

function WheelController:spin (speed, angle)
    wheel.spin(speed, angle)
end

function WheelController:arc (speed, radius, angle)
    wheel.arc(speed, radius, angle)
end

function WheelController:wait ()
    wheel.wait()
end

return WheelController
