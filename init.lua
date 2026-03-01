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
keymap({"n", "v"}, "<leader>E", "<cmd>lua require('vscode').action('workbench.files.action.focusFilesExplorer')<CR>")  
keymap({"n", "v"}, "<leader>G", "<cmd>lua require('vscode').action('workbench.scm.focus')<CR>")  
keymap({"n", "v"}, "<leader>R", "<cmd>lua require('vscode').action('workbench.view.extension.references-view')<CR>")  
keymap({"n", "v"}, "gh", "<cmd>lua require('vscode').action('editor.action.showHover')<CR>")  
keymap({"n", "v"}, "gr", "<cmd>lua require('vscode').action('editor.action.goToReferences')<CR>")  
keymap({"n", "v"}, "gR", "<cmd>lua require('vscode').action('references-view.findReferences')<CR>")  
keymap({"n", "v"}, "gj", "<cmd>lua require('vscode').action('workbench.action.joinAllGroups')<CR>")  
keymap({"n", "v"}, "gX", "<cmd>lua require('vscode').action('workbench.action.closeAllEditors')<CR>")  
keymap({"n", "v"}, "gE", "<cmd>lua require('vscode').action('workbench.files.action.showActiveFileInExplorer')<CR>")  
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
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
        local mc = require("multicursor-nvim")
        mc.setup()

        -- Add or skip cursor above/below the main cursor.
        -- keymap({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end)
        -- keymap({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end)
        -- keymap({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end)
        -- keymap({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end)

        -- Add or skip adding a new cursor by matching word/selection
        keymap({"n", "x"}, "<leader>n", function() mc.matchAddCursor(1) end)
        keymap({"n", "x"}, "<leader>m", function() mc.matchSkipCursor(1) end)
        keymap({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end)
        keymap({"n", "x"}, "<leader>M", function() mc.matchSkipCursor(-1) end)
        -- Add a cursor for all matches of cursor word/selection in the document.
        keymap({"n", "x"}, "<leader>t", mc.matchAllAddCursors)

        -- Add and remove cursors with control + left click.
        -- keymap("n", "<c-leftmouse>", mc.handleMouse)
        -- keymap("n", "<c-leftdrag>", mc.handleMouseDrag)
        -- keymap("n", "<c-leftrelease>", mc.handleMouseRelease)

        -- Disable and enable cursors.
        keymap({"n", "x"}, "<leader>c", mc.toggleCursor)

        -- Mappings defined in a keymap layer only apply when there are
        -- multiple cursors. This lets you have overlapping mappings.
        mc.addKeymapLayer(function(layerSet)

            -- Select a different cursor as the main one.
            -- layerSet({"n", "x"}, "<left>", mc.prevCursor)
            -- layerSet({"n", "x"}, "<right>", mc.nextCursor)

            -- Delete the main cursor.
            -- layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

            -- Enable and clear cursors using escape.
            layerSet("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)

        -- Customize how cursors look.
        -- local hl = vim.api.nvim_set_hl
        -- hl(0, "MultiCursorCursor", { link = "Cursor" })
        -- hl(0, "MultiCursorVisual", { link = "Visual" })
        -- hl(0, "MultiCursorSign", { link = "SignColumn"})
        -- hl(0, "MultiCursorMatchPreview", { link = "Search" })
        -- hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
        -- hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        -- hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
    end
  }
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
