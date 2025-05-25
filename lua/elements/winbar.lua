local M = {}

local winbar = require("utils.winbar_u")

local winbars = {}

-- used in both autocmds in this file.
--
-- update the winbar for a window.
--
---@param win_id integer Window id.
local function update_winbar(win_id)
    -- for windows that don't have winbar
    if vim.api.nvim_win_get_config(win_id).relative ~= "" then
        return
    end

    local content = winbars[win_id] or "None"
    vim.api.nvim_set_option_value('winbar', content, { win = win_id })
end

-- used in "VimResized" autocmd.
--
-- applies winbar.truncate_winbar to winbars on all windows.
local function truncate_all_winbars(min_length)
    local win_ids = vim.api.nvim_list_wins()
    if not win_ids or #win_ids == 0 then
        return
    end
    for i = 1, #win_ids do
        local win_id = win_ids[i]
        local contents = winbars[win_id]
        local win_width = vim.api.nvim_win_get_width(win_id)
        if win_width and win_width > 1 then
            winbars[win_id] = winbar.truncate_winbar(contents, min_length, win_width)
            update_winbar(win_id)
        end
    end
end

local max_path_length = 50
-- autocmds to continuously generate winbars.
local autocmd = vim.api.nvim_create_autocmd
autocmd({ "BufWinEnter", "WinLeave", "CursorHold", "VimResized" }, {
    callback = function()
        -- update winbar table.
        local contents = table.concat {
            " ",
            winbar.get_filepath(),
            " ",
            "%r%h%m",
            "%=",
            winbar.get_lsp_diagnostics(),
            " ",
            winbar.get_git_signs(),
            " ",
            winbar.get_size(),
            " ",
        }
        local win_id = vim.fn.win_getid()
        local win_width = vim.api.nvim_win_get_width(win_id)
        if win_width and win_width > 1 then
            -- winbars[win_id] = contents ~= "" and winbar.truncate_winbar(contents, win_width, win_width) or "None"
            winbars[win_id] = contents
            update_winbar(win_id)
        end
    end
})
-- autocmd to resize all winbars on VimResized event.
local timer
autocmd("VimResized", {
    callback = function()
        vim.cmd [[wincmd =]]
        -- if timer is counting, then reset timer
        if timer then
            timer:stop()
        end
        timer = vim.loop.new_timer()
        -- timeout for 100ms and no repeat.
        timer:start(100, 0, vim.schedule_wrap(function()
            truncate_all_winbars(max_path_length)
            vim.cmd [[mode]]
        end))
    end
})

-- set winbar
vim.opt.winbar = "%!v:lua.require('elements.winbar')";

return M
