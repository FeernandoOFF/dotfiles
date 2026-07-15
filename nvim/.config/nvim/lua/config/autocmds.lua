-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("LspNotify", {
  callback = function(event)
    if event.data.method == "textDocument/didOpen" and vim.bo[event.buf].filetype == "kotlin" then
      local win = vim.fn.bufwinid(event.buf)
      if win ~= -1 then
        vim.lsp.foldclose("imports", win)
        local lines = vim.api.nvim_buf_get_lines(event.buf, 0, -1, false)
        local import_line
        for line, text in ipairs(lines) do
          if text:match("^%s*import%s+") then
            import_line = line
            break
          end
        end
        if import_line then
          for _, delay in ipairs({ 100, 500, 1500 }) do
            vim.defer_fn(function()
              if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == event.buf then
                vim.api.nvim_win_call(win, function()
                  pcall(vim.cmd, import_line .. "foldclose")
                end)
              end
            end, delay)
          end
        end
      end
    end
  end,
  desc = "Fold Kotlin imports when opening a file",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "kotlin",
  callback = function(event)
    vim.keymap.set("n", "<leader>ci", "<cmd>KotlinQuickFix<cr>", {
      buffer = event.buf,
      desc = "Kotlin quick fix (add missing import)",
    })
  end,
  desc = "Kotlin buffer keymaps (compose preview, quick fix)",
})
vim.schedule(function()
  for _, picker in ipairs(Snacks.picker.get({ source = "explorer", tab = false })) do
    picker:close()
  end
end)

