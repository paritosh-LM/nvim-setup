require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls","harper-ls", "typescript-language-server"}
vim.lsp.enable(servers)
