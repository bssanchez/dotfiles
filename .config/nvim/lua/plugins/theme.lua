return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    require('catppuccin').setup {
      flavour = 'macchiato', -- latte, frappe, macchiato, mocha
      transparent_background = true, -- Let kitty's opacity + hyprland blur show through
      float = {
        transparent = true, -- Floats (hover, telescope, blink) also see-through
        solid = false, -- Keep rounded borders on floats
      },
      term_colors = true, -- :terminal uses catppuccin palette
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        keywords = { 'italic' },
      },
      lsp_styles = {
        inlay_hints = { background = false }, -- A solid bg on inlay hints looks like patches over the blur
        underlines = { -- Wavy underlines (needs TERM=xterm-kitty)
          errors = { 'undercurl' },
          warnings = { 'undercurl' },
          hints = { 'undercurl' },
          information = { 'undercurl' },
        },
      },
      auto_integrations = true, -- Detect installed plugins (lazy.nvim) and theme them
      integrations = {
        blink_cmp = { style = 'bordered' },
        indent_blankline = { enabled = true, scope_color = 'lavender', colored_indent_levels = false },
      },
      custom_highlights = function(colors)
        return {
          -- Readable separators/borders over a transparent background
          WinSeparator = { fg = colors.surface1 },
          FloatBorder = { fg = colors.lavender },
          FloatTitle = { fg = colors.lavender, style = { 'bold' } },
          CursorLineNr = { fg = colors.lavender, style = { 'bold' } },
          LineNr = { fg = colors.overlay0 },
          NeoTreeWinSeparator = { fg = colors.surface1 },
          NeoTreeNormal = { bg = 'NONE' },
          NeoTreeNormalNC = { bg = 'NONE' },
          -- Visual selection needs contrast against whatever is behind the blur
          Visual = { bg = colors.surface1, style = { 'bold' } },
          -- Completion menu selection
          PmenuSel = { bg = colors.surface1, fg = 'NONE' },
        }
      end,
    }

    vim.cmd.colorscheme 'catppuccin-macchiato'
  end,
}
