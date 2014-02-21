local M = require"createlib"

function M.force_wait()
	M.sync()
	M.stop()
end

return M
