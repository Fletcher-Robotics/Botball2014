local create = require("lualink.create")
local manager = require("lualink.managers")
local msleep = require("lualink.time").msleep

function main()
	local claw = manager.Servo:new(0, {open = 700, closed = 1450, sorta_open = 1000})
	local arm = manager.PosMotor:new(0, 500, {neutral = 0, max=1400, topbar=1350, botbar=-290})
	arm:max()

	-- Navigate to hangers
	create.drive_arc(255, -400, -55)
	create.drive_arc(255, 520, 51)
	create.drive_segment(150, 220)
	create.spin_angle(150, -88.8)
	create.drive_segment(150, 240)
	create.force_wait()

	-- Hang greens
	arm:topbar()
	arm:bmd()
	msleep(750)
	claw:sorta_open()

	-- Move back
	create.drive_segment(150, -180)
	create.drive_arc(150, 200, -45)
	create.drive_arc(150, -200, 39)
	msleep(250)
	arm:botbar()
	arm:bmd()

	-- Go for blue one
	create.drive_segment(200, 280)
	create.force_wait()
	claw:closed()
	arm:neutral()
	arm:bmd()
	create.drive_segment(200, -180)
end

create.connect()
main()
create.disconnect()