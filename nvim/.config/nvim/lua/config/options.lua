-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Running inside herdr (terminal multiplexer), nvim can't see Ghostty's identity,
-- so snacks.nvim assumes no graphics support and won't render images. Force it —
-- herdr renders the kitty graphics protocol itself (experimental.kitty_graphics).
vim.env.SNACKS_GHOSTTY = "1"
