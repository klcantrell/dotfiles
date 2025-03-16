if vim.g.vscode then
-- VS Code extension

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- remap leader key
keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- shortcut for yank to end of line
keymap("n", "Y", "y$", opts)

-- delete and paste without overwriting
keymap("v", "<leader>p", "\"_dP", opts)
keymap("v", "<leader>d", "\"_d", opts)

-- Set highlight on search
vim.o.hlsearch = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- call vscode commands from neovim
keymap({"n", "v"}, "<leader>s", "<cmd>lua require('vscode').action('workbench.action.files.save')<CR>")  
keymap({"n", "v"}, "<leader>f", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>")  
keymap({"n", "v"}, "<leader>e", "<cmd>lua require('vscode').action('editor.action.marker.nextInFiles')<CR>")  
keymap({"n", "v"}, "<leader>w", "<cmd>lua require('vscode').action('editor.action.marker.prevInFiles')<CR>")  
keymap({"n", "v"}, "<leader>a", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>")  
keymap({"n", "v"}, "gh", "<cmd>lua require('vscode').action('editor.action.showHover')<CR>")  
keymap({"n", "v"}, "gr", "<cmd>lua require('vscode').action('editor.action.goToReferences')<CR>")  
keymap({"n", "v"}, "gR", "<cmd>lua require('vscode').action('references-view.findReferences')<CR>")  
keymap({"n", "v"}, "gj", "<cmd>lua require('vscode').action('workbench.action.joinAllGroups')<CR>")  
keymap({"n", "v"}, "gX", "<cmd>lua require('vscode').action('workbench.action.closeAllEditors')<CR>")  
keymap({"n", "v"}, "<C-l>", "<cmd>lua require('vscode').action('workbench.action.focusRightGroup')<CR>")  
keymap({"n", "v"}, "<C-h>", "<cmd>lua require('vscode').action('workbench.action.focusLeftGroup')<CR>")  
keymap({"n", "v"}, "<C-j>", "<cmd>lua require('vscode').action('workbench.action.focusBelowGroup')<CR>")
keymap({"n", "v"}, "<C-k>", "<cmd>lua require('vscode').action('workbench.action.focusAboveGroup')<CR>")

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-textobjects",
}, {})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

else
-- Ordinary nvim
require "raw-init"

end
