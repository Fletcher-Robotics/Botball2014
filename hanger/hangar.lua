local create = require("lualink.create")
local managers = require("lualink.managers")

local hanger = require("hanger")
local cube = require("cube")

local msleep = require("lualink.time").msleep

function main()
    -- Add debug song
    create.load_song(0, {69, 71}, {16, 16})
    create.load_song(1, {71}, {8})
    -- create.load_song()

    -- Initialize the arm and claw
    claw = managers.Servo(0, {open = 800, more_open = 400, half_open = 1275, idiotic_redundant_open = 1025, closed = 1850})
    arm = managers.PosMotor(0, 700, {
        botbar=585, second_botbar=690,
        over_botbar=1300, second_over_botbar=875,
        max=2800, topbar=2300, last=2100,
        thread_the_needle=2150, ground_skim=200,
        cube=2100, align_cube=2550
    })
    button = managers.DigitalSensor(15)

    gcer_setup_procedure()
    hanger()
    -- Cube testing:
    --arm:max() claw:open()
    cube()

    -- Cleanup
    create.force_wait()
end

function reset_position()
    arm:power(-25)
    button:block_until(function(v) return v end)
    create.play_song(1)
    arm:clear_position()
    arm:freeze()
end

function gcer_setup_procedure()
    claw:closed() -- Force closed to start with
    msleep(5000) -- Wait for small bot to get out of the way
    reset_position() -- Make botttom 0
    arm:thread_the_needle() -- msleep afterwards during competition
    msleep(12000) -- Wait for small bot to arrive to the middle of the board
end

function setup_procedure()
    claw:closed()
    reset_position()
end


create.connect()
main()
create.disconnect()
