-- plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- plugin setup
-- require lazy in safety mode
local status, lazy = pcall(require, "lazy")
if not status then
    return vim.notify("lazy is not installed.")
end

vim.g.mapleader = " "

require("lazy").setup({
    {
        "ecuasonic/elements.nvim",
        dependencies = {
            {
                "theprimeagen/harpoon",
                branch = "harpoon2",
                dependencies = { "nvim-lua/plenary.nvim" },
                config = function()
                    local harpoon = require("harpoon")
                    harpoon.setup()

                    vim.keymap.set("n", "<leader>a", function()
                        harpoon:list():add()
                        vim.cmd([[mode]])
                    end, { desc = "Add current file to Harpoon." })
                    vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
                        { desc = "Toggle Harpoon menu" })

                    vim.keymap.set("n", "<Space>1", function() harpoon:list():select(1) end,
                        { desc = "harpoon to file 1" })
                    vim.keymap.set("n", "<Space>2", function() harpoon:list():select(2) end,
                        { desc = "harpoon to file 2" })
                    vim.keymap.set("n", "<Space>3", function() harpoon:list():select(3) end,
                        { desc = "harpoon to file 3" })
                    vim.keymap.set("n", "<Space>4", function() harpoon:list():select(4) end,
                        { desc = "harpoon to file 4" })
                    vim.keymap.set("n", "<Space>5", function() harpoon:list():select(5) end,
                        { desc = "harpoon to file 5" })
                    vim.keymap.set("n", "<Space>6", function() harpoon:list():select(6) end,
                        { desc = "harpoon to file 6" })
                    vim.keymap.set("n", "<Space>7", function() harpoon:list():select(7) end,
                        { desc = "harpoon to file 7" })
                    vim.keymap.set("n", "<Space>8", function() harpoon:list():select(8) end,
                        { desc = "harpoon to file 8" })
                end
            },
            "lewis6991/gitsigns.nvim",
            "tpope/vim-fugitive",
        },
        config = function()
            require('elements')
        end
    },
})

package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
