local M = {}

-- Helper function.
-- Used in M.truncate_winbar
--
-- Completely truncates each direction/file name to single character.
--
---@param components table Contains directory/file names.
local function complete_truncate(components)
    for i, component in ipairs(components) do
        local first_char = component:sub(1, 1)
        components[i] = first_char == '.' and component:sub(1, 2) or first_char
    end
end

-- Helper function.
-- Used in M.truncate_winbar
--
-- Truncates not-already-truncated elements of (components)
-- until truncated_path is less than half_width.
--
---@param path string Contains only path.
---@param components table Contains directory/file names.
---@param half_width integer Constant half width of window.
---@return string truncated_path
local function truncation(path, components, half_width)
    local truncated_path = path
    for i, component in ipairs(components) do
        if #component > 1 and i ~= #components then
            local first_char = component:sub(1, 1)
            components[i] = first_char == '.' and component:sub(1, 2) or first_char
            truncated_path = table.concat(components, "/")
            if #truncated_path <= half_width then
                break
            end
        end
    end
    return truncated_path
end

-- Main function to truncate winbar contents.
--
---@param contents string: Untrucated winbar string.
---@param max_path_length integer: Maximum length of path.
---@param win_width integer: Window width.
---@return string truncated_winbar: Truncated winbar string.
function M.truncate_winbar(contents, max_path_length, win_width)
    if not contents then
        return contents
    end
    local path = string.match(contents, "^%s*(%S+)")
    local half_width = math.floor(win_width / 2)

    -- if max_path_length is valid and less than half_width:
    if max_path_length and max_path_length > 0 and max_path_length < half_width then
        half_width = max_path_length
    end

    if #path <= half_width then
        return contents
    end

    -- split the path into components.
    local components = {}
    for component in string.gmatch(path, "([^/]+)") do
        table.insert(components, component)
    end

    -- If more components + '/' than half_width then
    --      completely truncate the path.
    -- Else
    --      truncate the path until path < half_width.
    -- End
    if #components * 2 > half_width then
        complete_truncate(components)
        path = table.concat(components, "/")
    else
        path = truncation(path, components, half_width)
    end
    path = (string.sub(path, 1, 1) == "~" and "" or "/") .. path

    -- reconstruct winbar.
    local path_striped_winbar = contents:gsub("^%s*(%S+)", "")
    return " " .. path .. path_striped_winbar
end

function M.get_filepath()
    local path = vim.fn.expand("%:p")
    path = string.gsub(path, "^/home/[^/]*", "~")
    return path
end

function M.get_lsp_diagnostics()
    local prefix = {
        error = " %#DiagnosticSignError# ",
        warn = " %#DiagnosticSignWarn# ",
        info = " %#DiagnosticSignHint#󰛩 ",
        hint = " %#DiagnosticSignInfo# "
    }
    local diagnostics = {
        error = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
        warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
        info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
        hint = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }),
    }

    local output = {}
    for key, val in pairs(diagnostics) do
        if val ~= 0 then
            table.insert(output, prefix[key] .. val .. "%#White#")
        end
    end

    if #output == 0 then
        return ""
    else
        return " " .. table.concat(output)
    end
end

function M.get_git_signs()
    local prefix = {
        added = " %#DiffAdded#+",
        changed = " %#DiffChanged#~",
        removed = " %#DiffRemoved#-"
    }
    local status = {}

    local dict = vim.b.gitsigns_status_dict
    for _, key in ipairs({ "added", "changed", "removed" }) do
        if dict and dict[key] and dict[key] ~= 0 then
            table.insert(status, prefix[key] .. dict[key] .. "%#White#")
        end
    end

    if #status == 0 then
        return ""
    else
        return table.concat(status)
    end
end

M.get_size = function()
    local file_path = vim.fn.expand("%:p")
    if file_path == "" or vim.fn.filereadable(file_path) == 0 then
        return " 0 B"
    end

    local stat = vim.loop.fs_stat(file_path)
    if stat then
        local size = stat.size
        if size < 1024 then
            return " " .. size .. " B"
        elseif size < 1024 * 1024 then
            return string.format(" %.1f KB", size / 1024)
        elseif size < 1024 * 1024 * 1024 then
            return string.format(" %.1f MB", size / 1024 * 1024)
        else
            return string.format(" %.1f GB", size / 1024 * 1024 * 1024)
        end
    else
        return " (Error) 0 B"
    end
end

return M
