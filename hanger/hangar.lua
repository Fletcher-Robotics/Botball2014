local create = require("lualink.create")
local managers = require("lualink.managers")

local hanger = require("hanger")
local cube = require("cube")

function main()
    -- Add debug song
    create.load_song(0, {69, 71}, {16, 16})
    create.load_song(1, {71}, {8})

    -- Initialize the arm and claw
    claw = managers.Servo(0, {open = 500, half_open = 1075, closed = 1600})
    arm = managers.PosMotor(0, 600, {
        botbar=585, second_botbar=670,
        over_botbar=1300, second_over_botbar=875,
        max=2800, topbar=2300, last=2100,
        thread_the_needle=2150, ground_skim=200,
        cube=1950
    })
    button = managers.DigitalSensor(15)

    setup_procedure()
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

function setup_procedure()
    claw:closed() -- Force closed to start with
    -- arm:thread_the_needle() -- msleep afterwards during competition
    reset_position()
end


create.connect()
main()
create.disconnect()
