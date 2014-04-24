local create = require("lualink.create")
local managers = require("lualink.managers")
local msleep = require("lualink.time").msleep
local sensor = require("lualink.sensor")

camera_mount = managers.Servo(1, {forward = 850, right = 1800})
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
end

function drive_by()
	camera_mount:right()
	create.drive_straight(180)
	block_until_blob_in_range(0, 0, 1, 77, 83)
end

function turn_til_cube()
	camera_mount:forward()
	sensor.camera_update()
	create.spin_angle(280, -95)
	create.force_wait()
	sensor.camera_update()
	create.spin(-35)
	block_until_blob_in_range(0, 0, 1, 77, 83)
	create.stop()
end

create.connect()
if sensor.camera_open() then
	drive_by()
	create.drive_segment(180, 220)
	create.force_wait()
	turn_til_cube()
	sensor.camera_close()
	create.drive_segment(180, 220)
else
	print("Unable to open camera")
end
create.disconnect()