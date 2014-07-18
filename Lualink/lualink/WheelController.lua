--- Controller class for wheels on a smaller robot without a create.
-- Should not be instantiated more than once, because it uses the
-- OpenCode cbc drive library which does not support multiple
-- instances.
-- @classmod WheelController
local WheelController = {}

local wheel = require "lualink.wheel_c"
local motor = require "lualink.motor"
local time = require "lualink.time"

--- WheelController constructor
-- @tparam tab o should include left/right port (lp, rp), left/right speed mult (lm, rm),
-- left/right wheel diameter (ld, rd), and left/right radial distance (lr, rr)
-- @todo use both in gc
function WheelController:new (o)
    if not o then error("Missing object argument") end
    wheel.build_left_wheel(o.lp, 1100, o.lm, o.ld, o.lr)
    wheel.build_right_wheel(o.rp, 1100, o.rm, o.rd, o.rr)

    setmetatable(o, self)
    self.__index = self
    self.__gc = function (o) motor.off(o.lp) motor.off(o.rp) end

    return o
end

--- Run a function on both wheels
-- @tparam func f Function to run with both wheels
function WheelController:both (f, ...)
    f(self.lp, ...)
    f(self.rp, ...)
end

--- Go straight
-- @tparam int speed speed (about 0-1000)
-- @tparam int dist distance
function WheelController:straight (speed, dist)
    self:both(motor.motor, speed / 25)
    time.msleep(40)
    wheel.straight(speed, dist)
end

--- Spin
-- @tparam int speed speed (about 0-1000)
-- @tparam number angle angle
function WheelController:spin (speed, angle)
    wheel.spin(speed, angle)
end

--- Move in an arc
-- @tparam int speed speed (about 0-1000)
-- @tparam number radius radius
-- @tparam number angle angle covered by arc
function WheelController:arc (speed, radius, angle)
    wheel.arc(speed, radius, angle)
end

--- Wait until movements are finished
--function WheelController:wait ()
--    wheel.wait()
--end

return WheelController
