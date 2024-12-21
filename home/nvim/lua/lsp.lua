-- Mason Setup
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})
require("mason-lspconfig").setup()

require("lspconfig")["pyright"].setup({
    capabilities = require('lsp.capabilities'),
    on_attach = require('lsp.attach')
})
