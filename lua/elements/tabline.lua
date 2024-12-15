local M = {}

-- get harpoon files and convert into string.
function M.harpoon_files()
    local contents = {}
    local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")

    local marks_list = require("harpoon"):list()
    local marks_length = (marks_list and marks_list:length()) or 0

    -- if there are no marks to begin with, return blank.
    if marks_length == 0 then
        return "%#Blank#"
    end

    -- for each mark, insert into tabline table.
    for index = 1, marks_length do
        local mark = marks_list:get(index)
        if mark and mark.value then
            local harpoon_file_path = mark.value
            local file_name = (harpoon_file_path == "") and "(empty)" or vim.fn.fnamemodify(harpoon_file_path, ':t')

            if current_file_path == harpoon_file_path then
                contents[index] = string.format(
                    "%%#HarpoonNumberActive# %s. %%#HarpoonActive#%s ",
                    index,
                    file_name
                )
            else
                contents[index] = string.format(
                    "%%#HarpoonNumberInactive# %s. %%#HarpoonInactive#%s ",
                    index,
                    file_name
                )
            end
        end
    end

    -- set last element as blank highlight
    -- guarentees non-empty contents
    contents[#contents + 1] = "%#Blank#"
    return table.concat(contents)
end

-- set tabline.
vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.require('elements.tabline').harpoon_files()"

return M
