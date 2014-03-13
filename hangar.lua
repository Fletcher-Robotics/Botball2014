local create = require("lualink.create")
local manager = require("lualink.managers")
local msleep = require("lualink.time").msleep

function main()
	-- Initialize the arm and claw
	local claw = manager.Servo(0, {open = 800, closed = 1650})
	local arm = manager.PosMotor(0, 450, {
		neutral = 0, down=-400, botbar=-145, over_botbar=180,
		thread_the_needle=850, max=1500, topbar=1350,
		second_botbar=-200, second_over_botbar=-10
	})
	claw:closed() -- Force closed to start with
	arm:max() -- Put at max
	--msleep(3500) -- Wait until the other bot is out of the way

	-- Navigate to hangers
	create.drive_arc(255, -400, -55) -- Move out of starting box
	create.drive_arc(255, 520, 52) -- Move toward middle, face left
	create.drive_segment(170, 220) -- Now at middle
	create.spin_angle(160, -87.8) -- Spin toward hangars
	create.drive_segment(150, 225) -- Move to the hangars
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
	create.drive_segment(250, -140) -- Back up until we hit the pipe to line up
	create.drive_segment(150, 168) -- Go forward, so that we are in place to get left hangar
	create.spin_angle(170, -90) -- Spin toward the hangars
	create.drive_segment(200, -130) -- Line up again, on the back pipe
	create.force_wait()
	arm:botbar() arm:bmd() -- Start moving arm down to blue hangar level
	create.accel_straight(0, 380, 570) -- Move all the way to the left blue hangar
	create.force_wait() -- Make sure the arm doesn't confuse the create
	
	-- Go for blue one
	claw:closed() -- Close the claw
	msleep(100) -- Wait till it's closed
	arm:set_speed(350) -- Reduce the arm speed
	arm:over_botbar() -- Begin moving up over the bottom bar
	arm:set_speed(450) -- Make the speed faster again
	msleep(330) -- Let the arm begin moving up
	create.drive_segment(100, -250) -- Move back, clearing the bottom bar
	create.force_wait() -- Ensure the create has finished it's instructions
	arm:topbar() arm:bmd() -- Start moving the arm up
	arm:max() -- Make it go far up to the target position
	create.spin_angle(50, -1.5) -- Make sure it's on the bar
	create.drive_segment(100, 390) -- Move forward, a little further to account for the lost arm length
	create.force_wait() -- Ensure the create has finished it's instructions
	arm:topbar() arm:bmd() -- Hang the hangars
	create.force_wait() -- Wait before we open the claw
	claw:open() -- Drop the hangars

	-- Navigate to second blue
	create.spin_angle(50, 1.5) -- Move back to the correct orientation
	arm:topbar() arm:bmd() -- Move arm up so we don't get caught on bar
	create.accel_straight(0, -225, 910) -- Go all the way back.
	create.spin_angle(200, 90)
	create.drive_segment(200, -160)
	create.drive_segment(200, 20)
	create.spin_angle(200, -90)
	create.drive_segment(150, -60)
	create.drive_segment(250, 200) -- Go straight parallel to pipe
	create.drive_arc(240, -180, -45) -- Sepentine to right hangar
	create.drive_arc(240, 180, 34)
	create.force_wait()

	arm:second_botbar() arm:bmd() -- Move down to the bottom bar

	-- Go for second blue
	claw:closed() -- Capture blue hangar
	arm:set_speed(350) -- Reduce arm speed
	arm:second_over_botbar() -- Start moving up
	arm:set_speed(450) -- Restore original speed
	msleep(220) -- Let the arm begin moving up
	create.drive_segment(100, 150) -- Go forward, so now the blue hangar is behind the white bar
	create.force_wait() -- Ensure the arm doesn't mess with navigation
	arm:bmd() -- Make sure the arm is in position
	arm:down() arm:bmd() -- Go all the way to the button, under the white bar
	create.drive_segment(200, -350) -- Begin to move back again
	arm:thread_the_needle() arm:bmd() -- Put the arm at the position to go between the bars
	create.force_wait()
	create.drive_segment(200, 500) -- Put hangar between white bars
	arm:topbar() arm:bmd() -- Raise hangars to correct location
	create.drive_segment(200, -150) -- Move back so now hook is over bar
	create.spin_angle(200, 2.5) -- Spin a tad

	-- Cleanup
	create.force_wait()
end

create.connect()
main()
create.disconnect()
