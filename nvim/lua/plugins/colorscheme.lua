return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl, c)
        hl.LineNr = { fg = c.dark5 }
        hl.LineNrAbove = { fg = c.dark5 }
        hl.LineNrBelow = { fg = c.dark5 }
        hl.CursorLineNr = { fg = c.orange, bold = true }
        hl.SnacksPickerFile = { fg = c.fg }
        hl.SnacksPickerDirectory = { fg = c.blue, bold = true }
        hl.SnacksPickerPathHidden = { fg = c.fg_dark }
        hl.SnacksPickerPathIgnored = { fg = c.dark5 }
        hl.SnacksPickerGitStatus = { fg = c.orange }
        hl.SnacksPickerGitStatusUntracked = { fg = c.orange }
        hl.Directory = { fg = c.blue, bold = true }
      end,
    },
  },
}
