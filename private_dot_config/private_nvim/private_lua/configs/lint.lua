local lint = require "lint"

local linters_by_ft = {
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  zsh = { "shellcheck" },
}

if vim.fn.executable "cmakelint" == 1 then
  linters_by_ft.cmake = { "cmakelint" }
elseif vim.fn.executable "cmake-lint" == 1 then
  linters_by_ft.cmake = { "cmake_lint" }
end

lint.linters_by_ft = linters_by_ft

local lint_group = vim.api.nvim_create_augroup("user_linting", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_group,
  callback = function()
    lint.try_lint()
  end,
})
