local o = vim.o -- behaves like :set

--------------------------------------------------------------------------------
-- Editor Settings
--------------------------------------------------------------------------------

-- disable netrw (netrw is the file explorer)
--  vim.g.loaded_netrw = 1
--  vim.g.loaded_netrwPlugin = 1

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true -- On pressing tab, insert 4 spaces

-- Persistent undo
o.undodir = vim.fn.expand('~/.vimdid')
o.undofile = true

-- Spellcheck
o.spelllang = 'en_gb'
o.spell = true

-- Sane splits
o.splitbelow = true
o.splitright = true

-- use system clipboard
o.clipboard = "unnamedplus"

o.mouse = 'a' -- enable mouse
vim.wo.number = true -- enable line numbers
o.relativenumber = true -- relative line numbers
o.signcolumn = 'yes'

o.completeopt = 'menu,menuone,noselect' -- completion options

vim.g.AutoPairsMultilineClose = 0 -- disable autopairs closing multiline pairs

-- stop autocompletion on every key press
-- o.completeopt = { "menuone", "noinsert", "noselect" }

-- start scrolling window when we reach given offset
o.scrolloff = 6
--------------------------------------------------------------------------------
-- Keybinds
--------------------------------------------------------------------------------

-- Quick buffer switching
vim.api.nvim_set_keymap('n', '<leader><leader>', ':b#<CR>', { noremap = true, silent = true })

-- Quick save
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>x', ':wq<CR>', { noremap = true, silent = true })

-- Exit insert
vim.api.nvim_set_keymap('i', '<C-j>', '<Esc>', { noremap = true, silent = true })

-- Quick open file
-- vim.api.nvim_set_keymap('', '<C-p>', ':Files<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>;', ':Buffers<CR>', { noremap = true, silent = true })

-- Ctrl-h stops search
vim.api.nvim_set_keymap('n', '<C-h>', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-h>', ':nohlsearch<CR>', { noremap = true, silent = true })

-- Open new file adjacent to current file
vim.api.nvim_set_keymap('n', '<leader>e', ':e <C-R>=expand("%:p:h")."/"<CR>', { noremap = true, silent = true })

-- Arrow keys to cycle through buffers
vim.api.nvim_set_keymap('n', '<Left>', ':bp<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Right>', ':bn<CR>', { noremap = true, silent = true })

-- nvim-tree
vim.api.nvim_set_keymap('n', '<f2>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
vim.keymap.set('n', '<leader>fb', builtin.buffers)
vim.keymap.set('n', '<leader>fh', builtin.help_tags)
vim.keymap.set('n', '<leader>fd', builtin.diagnostics)
vim.keymap.set('n', '<leader>fc', builtin.git_commits)

-- Copilot
--  vim.keymap.set('i', '<M-#>', '<Plug>(copilot-next)')
--  vim.keymap.set('i', '<M-p>', '<Plug>(copilot-previous)')

-- Bufferline pick
vim.api.nvim_set_keymap('n', 'gb', ':BufferLinePick<CR>', { noremap = true, silent = true })
-- Bufferline pin
vim.api.nvim_set_keymap('n', '<leader>p', ':BufferLineTogglePin<CR>', { noremap = true, silent = true })

--------------------------------------------------------------------------------
-- Autocommands
--------------------------------------------------------------------------------

-- Remember cursor position
--  vim.cmd([[
--  augroup vimrc-remember-cursor-position  
    --  autocmd!  
    --  autocmd BufReadPost \* if line("'\\"") > 1 && line("'\\"") <= line("$") | exe "normal! g`\"" | call timer\_start(1, {tid -> execute("normal! zz")})  | endif  
--  augroup END
--  ]])

-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_exec('silent! normal! g`"zv', false)
    end,
})

-- Auto open nvim tree
--  local function open_nvim_tree(data)
  --  -- buffer is a real file on the disk
  --  local real_file = vim.fn.filereadable(data.file) == 1
  --  if real_file then
    --  require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
  --  else
    --  require("nvim-tree.api").tree.open()
  --  end
--  end
--  vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Auto close nvim tree
local function tab_win_closed(winnr)
  local api = require"nvim-tree.api"
  local tabnr = vim.api.nvim_win_get_tabpage(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local buf_info = vim.fn.getbufinfo(bufnr)[1]
  local tab_wins = vim.tbl_filter(function(w) return w~=winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
  local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
  if buf_info.name:match(".*NvimTree_%d*$") then            -- close buffer was nvim tree
    -- Close all nvim tree on :q
    if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below)
      api.tree.close()
    end
  else                                                      -- else closed buffer was normal buffer
    if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab
      local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
      if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree
        vim.schedule(function ()
          if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim
            vim.cmd "quit"                                        -- then close all of vim
          else                                                  -- else there are more tabs open
            vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab
          end
        end)
      end
    end
  end
end

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function ()
    local winnr = tonumber(vim.fn.expand("<amatch>"))
    vim.schedule_wrap(tab_win_closed(winnr))
  end,
  nested = true
})
