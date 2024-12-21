local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Misc
  use('nvim-lua/plenary.nvim')

  -- GUI
  use { 'sainnhe/edge' }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function() require 'nvim-tree'.setup {}
    end
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use { 'machakann/vim-highlightedyank' }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
      }
    end
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }
  use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons' }
  use "lukas-reineke/indent-blankline.nvim"
  use "https://github.com/RRethy/vim-illuminate"
  use('miyakogi/conoline.vim')
  use {
    'goolord/alpha-nvim', -- startup screen
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
}

  -- Utilities
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use('tpope/vim-sleuth')
  use('tpope/vim-surround')
  use('jiangmiao/auto-pairs')
  use {
    'winston0410/commented.nvim',
    config = function()
      require('commented').setup()
    end
  }
  --  use('github/copilot.vim')
  --  use({
    --  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --  config = function()
      --  require("lsp_lines").setup()
    --  end,
  --  })
  use({
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup()
    end,
  })

  -- LSP
  use {
    "williamboman/mason.nvim",
    --  run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }
  use 'williamboman/mason-lspconfig.nvim'
  use('neovim/nvim-lspconfig')
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-nvim-lsp-signature-help')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-buffer')
  use('nvim-lua/lsp-status.nvim')
  --  use('jose-elias-alvarez/null-ls.nvim')
  use('MunifTanjim/eslint.nvim')

  -- Language Specific
  use('simrat39/rust-tools.nvim')
  -- use('jose-elias-alvarez/nvim-lsp-ts-utils')
  --  use('mfussenegger/nvim-jdtls')

  -- Snippets
  use('hrsh7th/cmp-vsnip')
  use('hrsh7th/vim-vsnip')
  use('kitagry/vs-snippets')

  if packer_bootstrap then
    require('packer').sync()
  end
end)
