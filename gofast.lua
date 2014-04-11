-- Import lualink (http://mml.stephenmac.com/static/lualink/) manager library
local managers = require "lualink.managers"
local msleep = require("lualink.time").msleep
local motor = require("lualink.motor")

function main()
	-- Setup Wheels using a WheelController
	--[[local w = (require "lualink.WheelController"):new(
		{lp = 0, rp = 1, lm = 1, rm = 1,
		 ld = 200, rd = 200, lr = 80, rr = 80})]]--
	motor.mrp(0, 1500, 1500)
	motor.mrp(1, 1500, 1500)
	motor.bmd(0)
	motor.ao()
end

main()
