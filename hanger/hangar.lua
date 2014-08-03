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
    -- claw = managers.Servo(0, {open = 800, more_open = 400, half_open = 1275, idiotic_redundant_open = 1025, closed = 1850})
    claw = managers.PosMotor(1, 1500, {open = 900, half_open = 400, closed = 0})
    arm = managers.PosMotor(0, 700, {
        botbar=685, second_botbar=790,
        over_botbar=1400, second_over_botbar=975,
        max=2800, topbar=2300, last=2100,
        thread_the_needle=2150, ground_skim=290,
        cube=2100, align_cube=2550
    })
    button = managers.DigitalSensor(15)

    setup_procedure()
    hanger()
    -- Cube testing:
    -- arm:max() claw:open()
    -- cube()

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

function setup_procedure()
    claw:power(-20)
    reset_position()
end


create.connect()
main()
create.disconnect()
