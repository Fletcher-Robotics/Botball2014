local create = require("lualink.create")
local manager = require("lualink.managers")
local msleep = require("lualink.time").msleep

function main()
	-- Initialize the arm and claw
	local claw = manager.Servo(0, {open = 700, closed = 1450})
	local arm = manager.PosMotor(0, 500, {neutral = 0, max=1300, topbar=1250, botbar=-190, over_botbar=-10})
	arm:max() -- Put at max

	-- Navigate to hangers
	create.drive_arc(255, -400, -55) -- Move out of starting box
	create.drive_arc(255, 520, 52) -- Move toward middle, face left
	create.drive_segment(170, 220) -- Now at middle
	create.spin_angle(160, -87.8) -- Spin toward hangars
	create.drive_segment(150, 240) -- Move to the hangars
	create.force_wait() -- Make sure everything is done

	-- Hang greens
	arm:topbar() -- Lower the hangars onto the bar
	arm:bmd() -- Wait until the hangars are actually on the bar
	msleep(500) -- Wait a bit before we open
	claw:open() -- Drop the hangars

	-- Move back and line up
	create.accel_straight(0, -230, 900) -- Go all the way back
	create.drive_segment(75, 50) -- Go slightly forward, so that we don't scrape
	create.spin_angle(150, 90) -- Spin toward the left
	create.drive_segment(200, -110) -- Back up until we hit the pipe to line up
	create.drive_segment(150, 180) -- Go forward, so that we are in place to get left hangar
	create.spin_angle(150, -90) -- Spin toward the hangars
	arm:botbar() -- Start moving arm down to blue hangar level
	create.drive_segment(150, -150) -- Line up again, on the back pipe
	create.accel_straight(0, 300, 600) -- Move all the way to the left blue hangar
	create.force_wait() -- Make sure the arm doesn't confuse the create
	arm:bmd() -- Wait until the arm is completely finished moving

	-- Go for blue one
	claw:closed() -- Close the claw
	msleep(100) -- Wait till it's closed
	arm:set_speed(350) -- Reduce the arm speed
	arm:over_botbar() -- Begin moving up over the bottom bar
	arm:set_speed(500) -- Make the speed faster again
	msleep(220) -- Let the arm begin moving up
	create.drive_segment(100, -250) -- Move back, clearing the bottom bar
	create.force_wait() -- Ensure the create has finished it's instructions
	arm:max() -- Start moving the arm up
	arm:bmd() -- Make sure it's at the top
	create.drive_segment(100, 350) -- Move forward, a little further to account for the lost arm length
	create.force_wait() -- Ensure the create has finished it's instructions
	arm:topbar() -- Hang the hangars
	arm:bmd() -- Wait untill it's hung
	create.spin_angle(50, -2.5) -- Make sure it's on the bar
	create.force_wait() -- Wait before we open the claw
	claw:open() -- Drop the hangars

	-- Navigate to second blue
	create.spin_angle(50, 2.5) -- Move back to the correct orientation
	arm:max() arm:bmd() -- Move arm up so we don't get caught on bar
	create.accel_straight(0, -230, 900) -- Go all the way back.
	--[[create.spin_angle(100, 90)
	create.drive_segment(100, -25)
	create.drive_segment(100, 70)
	create.spin_angle(100, -90)
	create.drive_segment(100, -7)]]--

	-- Cleanup
	create.force_wait()
end

create.connect()
main()
create.disconnect()