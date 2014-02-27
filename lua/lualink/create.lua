local M = require "lualink.create_c"

function M.force_wait()
	M.sync()
	M.stop()
end

return M
