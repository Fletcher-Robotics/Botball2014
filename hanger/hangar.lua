local create = require("lualink.create")
local managers = require("lualink.managers")

local hanger = require("hanger")
local cube = require("cube")

function main()
	-- Add debug song
	create.load_song(0, {69, 71}, {16, 16})

	-- Initialize the arm and claw
	local claw = managers.Servo(0, {open = 750, half_open = 1400, closed = 1975})
	local arm = managers.PosMotor(0, 600, {
		neutral = 0, down=-2100, botbar=-370, over_botbar=180,
		thread_the_needle=-500, max=1750, topbar=1300, last=1050,
		second_botbar=-1750, second_over_botbar=-1600, second_hang=-280, cube=-400
	})

	setup_procedure(claw, arm)

	hanger(arm, claw)
	cube(arm, claw)

	-- Cleanup
	create.force_wait()
end

function reset_position(arm, button)
	arm:power(-25)
	button:block_until(function(v) return v end)
	--arm:clear_position()
	arm:freeze()
end

function setup_procedure(claw, arm)
	claw:closed() -- Force closed to start with
	-- arm:thread_the_needle() -- msleep afterwards during competition
	-- reset_position()
end


create.connect()
main()
create.disconnect()
