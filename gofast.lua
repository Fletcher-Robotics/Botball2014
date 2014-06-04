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
	straight_dist(100, 63)
	quick_dist(5, 100, 150)
end

main()
