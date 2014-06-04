local create = require("lualink.create")
local msleep = require("lualink.time").msleep

function green_hanger(arm, claw)
	-- Navigate to hanger bar
	create.drive_arc(255, -400, -55) -- Move out of starting box
	create.drive_arc(255, 520, 54) -- Move toward middle, face left
	create.drive_segment(170, 220) -- Now at middle
	create.spin_angle(160, -77) -- Spin toward hangars
	create.drive_segment(150, 170) -- Move to the hangars
	create.force_wait() -- Make sure everything is done

	-- Hang greens
	arm:topbar() -- Lower the hangars onto the bar
	arm:bmd() -- Wait until the hangars are actually on the bar
	arm:freeze()
	msleep(500) -- Wait a bit before we open
	claw:half_open() -- Drop the hangars
end

function first_blue_hanger(arm, claw)
	-- Move back and line up
	create.accel_straight(0, -230, 900) -- Go all the way back
	create.drive_segment(75, 50) -- Go slightly forward, so that we don't scrape
	claw:open()
	create.spin_angle(135, 90) -- Spin toward the left
	create.drive_segment(250, -70) -- Back up until we hit the pipe to line up
	create.drive_segment(150, 178) -- Go forward, so that we are in place to get left hangar
	create.spin_angle(170, -90) -- Spin toward the hangars
	create.drive_segment(200, -100) -- Line up again, on the back pipe
	create.drive_segment(100, 20)
	create.force_wait()
	arm:botbar() arm:bmd() -- Start moving arm down to blue hangar level
	create.drive_segment(260, 455) -- Move all the way to the left blue hangar
	msleep(500)
	create.spin_angle(50, -1.5) -- doubly sure we are straight on the hanger
	create.force_wait() -- Make sure the arm doesn't confuse the create
	
	-- Go for blue one
	claw:closed() -- Close the claw
	arm:over_botbar() -- Begin moving up over the bottom bar
	msleep(330) -- Let the arm begin moving up
	create.drive_segment(100, -250) -- Move back, clearing the bottom bar
	create.force_wait() -- Ensure the create has finished it's instructions
	arm:max() -- Start moving the arm up
	create.force_wait()
	create.spin_angle(50, -1.8) -- Make sure it's on the bar
	create.drive_segment(100, 410) -- Move forward, a little further to account for the lost arm length
	create.force_wait() -- Ensure the create has finished it's instructions
	arm:last() arm:bmd() -- Hang the hangars
	create.force_wait() -- Wait before we open the claw
	claw:half_open() -- Drop the hangars
end

function second_blue_hanger(arm, claw)
	-- Navigate to second blue
	create.force_wait()
	create.accel_straight(0, -225, 910) -- Go all the way back.
	arm:max()
	claw:open()
	create.spin_angle(200, 90)
	create.drive_segment(200, -295)
	create.drive_segment(200, 31)
	create.spin_angle(200, -90)
	create.drive_segment(150, -60)
	create.drive_segment(250, 205) -- Go straight parallel to pipe
	create.drive_arc(240, -180, -45) -- Sepentine to right hangar
	create.drive_arc(240, 180, 34)
	create.force_wait()
	arm:clear_position()
	arm:second_botbar() arm:bmd() -- Move down to the bottom bar, NEEDS TO BE REPLACED
	msleep(325)

	-- Go for second blue
	claw:closed() -- Capture blue hangar
	arm:second_over_botbar() -- Start moving up, NEEDS TO BE REPLACED
	msleep(220) -- Let the arm begin moving up
	create.drive_segment(100, 140) -- Go forward, so now the blue hangar is behind the white bar
	create.force_wait() -- Ensure the arm doesn't mess with navigation
	arm:down() arm:bmd() -- Go all the way to the bottom, under the white bar
	create.drive_segment(200, -240) -- Begin to move back again
	create.force_wait()
	arm:thread_the_needle() arm:bmd() -- Put the arm at the position to go between the bars
	create.force_wait()
	create.drive_segment(200, 310) -- Put hangar between white bars
	msleep(1000)
	create.force_wait()
	arm:neutral() -- Raise hangars to correct location, NEEDS TO BE REPLACED
	create.drive_segment(100, -275) -- Move back so now hook is over bar
	create.force_wait()
	claw:open() -- Release the hanger
end

return function(arm, claw)
	arm:max()

	green_hanger(arm, claw)
	first_blue_hanger(arm, claw)
	second_blue_hanger(arm, claw)
end