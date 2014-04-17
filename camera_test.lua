local create = require("lualink.create")
local manager = require("lualink.managers")
local msleep = require("lualink.time").msleep
local sensor = require("lualink.sensor")

function spinner()
	repeat
		create.force_wait()
		sensor.camera_update()

		local x, is_conf
		if sensor.get_object_count(0) > 0 then
			local conf = sensor.get_object_confidence(0, 0)
			x = sensor.get_object_center(0, 0).x
			is_conf = conf > 0.6

			if is_conf and (x <= 75 or x >= 85) then
				offset = -0.05*(x-80)
				print("Moving " .. tostring(offset) .. " degrees",
					  "X: " .. tostring(x),
					  "Confidence: " .. tostring(conf)
				)
				create.spin_angle(100, offset)
			end
		end
	until x and is_conf and x < 85 and x > 75
	create.stop()
end

function getObjX()
	while true do
		sensor.camera_update()
		print(sensor.get_object_center(0, 0).x)
	end
end

function drive_by()
	create.drive_straight(100)
	repeat
		sensor.camera_update()
		local x
		if sensor.get_object_count(0) > 0 then
			x = sensor.get_object_center(0, 0).x
			print(x)
		end
	until x and x < 85 and x > 75
	create.stop()
end

create.connect()
if sensor.camera_open() then
	drive_by()
	sensor.camera_close()
end
create.disconnect()