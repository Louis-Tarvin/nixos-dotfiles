local lsp_status = require('lsp-status')

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

return capabilities
