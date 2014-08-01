-- Import lualink (http://mml.stephenmac.com/static/lualink/) manager library
local managers = require "lualink.managers"
local msleep = require("lualink.time").msleep

function main()
    -- Setup Wheels using a WheelController
    local w = (require "lualink.WheelController"):new(
        {lp = 0, rp = 1, lm = 1, rm = 0.99,
         ld = 50, rd = 50, lr = 60, rr = 60}
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
    local elevator = managers.PosMotor(2, 600, {neutral = 0, push = 400, botguy = 595, cube = 1700, top = 2100})
    -- Claws: On ports 2 and 3, both are auto-enabled by Servo constructor
    local claw = managers.Servo(2, {open = 1900, closed = 850})
    local lowerClaw = managers.Servo(3, {open = 1100, closed = 400})

    -- Setup elevator and claw
    elevator:push()
    claw:open()

    -- Move to cube
    w:straight(1400, 200)
    w:arc(950, 200, 90) -- Really shouldn't have to use something other than 90 for the angle

    -- Push Cube
    w:straight(475, 20)
    w:straight(1400, 300)

    -- Move to Botguy
    w:straight(1400, -240) -- Go back
    w:spin(1300, -92) -- Spin toward botguy
    w:halt()
    elevator:botguy() elevator:bmd() -- Raise the elevator to botguy position
    w:straight(720, 20)
    w:straight(600, 146) -- Move straight to botguy
    w:halt()

    -- Pick up botguy
    claw:closed()
    elevator:top()
    elevator:bmd()

    -- Go back to black tape position
    w:straight(1300, -253)
    w:spin(1400, 93) -- Spin toward the cube
    w:straight(450, 40)

    --Naviagte cube to green tape
    w:straight(975, 370)
    w:halt()
    lowerClaw:closed() -- Close the lower claw so the cube doesn't shift
    w:spin(1300, 70)
    w:straight(975, 500)
    w:halt()

    -- Backup and lower
    lowerClaw:open()
    w:straight(450, -85)
    w:halt()
    elevator:cube()
    elevator:bmd()

    -- Reset all
    --[[claw:open() -- Open up the claw so we don't drag cube along
    w:straight(300, -150) -- Back up a little, don't hit botguy/cube with it
    elevator:neutral()
    elevator:bmd() -- Don't close the program until elevator is at neutral--]]

    -- Note: The garbage collector takes care of disabling servos and turning off motors.
    --   for more information, check the lualink docs: http://mml.stephenmac.com/static/lualink/
end

main()
