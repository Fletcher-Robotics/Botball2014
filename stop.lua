require ('lualink.motor').ao()

local servo = require 'lualink.servo'
for i = 0,3 do
    servo.disable_servo(i)
end
