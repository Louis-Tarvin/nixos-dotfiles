-- Setup status line
require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'edge',
    component_separators = { left = '|', right = '|' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = { 'packer', 'NvimTree' },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      'filename',
      'filesize',
      'branch',
      'diff',
      --  { 'diagnostics', sources = { 'nvim_diagnostic', 'coc' } },
    },
    -- lualine_c = {'filename'},
    lualine_c = { 'diagnostics', 'lsp_progress' },
    --  lualine_c = { 'require\'lsp-status\'.status()' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})

-- Setup bufferline
require('bufferline').setup({
  options = {
    offsets = {
      { filetype = "NvimTree", text = "", padding = 1 },
      { filetype = "neo-tree", text = "", padding = 1 },
      { filetype = "Outline", text = "", padding = 1 },
    },
    buffer_close_icon = "x",
    modified_icon = "",
    close_icon = "",
    max_name_length = 14,
    max_prefix_length = 13,
    tab_size = 18,
    separator_style = "slant",
  },
  --  highlights = {
    --  fill = {
      --  fg = '#c5c8c6',
      --  bg = '#373b41',
    --  },
    --  background = {
      --  fg = '#c5c8c6',
      --  bg = '#373b41',
    --  },
    --  close_button = {
      --  fg = '#c5c8c6',
      --  bg = '#373b41',
    --  },
    --  close_button_visible = {
      --  fg = '#c5c8c6',
      --  bg = '#282a2e',
    --  },
    --  close_button_selected = {
      --  fg = '#c5c8c6',
      --  bg = '#1d1f21',
    --  },
    --  modified = {
      --  fg = '#c5c8c6',
      --  bg = '#373b41',
    --  },
    --  modified_visible = {
      --  fg = '#c5c8c6',
      --  bg = '#282a2e',
    --  },
    --  modified_selected = {
      --  fg = '#c5c8c6',
      --  bg = '#1d1f21',
    --  },
    --  buffer_visible = {
      --  fg = '#969896',
      --  bg = '#282a2e',
    --  },
    --  buffer_selected = {
      --  fg = '#c5c8c6',
      --  bg = '#1d1f21',
    --  }
  --  }
})

-- Setup Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "rust", "toml" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

-- Colour scheme
vim.o.termguicolors = true
--  local base16 = require 'base16'
--  base16(base16.themes['tomorrow-night'], true)
--  vim.g.edge_style = 'neon'
vim.cmd('colorscheme edge')

-- Make spell checker underline instead of highlight
vim.cmd([[
hi clear SpellBad
hi clear SpellCap
hi clear SpellLocal
hi clear SpellRare
hi SpellBad gui=underline
hi VertSplit guifg=#282a2e guibg=bg
hi SignColumn guibg=bg
hi LineNr guibg=bg
hi GitSignsAdd guifg=#b5bd68 guibg=bg
hi GitSignsDelete guifg=#cc6666 guibg=bg
hi GitSignsChange guifg=#de935f guibg=bg
hi EndOfBuffer guifg=bg
hi IndentBlanklineChar guifg=#535C6A guibg=bg
]])
