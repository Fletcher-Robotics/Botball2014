-- Import lualink (http://mml.stephenmac.com/static/lualink/) manager library
local managers = require "lualink.managers"
local msleep = require("lualink.time").msleep
local motor = require("lualink.motor")
local halt = require("lualink.wheel_c").halt

function straight_dist(speed, dist)
    quick_dist(speed, speed, dist)
end

function quick_dist(speedr, speedl, dist)
    motor.motor(0, speedl) motor.motor(1, speedr)
    msleep(dist*10)
    halt()
end

function main()
    -- Setup Wheels using a WheelController
    w = (require "lualink.WheelController"):new(
        {lp = 0, rp = 1, lm = 1, rm = 1,
         ld = 200, rd = 200, lr = 400, rr = 400})
        --103cm/s
    --local ramp = managers.Servo(1, {up = 1800, mid = 925, down = 650})
    w:straight(1500, 700)
    quick_dist(0, 100, 150)
    quick_dist(-100, 0, 50)
    w:halt()
end

main()
