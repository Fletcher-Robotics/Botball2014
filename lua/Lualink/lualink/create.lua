--- @module create
local M = require "lualink.create_c"

--- Convenience
-- @section convenience

--- Sync then make sure the create stops. Should be run
-- after successive create movement commands, especially when
-- some other operation is going on at the same time
-- @see sync
-- @see stop
function M.force_wait()
	M.sync()
	M.stop()
end

return M
