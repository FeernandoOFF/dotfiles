-- Render the Jetpack Compose @Preview under the cursor to a PNG and show it
-- inline, using the `compose-preview` CLI (github.com/yschimke/compose-ai-tools)
-- as the rendering backend and snacks.nvim's image module for display.
--
-- The CLI renders every @Preview in the module and fails the batch (non-zero
-- exit, no --output copy) if ANY preview fails — common on real apps where a
-- few previews depend on runtime-only state. So instead of trusting the exit
-- code we read the rendered artefact straight from the module's build dir:
--   <module>/build/compose-previews/renders/<Fn>*.png            (success)
--   <module>/build/compose-previews/renders/<Fn>*.png.error.json (failure)

local M = {}

local RENDERS = "build/compose-previews/renders"

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Compose Preview" })
end

-- A single, in-place-updating notification for the render lifecycle (start →
-- streamed build progress → final status). Reusing the id makes snacks replace
-- it instead of stacking a new toast per line.
local function status(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, {
    title = "Compose Preview",
    id = "compose_preview_status",
  })
end

-- Resolve the @Preview composable enclosing the cursor via treesitter.
-- Returns the function name, or nil plus a reason.
local function preview_under_cursor()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    return nil, "no treesitter node at cursor (is the kotlin parser installed?)"
  end

  local fn = node
  while fn and fn:type() ~= "function_declaration" do
    fn = fn:parent()
  end
  if not fn then
    return nil, "cursor is not inside a function"
  end

  local buf = vim.api.nvim_get_current_buf()
  local name, has_preview
  for child in fn:iter_children() do
    local t = child:type()
    if t == "simple_identifier" and not name then
      name = vim.treesitter.get_node_text(child, buf)
    elseif t == "modifiers" then
      has_preview = vim.treesitter.get_node_text(child, buf):find("Preview") ~= nil
    end
  end

  if not name then
    return nil, "could not resolve the function name"
  end
  if not has_preview then
    return nil, ("`%s` is not annotated with @Preview"):format(name)
  end
  return name
end

local function mtime(path)
  local st = vim.uv.fs_stat(path)
  return st and st.mtime.sec or -1
end

-- Newest file matching <dir>/<base>*<suffix>, or nil.
local function newest(dir, base, suffix)
  local matches = vim.fn.glob(dir .. "/" .. base .. "*" .. suffix, false, true)
  local best, best_t
  for _, p in ipairs(matches) do
    local t = mtime(p)
    if not best_t or t > best_t then
      best, best_t = p, t
    end
  end
  return best, best_t
end

-- Pull a short, human reason out of a render error.json.
local function error_reason(path)
  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  end)
  if not ok or type(data) ~= "table" then
    return "render failed (see " .. path .. ")"
  end
  local reason
  for line in (data.stackTrace or ""):gmatch("[^\n]+") do
    local caused = line:match("^Caused by:%s*(.+)$")
    if caused then
      reason = caused
    end
  end
  reason = reason or data.exception or "render failed"
  local frame = data.topAppFrame
  if frame and frame.file then
    reason = reason .. ("\n  at %s:%s"):format(frame.file, frame.line or "?")
  end
  return reason
end

M._win = nil

-- Show the image in a persistent right-hand side split (reused across renders),
-- leaving the cursor in the editor window — mirrors the xcodebuild preview UX.
local function show_image(png)
  local from = vim.api.nvim_get_current_win()

  if not (M._win and vim.api.nvim_win_is_valid(M._win)) then
    vim.cmd("botright vsplit")
    M._win = vim.api.nvim_get_current_win()
    vim.cmd("vertical resize " .. math.max(25, math.floor(vim.o.columns * 0.2)))
    vim.wo[M._win].winfixwidth = true
    vim.wo[M._win].number = false
    vim.wo[M._win].relativenumber = false
    vim.wo[M._win].signcolumn = "no"
    vim.wo[M._win].list = false
  end

  -- Focus the preview window while swapping the buffer and attaching, so snacks
  -- repaints it. Without this, re-renders into the reused window don't update.
  vim.api.nvim_set_current_win(M._win)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.api.nvim_win_set_buf(M._win, buf)
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true })
  require("snacks").image.buf.attach(buf, { src = png })

  if vim.api.nvim_win_is_valid(from) then
    vim.api.nvim_set_current_win(from)
  end
  vim.cmd("redraw")
end

-- Locate and display the freshest render artefact for `base` under `module_dir`.
local function present(module_dir, base)
  local dir = module_dir .. "/" .. RENDERS
  local png, png_t = newest(dir, base, ".png")
  local err, err_t = newest(dir, base, ".png.error.json")

  if png and (not err or png_t >= err_t) then
    -- Copy to a fresh path so snacks never shows a cached render after a re-run.
    local tmp = vim.fn.tempname() .. ".png"
    if vim.uv.fs_copyfile(png, tmp) then
      png = tmp
    end
    status(("rendered `%s`"):format(base))
    show_image(png)
  elseif err then
    status(("`%s` failed to render:\n%s"):format(base, error_reason(err)), vim.log.levels.ERROR)
  else
    status(
      ("no render found for `%s`.\nIt may not be a discovered @Preview, or the render produced nothing."):format(base),
      vim.log.levels.WARN
    )
  end
end

-- Render a preview. opts.id, when given, is an exact preview id (its PNG is
-- named after the last path segment); otherwise the @Preview under the cursor.
function M.render(opts)
  opts = opts or {}

  if vim.fn.executable("compose-preview") == 0 then
    notify(
      "`compose-preview` CLI not found on PATH.\n"
        .. "Install: curl -fsSL https://raw.githubusercontent.com/yschimke/skills/main/scripts/install.sh | bash",
      vim.log.levels.ERROR
    )
    return
  end

  local base
  if opts.id then
    base = opts.id:match("[^.]+$")
  else
    local name, reason = preview_under_cursor()
    if not name then
      return notify(reason, vim.log.levels.WARN)
    end
    base = name
  end

  local root = vim.fs.root(0, { "gradlew", "settings.gradle", "settings.gradle.kts" })
  if not root then
    return notify("could not find a Gradle project root (gradlew)", vim.log.levels.ERROR)
  end
  local module_dir = vim.fs.root(0, { "build.gradle.kts", "build.gradle" }) or root

  status(("Rendering `%s`… (first render compiles the module and may take a while)"):format(base))

  -- Stream the CLI's --progress milestones (stderr) into the status toast.
  local pending = ""
  local function on_stderr(_, data)
    if not data then
      return
    end
    pending = pending .. data
    local last
    while true do
      local nl = pending:find("\n")
      if not nl then
        break
      end
      local line = pending:sub(1, nl - 1):gsub("%s+$", "")
      pending = pending:sub(nl + 1)
      if line ~= "" then
        last = line
      end
    end
    if last then
      vim.schedule(function()
        status(("Rendering `%s`…\n%s"):format(base, last))
      end)
    end
  end

  vim.system(
    { "compose-preview", "render", "--filter", base, "--progress" },
    { cwd = root, text = true, stderr = on_stderr },
    function(res)
      vim.schedule(function()
        -- Non-zero exit is expected when *other* previews in the module fail;
        -- our target may still have rendered, so always inspect the build dir.
        present(module_dir, base)
      end)
    end
  )
end

return M
