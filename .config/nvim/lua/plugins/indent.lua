return {
  {
    -- Thin indent guides. Colors come from catppuccin's indent_blankline integration
    -- (a background-filled rainbow looks like solid blocks over a transparent terminal)
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = { char = '│' },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = { filetypes = { 'alpha', 'neo-tree', 'help', 'lazy', 'mason' } },
    },
  },
}
