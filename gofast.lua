-- Import lualink (http://mml.stephenmac.com/static/lualink/) manager library
local managers = require "lualink.managers"
local msleep = require("lualink.time").msleep
local motor = require("lualink.motor")

function quick_dist(speedr, speedl, dist)
    motor.motor(0, speedl) motor.motor(1, speedr)
    msleep(dist*10)
    w:halt()
end

function capacitor_cleanup() -- instead: cap_setup works too
    motor.motor(0, 100) motor.motor(1, 100)
    msleep(100)
    motor.motor(0, -100) motor.motor(1, -100)
    msleep(100)
    w:halt()
    msleep(2500)
end

function main()
    -- Setup Wheels using a WheelController
    w = (require "lualink.WheelController"):new(
        {lp = 0, rp = 1, lm = 1, rm = 1,
         ld = 200, rd = 200, lr = 400, rr = 400}) --103cm/s

    local ramp = managers.Servo(1, {up = 1900, mid = 840, down = 700})
    -- Syntax: ramp:up() or ramp:set_position(500)
    --capacitor_cleanup()
    ramp:mid()
    msleep(100)
    w:straight(1500, 800)
    quick_dist(0, 100, 150)  
    w:straight(1500, 280)
    w:freeze()
    msleep(90000)
end

main()
