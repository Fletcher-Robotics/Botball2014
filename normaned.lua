-- Import lualink (http://mml.stephenmac.com/static/lualink/) manager library
local managers = require "lualink.managers"

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
	local elevator = managers.PosMotor:new(2, 600, {neutral = 0, push = 400, botguy = 575, cube = 1700, top = 2100})
	-- Claws: On ports 2 and 3, both are auto-enabled by Servo constructor
	local claw = managers.Servo:new(2, {open = 1900, closed = 850})
	local lowerClaw = managers.Servo:new(3, {open = 1100, closed = 600})

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
	elevator:botguy() -- Raise the elevator to botguy position
	w:straight(300, 20)
	w:straight(600, 210) -- Move straight to botguy
	w:wait() -- Make sure we're there

	-- Pick up botguy
	claw:closed()
	elevator:top()
	elevator:bmd()

	-- Go back to black tape position
	w:straight(600, -240)
	w:spin(900, 107) -- Spin toward the cube

	--Naviagte cube to green tape
	w.straight(400, 70)
	mssleep(750)	
	w:straight(300, 750)
	lowerClaw:closed() -- Close the lower claw so the cube doesn't shift
	w:spin(900, 60)
	w:straight(200, 500)

	-- Backup and lower
	lowerClaw:open()
	w:straight(300, -75)
	elevator:cube()
	elevator:bmd()

	-- Reset all
	claw:open() -- Open up the claw so we don't drag cube along
	w:straight(300, -150) -- Back up a little, don't hit botguy/cube with it
	elevator:neutral()
	elevator:bmd() -- Don't close the program until elevator is at neutral

	-- Note: The garbage collector takes care of disabling servos and turning off motors.
	--   for more information, check the lualink docs: http://mml.stephenmac.com/static/lualink/
end

main()
