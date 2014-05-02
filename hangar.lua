local create = require("lualink.create")
local managers = require("lualink.managers")
local sensor = require("lualink.sensor")
local msleep = require("lualink.time").msleep
local motor = require("lualink.motor")

function main()
	-- Add debug song
	create.load_song(0, {69, 71}, {16, 16})

	-- Initialize the arm and claw
	local claw = managers.Servo(0, {open = 550, closed = 1485, sorta_open = 950})
	local arm = managers.PosMotor(0, 500, {
		neutral = 0, down=-2100, botbar=-310, over_botbar=180,
		thread_the_needle=-500, max=1450, topbar=1450, last=1150, 
		second_botbar=-1950, second_over_botbar=-1800, second_hang=-210, cube=-410
	} )
	claw:closed() -- Force closed to start with
	arm:thread_the_needle() 

	arm:max()	

	-- Navigate to hangers
	create.drive_arc(255, -400, -55) -- Move out of starting box
	create.drive_arc(255, 520, 54) -- Move toward middle, face left
	create.drive_segment(170, 220) -- Now at middle
	create.spin_angle(160, -77) -- Spin toward hangars
	create.drive_segment(150, 210) -- Move to the hangars
	create.force_wait() -- Make sure everything is done

	-- Hang greens
	arm:topbar() -- Lower the hangars onto the bar
	arm:bmd() -- Wait until the hangars are actually on the bar
	msleep(500) -- Wait a bit before we open
	claw:open() -- Drop the hangars

	-- Move back and line up
	create.accel_straight(0, -230, 900) -- Go all the way back
	create.drive_segment(75, 50) -- Go slightly forward, so that we don't scrape
	create.spin_angle(135, 90) -- Spin toward the left
	create.drive_segment(250, -70) -- Back up until we hit the pipe to line up
	create.drive_segment(150, 178) -- Go forward, so that we are in place to get left hangar
	create.spin_angle(170, -90) -- Spin toward the hangars
	create.drive_segment(200, -100) -- Line up again, on the back pipe
	create.drive_segment(100, 20)
	create.force_wait()
	arm:botbar() arm:bmd() -- Start moving arm down to blue hangar level
	create.drive_segment(250, 470) -- Move all the way to the left blue hangar
	msleep(500)
	create.spin_angle(50, -1.5) -- doubly sure we are skr8 on the hanger
	create.force_wait() -- Make sure the arm doesn't confuse the create
	
	-- Go for blue one
	claw:closed() -- Close the claw
	-- msleep(100) -- Wait till it's closed
	arm:set_speed(500) -- Reduce the arm speed
	arm:over_botbar() -- Begin moving up over the bottom bar
	arm:set_speed(450) -- Make the speed faster again
	msleep(330) -- Let the arm begin moving up
	create.drive_segment(100, -250) -- Move back, clearing the bottom bar
	create.force_wait() -- Ensure the create has finished it's instructions
	arm:topbar() arm:bmd() -- Start moving the arm up
	arm:bmd() arm:set_position(1550) -- Make it go far up to the target position
	create.force_wait()
	create.spin_angle(50, -1.8) -- Make sure it's on the bar
	create.drive_segment(100, 380) -- Move forward, a little further to account for the lost arm length
	create.force_wait() -- Ensure the create has finished it's instructions
	arm:last() arm:bmd() -- Hang the hangars
	create.force_wait() -- Wait before we open the claw
	claw:sorta_open() -- Drop the hangars

	-- Navigate to second blue
	create.force_wait()
	create.accel_straight(0, -225, 910) -- Go all the way back.
	claw:open()
	arm:max()
	create.spin_angle(200, 90)
	create.drive_segment(200, -295)
	create.drive_segment(200, 31)
	create.spin_angle(200, -90)
	create.drive_segment(150, -60)
	create.drive_segment(250, 190) -- Go straight parallel to pipe
	create.drive_arc(240, -180, -45) -- Sepentine to right hangar
	create.drive_arc(240, 180, 34)
	create.force_wait()
	motor.clear_motor_position_counter(0)
	arm:second_botbar() arm:bmd() -- Move down to the bottom bar
	msleep(325)

	-- Go for second blue
	claw:closed() -- Capture blue hangar
	arm:set_speed(700) -- Reduce arm speed
	arm:second_over_botbar() -- Start moving up
	arm:set_speed(600) -- Restore original speed
	msleep(220) -- Let the arm begin moving up
	create.drive_segment(100, 140) -- Go forward, so now the blue hangar is behind the white bar
	create.force_wait() -- Ensure the arm doesn't mess with navigation
	arm:down() arm:bmd() -- Go all the way to the bottom, under the white bar
	create.drive_segment(200, -240) -- Begin to move back again
	create.force_wait()
	arm:thread_the_needle() arm:bmd() -- Put the arm at the position to go between the bars
	create.force_wait()
	create.spin_angle(50, -.75) -- Turn slightly right in order to make sure that we don't bump green hangers
	create.drive_segment(200, 310) -- Put hangar between white bars
	msleep(1000)
	create.force_wait()
	arm:neutral() -- Raise hangars to correct location
	create.drive_segment(100, -275) -- Move back so now hook is over bar
	create.spin_angle(200, 2.5) -- Spin a tad
	create.force_wait()
	claw:open() -- Release the hanger

	-- Go for the orange cube
	create.spin_angle(100, 72) -- Spin to the left of the board
	align_to_cube()
	arm:clear_position()
	create.force_wait() -- Make sure all create actions are finished
	arm:cube() -- Move the arm down to the cube position
	create.drive_segment(180, 220) -- Drive to the cube
	create.force_wait() -- Make sure everything is finished before we close the claw
	arm:mrp(-100) arm:bmd() -- Move down a bit
	claw:closed() -- Close the claw over the cube
	msleep(300) -- Make sure the claw is closed before 
	create.drive_arc(280, -280, 45) -- Move back to line up
	create.drive_arc(240, 280, -34)
	create.drive_segment(200, -280) -- Line up
	create.drive_segment(60, 30) -- Forward a tad
	create.spin_angle(180, 80) -- Twist
	create.force_wait()
	create.drive_straight(150) -- Drive forward...
	msleep(2000)
	create.wait_sensor("Bump") -- Until we hit the bumper!
	create.play_song(0) -- And make a sound
	create.stop()
	create.spin_angle(70, 2) -- Then take a little spin to the left
	create:force_wait()
	arm:second_over_botbar() arm:bmd() -- Put the arm down
	claw:open()
	msleep(500)
	arm:neutral()
	create.drive_segment(200, -200)

	-- Cleanup
	create.force_wait()
end

function block_until_blob_in_range(chan, obj_min, obj_max, low, high)
	repeat
		sensor.camera_update()
		local crit, count, x = false, sensor.get_object_count(chan)
		for obj_n = obj_min, obj_max do
			if count <= obj_n then break end
			x = sensor.get_object_center(chan, obj_n).x
			print(tostring(chan) .. ":" .. tostring(obj_n) .. " blob center at " .. tostring(x))
			crit = crit or (x and x < high and x > low)
		end
	until crit
	create.play_song(0)
end

function drive_by()
	create.drive_straight(180)
	block_until_blob_in_range(0, 0, 1, 77, 83)
	create.drive_segment(180, 210)
	create.force_wait()
end

function turn_til_cube()
	sensor.camera_update()
	create.spin_angle(280, -93)
	create.force_wait()
	msleep(1000)
	sensor.camera_update()
	create.spin(-30)
	block_until_blob_in_range(0, 0, 1, 75, 83)
	create.stop()
end

function align_to_cube()
	local camera_mount = managers.Servo(1, {forward = 850, right = 1800})

	-- Get started
	if sensor.camera_open() then
		camera_mount:right()
		drive_by()

		camera_mount:forward()
		turn_til_cube()

		sensor.camera_close() 
	else
		print("Unable to open camera")
	end
end

create.connect()
main()
create.disconnect()
