local create = require("lualink.create")
local manager = require("lualink.managers")
local msleep = require("lualink.time").msleep

function main()
	-- Initialize the arm and claw
	local claw = manager.Servo(0, {open = 700, closed = 1450})
	local arm = manager.PosMotor(0, 500, {neutral = 0, max=1350, topbar=1250, botbar=-190, over_botbar=-10, down=-400, thread_the_needle=800})
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
	create.drive_segment(200, -130) -- Back up until we hit the pipe to line up
	create.drive_segment(150, 175) -- Go forward, so that we are in place to get left hangar
	create.spin_angle(150, -90) -- Spin toward the hangars
	create.drive_segment(150, -150) -- Line up again, on the back pipe
	create.force_wait()
	arm:botbar() -- Start moving arm down to blue hangar level
	arm:bmd()
	create.accel_straight(0, 300, 600) -- Move all the way to the left blue hangar
	create.force_wait() -- Make sure the arm doesn't confuse the create
	
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
	create.drive_segment(100, 370) -- Move forward, a little further to account for the lost arm length
	create.force_wait() -- Ensure the create has finished it's instructions
	arm:topbar() -- Hang the hangars
	arm:bmd() -- Wait untill it's hung
	create.spin_angle(50, -2.5) -- Make sure it's on the bar
	create.force_wait() -- Wait before we open the claw
	claw:open() -- Drop the hangars

	-- Navigate to second blue
	create.spin_angle(50, 2.5) -- Move back to the correct orientation
	arm:topbar() arm:bmd() -- Move arm up so we don't get caught on bar
	create.accel_straight(0, -230, 900) -- Go all the way back.
	create.drive_segment(195, 230) -- Go straight along pipe
	create.drive_arc(200, -160, -45) -- Sepentine to right hangar
	create.drive_arc(200, 160, 40)
	create.force_wait()
	arm:bmd()
	arm:botbar() -- Move down to the bottom bar
	arm:bmd() -- Block until the arm is in position
	create.force_wait()

	-- Go for second blue
	claw:closed() -- Capture blue hangar
	arm:set_speed(350) -- Reduce arm speed
	arm:over_botbar() -- Start moving up
	arm:set_speed(500) -- Restore original speed
	msleep(220) -- Let the arm begin moving up
	create.drive_segment(100, 150) -- Go forward, so now the blue hangar is behind the white bar
	create.force_wait() -- Ensure the arm doesn't mess with navigation
	arm:bmd() -- Make sure the arm is in position
	arm:down() arm:bmd() -- Go all the way to the button, under the white bar
	create.drive_segment(200, -350) -- Begin to move back again
	arm:thread_the_needle() arm:bmd() -- Put the arm at the position to go between the bars
	create.drive_segment(200, 200) -- Put hangar between white bars
	arm:topbar() arm:bmd() -- Raise hangars to correct location
	create.drive_segment(200, -150) -- Move back so now hook is over bar
	create.spin_angle(200, 2.5) -- Spin a tad

	-- Cleanup
	create.force_wait()
end

create.connect()
main()
create.disconnect()
