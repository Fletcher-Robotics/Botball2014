local create = require("lualink.create")
local sensor = require("lualink.sensor")
local managers = require "lualink.managers"
local msleep = require("lualink.time").msleep

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

return function()
    create.spin_angle(100, 83) -- Spin to the left of the board
    create.force_wait() -- Make sure all create actions are finished
    align_to_cube()
    arm:last() -- Move the arm down to the cube position
    create.drive_segment(180, 220) -- Drive to the cube
    create.force_wait() -- Make sure everything is finished before we close the claw
    arm:cube() arm:bmd() -- Move down a bit
    claw:closed() -- Close the claw over the cube
    msleep(300) -- Make sure the claw is closed before 
    create.drive_arc(280, -280, 45) -- Move back to line up
    create.drive_arc(240, 280, -34)
    create.drive_segment(200, -300) -- Line up
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
    create.drive_segment(200, -200)
end
