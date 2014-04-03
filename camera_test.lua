local create = require("lualink.create")
local manager = require("lualink.managers")
local msleep = require("lualink.time").msleep
local sensor = require("lualink.sensor")

function main()
	create.drive_straight(200)
	repeat
		sensor.camera_update()
		local y = sensor.get_object_center(0, 0).y
		if y > 79 then
			create.drive_direct(90, 130)
		else
			create.drive_direct(130, 90)
		end
		local area = sensor.get_object_area(0, 0)
		print(area)
	until area > 500
	create.stop()
end

create.connect()
if sensor.camera_open() then
	main()
	sensor.camera_close()
end
create.disconnect()