local M = {}

function M.get_branch()
    return "%#Green#" .. vim.fn["FugitiveHead"]() .. "%#White#"
end

function M.get_percentage()
    local lines = vim.api.nvim_buf_line_count(0)
    local row = (vim.api.nvim_win_get_cursor(0))[1]
    if (row == 1) then
        return " Top"
    elseif (row == lines) then
        return " Bot"
    end
    return string.format("%3.0f", (row / lines) * 100) .. "%%"
end

return M
