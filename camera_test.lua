local create = require("lualink.create")
local managers = require("lualink.managers")
local msleep = require("lualink.time").msleep
local sensor = require("lualink.sensor")

camera_mount = managers.Servo(1, {forward = 800, right = 1800})
function block_until_blob_in_range(chan, obj_n, low, high)
	repeat
		sensor.camera_update()
		local x
		if sensor.get_object_count(chan) > obj_n then
			x = sensor.get_object_center(chan, obj_n).x
			print(tostring(chan) .. ":" .. tostring(obj_n) .. " blob center at " .. tostring(x))
		end
	until x and x < high and x > low
end

function drive_by()
	create.drive_straight(100)
	block_until_blob_in_range(0, 0, 75, 85)
	create.stop()
	sensor.camera_close()
end

function turn_til_cube()
	create.spin(200)
	block_until_blob_in_range(0, 0, 75, 85)
	create.stop()
	sensor.camera_close()
end

create.connect()
if sensor.camera_open() then
	camera_mount:right()
	drive_by()
	camera_mount:forward()
	create.force_wait()
	turn_til_cube()
	sensor.camera_close()
else
	print("Unable to open camera")
end
create.disconnect()