-- Turn on syntax highlighting.
vim.cmd('syntax on')

-- Disable the default Vim startup message.
--vim.o.shortmess += I

-- Show line numbers.
vim.o.number = true

-- This enables relative line numbering mode. With both number and
-- relativenumber enabled, the current line shows the true line number, while
-- all other lines (above and below) are numbered relative to the current line.
-- This is useful because you can tell, at a glance, what count is needed to
-- jump up or down to a particular line, by {count}k to go up or {count}j to go
-- down.
vim.o.relativenumber = true

-- Always show the status line at the bottom, even if you only have one window open.
vim.o.laststatus = 2

-- The backspace key has slightly unintuitive behavior by default. For example,
-- by default, you can't backspace before the insertion point set with 'i'.
-- This configuration makes backspace behave more reasonably, in that you can
-- backspace over anything.
vim.o.backspace = "indent,eol,start"

-- By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
-- shown in any window) that has unsaved changes. This is to prevent you from "
-- forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
-- hidden buffers helpful enough to disable this protection. See `:help hidden`
-- for more information on this.
vim.o.hidden = true

-- This setting makes search case-insensitive when all characters in the string
-- being searched are lowercase. However, the search becomes case-sensitive if
-- it contains any capital letters. This makes searching more convenient.
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable searching as you type, rather than waiting till you press enter.
vim.o.incsearch = true

-- Disable audible bell because it's annoying.
vim.o.errorbells = false
vim.o.visualbell = true

-- Set indentation
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.autoindent = true
vim.o.smartindent = true
vim.cmd('filetype plugin indent on')
