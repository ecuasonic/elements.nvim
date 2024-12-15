local M = {}

local statusline = require("utils.statusline_u")

-- table that holds custom statusbar content for each window.
local statuslines = {}

-- update the statusline for a window.
local function update_statusline(win_id)
    -- for windows that don't have statusline
    local get_config = vim.api.nvim_win_get_config
    local content = get_config(win_id).relative ~= "" and " " or statuslines[win_id] or "None"

    vim.api.nvim_set_option_value('statusline', content, { win = win_id })
end

-- autocmds to modify statusline table and update statusline in current and previous windows.
local autocmd = vim.api.nvim_create_autocmd
autocmd({ "BufWinEnter", "CursorHold" }, {
    callback = function()
        -- update statusline table.
        local contents = table.concat({
            "%=",
            statusline.get_branch(),
            "  ",
            vim.loop.os_gethostname(),
            " ",
            statusline.get_percentage(),
            " ",
            "%4l:%-2c",
            " "
        })

        local win_id = vim.fn.win_getid()
        statuslines[win_id] = contents ~= "" and contents or "None"
        -- update statusline in current window.
        update_statusline(win_id)
    end
})
autocmd({ "WinLeave" }, {
    callback = function()
        -- update statusline in previous window.
        local win_id = vim.fn.win_getid()
        update_statusline(win_id)
    end
})

-- set statusline
vim.opt.statusline = "%!v:lua.require('elements.statusline')";
vim.opt.laststatus = 3

return M
