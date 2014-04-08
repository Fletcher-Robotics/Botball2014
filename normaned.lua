-- Import lualink (http://mml.stephenmac.com/static/lualink/) manager library
local managers = require "lualink.managers"
local msleep = require("lualink.time").msleep

function main()
	-- Setup Wheels using a WheelController
	local w = (require "lualink.WheelController"):new(
		{lp = 0, rp = 1, lm = 0.98, rm = 1,
		 ld = 62.5, rd = 62.5, lr = 80, rr = 80}
	)

	-- Setup Servos/PosMotors
	-- Elevator: On port 2, using 600 in order to avoid jerkiness
	--   Positions:
	--   - neutral: starting position, should be set up prior to starting program
	--   - push   : position for pushing the cube
	--   - botguy : position for grabbing botguy
	--   - cube   : position to put botguy on the cube
	--   - top    : highest position possible, for carrying botbuy above the cube
	--   Note: PosMotor contructor automatically resets the position counter, so elevator:neutral() at this point
	--     would do nothing.
	local elevator = managers.PosMotor(2, 600, {neutral = 0, push = 400, botguy = 575, cube = 1700, top = 2100})
	-- Claws: On ports 2 and 3, both are auto-enabled by Servo constructor
	local claw = managers.Servo(2, {open = 1900, closed = 850})
	local lowerClaw = managers.Servo(3, {open = 1100, closed = 400})

	-- Setup elevator and claw
	elevator:push()
	claw:open()

	-- Move to cube
	w:straight(200, 40)
	w:straight(550, 345)
	w:arc(710, 200, 90.4)

	-- Push Cube
	w:straight(400, 20) -- Add 20 if you merge
	w:straight(710, 330)

	-- Move to Botguy
	w:straight(600, -150) -- Go back
	w:spin(590, -90) -- Spin toward botguy
	w:wait()
	w:spin(590, -4) --correcting!
	elevator:botguy() -- Raise the elevator to botguy position
	w:straight(300, 20)
	w:straight(600, 240) -- Move straight to botguy
	w:wait() -- Make sure we're there

	-- Pick up botguy
	claw:closed()
	elevator:top()
	elevator:bmd()

	-- Go back to black tape position
	w:straight(600, -240)
	w:spin(900, 93) -- Spin toward the cube
	w:straight(300, 40)

	--Naviagte cube to green tape
	w:straight(350, 820)
	lowerClaw:closed() -- Close the lower claw so the cube doesn't shift
	w:spin(900, 60)
	w:straight(600, 500)

	-- Backup and lower
	lowerClaw:open()
	w:straight(300, -75)
	elevator:cube()
	elevator:bmd()

	--[[ Reset all
	claw:open() -- Open up the claw so we don't drag cube along
	w:straight(300, -150) -- Back up a little, don't hit botguy/cube with it
	elevator:neutral()
	elevator:bmd() -- Don't close the program until elevator is at neutral]]--

	-- Note: The garbage collector takes care of disabling servos and turning off motors.
	--   for more information, check the lualink docs: http://mml.stephenmac.com/static/lualink/
end

main()
