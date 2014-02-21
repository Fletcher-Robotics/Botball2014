local link = require("link")

function main()
	-- Setup Wheels
	local w = link.WheelController:new({lp = 0, rp = 1, lm = 0.98, rm = 1, ld = 62.5, rd = 62.5, lr = 80, rr = 80})

	-- Setup Servos/PosMotors
	local elevator = link.PosMotor:new(2, 600, {push = 400, botguy = 575, top = 2200, cube = 1700, lift = 900})
	local claw = link.Servo:new(2, {open = 1900, closed = 950})
	local lowerClaw = link.Servo:new(3, {open = 1100, closed = 0})

	-- Setup elevator and claw
	elevator:push()
	claw:open()

	-- Move to cube
	w:straight(500, 385)
	w:arc(600, 200, 90.4)

	-- Push Cube
	w:straight(610, 325)

	-- Move to Botguy
	w:straight(600, -145) -- Go back
	w:spin(550, -91) -- Spin toward botguy
	link.wait()
	elevator:botguy()
	link.wait()
	w:straight(600, 230) -- Move straight to botguy
	link.wait() -- Make sure we're there

	-- Pick up botguy
	claw:closed()
	elevator:top()
	link.wait()
	elevator:bmd()

	-- Go back
	w:straight(600, -240)
	w:spin(700, 92)	

	--Naviagte cube
	w:straight(590, 820)
	lowerClaw:closed()
	w:spin(700, 87)
	w:straight(500, 250)
	w.spin(700, 80)
	w.straight(400, 450)

	-- Backup and lower
	lowerClaw:open()
	w:straight(300, -500)
	elevator:cube()
	link.msleep(5000)

	-- Reset all
	claw:open()
end

main()
collectgarbage()
link.ao()
