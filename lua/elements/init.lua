require('utils.highlights')

require('elements.statuscolumn')
require('elements.statusline')
require('elements.winbar')
require('elements.tabline')

local M = {}
function M.setup(config)
end

-- used for CursorHold autocmds
vim.opt.updatetime = 50

return M
