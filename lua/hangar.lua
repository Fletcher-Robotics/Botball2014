local create = require("create")
local link = require("link")

function main()
	local arm = link.PosMotor:new(1, 500, {neutral = 0, max=1420})
	arm:max()

	create.drive_arc(255, -400, -55)
	create.drive_arc(255, 520, 51)
	create.drive_segment(150, 215)
	create.spin_angle(150, -80)
	create.drive_segment(150, 100)
	create.force_wait()

	arm:bmd()
	arm:freeze()
end

function reset_arm(arm)
	arm:neutral()
	arm:bmd()
	arm:freeze()
end

create.connect()
main()
create.disconnect()