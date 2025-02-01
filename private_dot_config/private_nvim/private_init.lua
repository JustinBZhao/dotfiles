-- This is converted from the .vimrc file used in Vim
require('core.options')
require('core.keymaps')

--lazy vim
require('config.lazy')

--" The section about vim plugin (vim-plug)
--call plug#begin("~/.vim/plugged")
--Plug 'tpope/vim-fugitive'
--Plug 'dense-analysis/ale'
--Plug 'neoclide/coc.nvim', {'branch': 'release'}
--" Plug 'jiangmiao/auto-pairs'
--Plug 'tpope/vim-commentary'
--call plug#end()
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
