return {
  {
    -- Tmux & split window navigation
    'christoomey/vim-tmux-navigator',
  },

  {
    -- Delete buffers without closing the window that shows them (keeps neo-tree/splits layout)
    'famiu/bufdelete.nvim',
  },

  {
    -- Hints keybinds
    'folke/which-key.nvim',
  },

  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
  },

  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
  },
}
