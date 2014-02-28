local create = require("lualink.create")

function main()
	local claw = require("lualink.Servo"):new(1, {open = 700, closed = 1230})
	local arm = require("lualink.PosMotor"):new(1, 500, {neutral = 0, max=1400, topbar=1300})
	claw:closed()
	arm:max()

	create.drive_arc(255, -400, -55)
	create.drive_arc(255, 520, 51)
	create.drive_segment(150, 215)
	create.spin_angle(150, -80)
	create.drive_segment(150, 167)
	create.force_wait()

	arm:topbar()
	arm:bmd()
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