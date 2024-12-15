-- Tabline harpoon.
vim.cmd([[hi HarpoonNumberActive ctermfg=255 guifg=orange guibg=#010005]])
vim.cmd([[hi HarpoonActive ctermfg=255 guifg=cyan guibg=#010005]])
vim.cmd([[hi HarpoonNumberInactive ctermfg=255 guifg=orange guibg=#010005]])
vim.cmd([[hi HarpoonInactive ctermfg=255 guifg=white guibg=#010005]])

-- Winbar diff.
vim.cmd([[hi DiffAdded guifg=#a1cd5e]])
vim.cmd([[hi DiffChanged guifg=#e3d18a]])
vim.cmd([[hi DiffRemoved guifg=#fc514e]])

-- Statuscolumn colors.
vim.cmd([[hi CustomLineNr guifg=white guibg=#74125C gui=bold]])

-- Elements highlights.
vim.cmd([[hi ModeMsg ctermfg=10 gui=NONE guifg=NvimLightGreen]])
vim.cmd([[hi WinBar ctermfg=10 gui=NONE guibg=NONE guifg=white]])
vim.cmd([[hi StatusLine ctermfg=10 gui=NONE guibg=NONE guifg=white]])
vim.cmd([[hi Winseparator guifg=orange]])

-- Generic colors.
vim.cmd([[hi White guifg=white]])
vim.cmd([[hi Blank guifg=white]])
vim.cmd([[hi Green guifg=NvimLightGreen]])
