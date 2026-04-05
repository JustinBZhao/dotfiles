return {
    {
        "nvim-lualine/lualine.nvim",
        -- event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "papercolor_light",
            },
        },
    },

    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.8",
        -- cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim" },
        -- keys = {
        --     { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        --     { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        --     { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        -- },
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        -- keys = {
        --     { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer" },
        -- },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    },
}
