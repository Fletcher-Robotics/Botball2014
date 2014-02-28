local motor = require "lualink.motor"
local Servo = require "lualink.Servo"
local PosMotor = require "lualink.PosMotor"

function main()
	-- Setup Wheels
	local w = (require "lualink.WheelController"):new(
		{lp = 0, rp = 1, lm = 0.98, rm = 1,
		 ld = 62.5, rd = 62.5, lr = 80, rr = 80}
	)

	-- Setup Servos/PosMotors
	local elevator = PosMotor:new(2, 600, {neutral = 0, push = 400, botguy = 575, top = 2100, cube = 1700, lift = 900})
	local claw = Servo:new(2, {open = 1900, closed = 850})
	local lowerClaw = Servo:new(3, {open = 1100, closed = 600})

	-- Setup elevator and claw
	elevator:push()
	claw:open()

	-- Move to cube
	w:straight(200, 40)
	w:straight(400, 345)
	w:arc(600, 200, 90.4)

	-- Push Cube
	w:straight(610, 355)

	-- Move to Botguy
	w:straight(600, -163) -- Go back
	w:spin(900, -90) -- Spin toward botguy
	w:wait()
	elevator:botguy()
	w:wait()
	w:straight(300, 20)
	w:straight(600, 210) -- Move straight to botguy
	w:wait() -- Make sure we're there

	-- Pick up botguy
	claw:closed()
	elevator:top()
	w:wait()
	elevator:bmd()

	-- Go back
	w:straight(600, -240)
	w:spin(900, 100)	

	--Naviagte cube
	w:straight(590, 820)
	lowerClaw:closed()
	w:spin(900, 60)
	w:straight(500, 500)

	-- Backup and lower
	lowerClaw:open()
	w:straight(300, -75)
	elevator:cube()
	elevator:bmd()

	-- Reset all
	claw:open()
	w:straight(300, -200)
	elevator:neutral()
	elevator:bmd()
end

main()
collectgarbage()
motor.ao()
