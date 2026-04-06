require("nvchad.configs.lspconfig").defaults()

local servers = { 
    "html", 
    "cssls",
    "clangd",
    "cmake",
    "pyright",
    "jsonls",
    "bashls",
}

vim.lsp.config("clangd", {
    init_options = {
        fallbackFlags = {
            "-std=c++23",
            "-Wall",
            "-Wextra",
            "-Wpedantic",
            "-Wconversion",
        },
    },
})

vim.lsp.enable(servers)
