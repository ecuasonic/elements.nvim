local M = {}

-- set highlight and number value for current line and non-current lines.
function M.numbers()
    local text = ""

    if vim.v.virtnum == 0 then
        if vim.v.relnum == 0 then
            text = text .. "%=%#CustomLineNr# " .. string.format("%4s", vim.v.lnum) .. " %* "
        else
            text = text .. "%=%#White# " .. string.format("%4s", vim.v.relnum) .. " %* "
        end
    end

    return text
end

-- convert table into string
function M.statuscol()
    local text = ""
    text = table.concat({
        "%s",
        M.numbers(),
    })
    return text
end

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.signcolumn = "yes"
vim.opt.statuscolumn = "%!v:lua.require('elements.statuscolumn').statuscol()";

return M
