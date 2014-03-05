local create = require("lualink.create")
local manager = require("lualink.managers")

function main()
	local claw = manager.Servo:new(0, {open = 700, closed = 1450})
	local arm = manager.PosMotor:new(0, 500, {neutral = 0, max=1400, topbar=1380})
	arm:max()

	create.drive_arc(255, -400, -55)
	create.drive_arc(255, 520, 51)
	create.drive_segment(150, 220)
	create.spin_angle(150, -87)
	create.drive_segment(150, 225)
	create.force_wait()

	arm:topbar()
	arm:bmd()
	claw:open()
end

function reset_arm(arm)
	arm:neutral()
	arm:bmd()
	arm:freeze()
end

create.connect()
main()
create.disconnect()
collectgarbage()