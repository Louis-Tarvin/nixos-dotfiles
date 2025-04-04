local attach = require('lsp.attach')

local opts = {
  tools = { -- rust-tools options
    inlay_hints = {
      auto = true,
      show_parameter_hints = false,
      parameter_hints_prefix = '',
      other_hints_prefix = '',
      max_len_align = true,
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
  server = {
    on_attach = attach,
    --capabilities = capabilities,
    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ['rust-analyzer'] = {
        checkOnSave = {
          command = 'clippy',
        },
        cargo = {
          allFeatures = true,
        },
      },
    },
  },
}

require('rust-tools').setup(opts)
