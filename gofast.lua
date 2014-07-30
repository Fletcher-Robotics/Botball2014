-- Import lualink (http://mml.stephenmac.com/static/lualink/) manager library
local managers = require "lualink.managers"
local msleep = require("lualink.time").msleep
local motor = require("lualink.motor")

function straight_dist(speed, dist)
    quick_dist(speed, speed, dist)
end

function quick_dist(speedr, speedl, dist)
    motor.motor(0, speedl) motor.motor(1, speedr)
    msleep(dist*10)
    motor.ao()
end

function main()
    -- Setup Wheels using a WheelController
    --[[local w = (require "lualink.WheelController"):new(
        {lp = 0, rp = 1, lm = 1, rm = 1,
         ld = 200, rd = 200, lr = 80, rr = 80})]]--
        --103cm/s
    --local ramp = managers.Servo(1, {up = 1800, mid = 925, down = 650})
    straight_dist(100, 83)
    quick_dist(50, 100, 150)
    straight_dist(100, 30)
end

main()
