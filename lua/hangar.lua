local create = require("create")
local link = require("linklib")

function main ()
	local up = 800
	local down = 0

	local function forward (d) print("Forward", d) create.drive_segment(200, d) end
	local function spin (a) print("Spin", a) create.spin_angle(100, a) end
	local function arc (r, a) print("Arc", r, a) create.drive_arc(200, r, a) end
	local function arm (p) print("Arm", p) link.mtp(1, 500, p) link.bmd(1) end

	arm(800)
	arc(-200, -90)
	arc(200, 90)
	forward(330)
	arc(-200, -84)
	create.sync()
	create.stop()
	create.sync()
	arm(0)
end

create.connect()
link.clear_motor_position_counter(1)
main()
create.disconnect()