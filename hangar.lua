local create = require("lualink.create")
local manager = require("lualink.managers")
local msleep = require("lualink.time").msleep

function main()
	local claw = manager.Servo:new(0, {open = 700, closed = 1450})
	local arm = manager.PosMotor(0, 500, {neutral = 0, max=1300, topbar=1250, botbar=-230, over_botbar=-90})
	arm:max()

	-- Navigate to hangers
	create.drive_arc(255, -400, -55)
	create.drive_arc(255, 520, 52)
	create.drive_segment(150, 220)
	create.spin_angle(150, -87.6)
	create.drive_segment(150, 240)
	create.force_wait()

	-- Hang greens
	arm:topbar()
	arm:bmd()
	msleep(750)
	claw:open()

	-- Move back
	--[[create.drive_segment(150, -220)
	create.drive_arc(150, 200, -45)
	create.drive_arc(150, -200, 39)]]--
	create.accel_straight(0, -230, 900)
	create.drive_segment(75, 50)
	create.spin_angle(150, 90)
	create.drive_segment(200, -110)
	create.drive_segment(150, 180)
	create.force_wait()
	arm:botbar()
	create.spin_angle(150, -90)
	create.drive_segment(150, -150)
	create.accel_straight(0, 300, 640)
	create.force_wait()
	arm:bmd()

	-- Go for blue one
	--create.accel_straight(0, 200, 285)
	claw:closed()
	arm:over_botbar()
	arm:bmd()
	create.drive_segment(200, -180)
	create.force_wait()

	arm:topbar()
	arm:bmd()
	create.drive_segment(150, 280)
	create.force_wait()
end

create.connect()
main()
create.disconnect()