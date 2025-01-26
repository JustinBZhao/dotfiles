-- This is converted from the .vimrc file used in Vim

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

-- Unbind some useless/annoying default key bindings.
vim.keymap.set('n', 'Q', '<Nop>') -- 'Q' in normal mode enters Ex mode. You almost never want this.

-- Disable audible bell because it's annoying.
vim.o.errorbells = false
vim.o.visualbell = true

-- Try to prevent bad habits like using the arrow keys for movement. This is
-- not the only possible bad habit. For example, holding down the h/j/k/l keys
-- for movement, rather than using more efficient movement commands, is also a
-- bad habit. The former is enforceable through a .vimrc, while we don't know
-- how to prevent the latter.
-- Do this in normal mode...
vim.keymap.set('n', '<Left>',  ':echoe "Use h"<CR>')
vim.keymap.set('n', '<Right>', ':echoe "Use l"<CR>')
vim.keymap.set('n', '<Up>',    ':echoe "Use k"<CR>')
vim.keymap.set('n', '<Down>',  ':echoe "Use j"<CR>')
-- ...and in insert mode
vim.keymap.set('i', '<Left>',  '<ESC>:echoe "Use h"<CR>')
vim.keymap.set('i', '<Right>', '<ESC>:echoe "Use l"<CR>')
vim.keymap.set('i', '<Up>',    '<ESC>:echoe "Use k"<CR>')
vim.keymap.set('i', '<Down>',  '<ESC>:echoe "Use j"<CR>')

-- Set indentation
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.autoindent = true
vim.o.smartindent = true
vim.cmd('filetype plugin indent on')

--lazy vim
require('config.lazy')

--" The section about vim plugin (vim-plug)
--call plug#begin("~/.vim/plugged")
--Plug 'vim-airline/vim-airline'
--Plug 'vim-airline/vim-airline-themes'
--Plug 'tpope/vim-fugitive'
--Plug 'dense-analysis/ale'
--Plug 'neoclide/coc.nvim', {'branch': 'release'}
--Plug 'morhetz/gruvbox'
--" Plug 'jiangmiao/auto-pairs'
--Plug 'tpope/vim-commentary'
--call plug#end()
--
--" Set to use gruvbox color scheme
--let g:gruvbox_italic=1
--set background=dark
--colorscheme gruvbox
--
--" Set ALE options fomr C++ linters
--let g:ale_cpp_cc_options = '-std=c++23 -Wall -Wextra -Wpedantic -Wconversion'
--let g:ale_cpp_clangtidy_extra_options = '--std=c++23'
--let g:ale_cpp_cppcheck_options = '--enable=all --std=c++23 --suppress=missingIncludeSystem'
--let g:ale_linters = {'sh': ['shellcheck'], 'cpp':[]}
--
--" Coc extensions settings
--let g:coc_global_extensions = ['coc-json', 'coc-clangd', 'coc-cmake', 'coc-pyright']
--
--" Configure clangd server to use the latest C++ standard
--let g:coc_user_config = {
--            \ 'clangd.fallbackFlags': ['-std=c++23']
--            \}
--
--" Coc key mappings
--" List navigation: Ctrl-n down, Ctrl-p up
--inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"
--inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : "\<C-p>"
--
--" Press Tab to auto-complete
--inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#confirm() : "\<Tab>"
