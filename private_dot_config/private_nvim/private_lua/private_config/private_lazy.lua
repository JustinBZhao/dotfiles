--Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)  -- append to runtime path

-- Setup lazy.nvim
require("lazy").setup({
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = "papercolor_light",
            },
        },
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        }
    },
    -- The e-ink colorscheme, but does not work currently
    -- {
    --     'JWW127/theink',
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.cmd("colorscheme theink")
    --     end,
    -- },
    --
    -- spec = {
    --     -- import your plgins
    --     { import = "plugins" },
    -- },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    --install = { colorscheme = { "habamax" } },
    install = {},
    -- automatically check for plugin updates
    checker = { enabled = true },
})

-- Make a light colorscheme on e-ink devices
-- vim.opt.background = "light"

-- Make the cursor black on white background?
-- vim.opt.termguicolors = true
-- vim.opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-CursorInsert/lCursorInsert,r-cr:hor20,sm:block"
-- vim.cmd("highlight Cursor guifg=black guibg=#000000")
-- vim.cmd("highlight CursorInsert guifg=black guibg=#000000")
