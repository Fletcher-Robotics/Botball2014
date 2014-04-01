-- Import lualink (http://mml.stephenmac.com/static/lualink/) manager library
local managers = require "lualink.managers"
local msleep = require("lualink.time").msleep
local motor = require("lualink.motor")

function main()
	-- Setup Wheels using a WheelController
	local w = (require "lualink.WheelController"):new(
		{lp = 0, rp = 1, lm = 1, rm = 1,
		 ld = 200, rd = 200, lr = 80, rr = 80})
	
	--w:straight(500, 1000)
	w:both(motor.motor, 100)
	msleep(3000)
	w:both(motor.off)
	w:both(motor.motor, -100)
	msleep(3000)
	w:both(motor.off)
end

main()
