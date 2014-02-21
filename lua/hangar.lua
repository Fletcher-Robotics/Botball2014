local create = require("create")
local link = require("link")

function main ()
	local arm = link.PosMotor:new(1, 500, {neutral = 0, max = 1100})

	arm:max() -- Raise the arm
	create.drive_segment(250, 300) -- Go 20 cm
	create.force_wait()
	arm:bmd()
	arm:neutral() -- Lower the arm
	arm:bmd() -- Make sure the arm is completely lowered before the program ends
end

create.connect()
main()
create.disconnect()