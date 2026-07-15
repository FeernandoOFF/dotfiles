-- Resource-aware "go to definition" for Android R references.
--
-- The Kotlin LSP resolves `R.string.foo` to the generated R class. This instead
-- jumps to the real resource under res/:
--   * file resources  (drawable, layout, …) → res/<type>*/<name>.*
--   * value resources (string, color, dimen, …) → <... name="<name>"> in values xml
--   * id references    → @+id/<name>
--
-- aapt sanitizes '.'/'-' to '_' in R names, so each '_' matches [._-] in the XML.

local M = {}

local FILE_TYPES = {
  drawable = true,
  mipmap = true,
  layout = true,
  menu = true,
  raw = true,
  font = true,
  anim = true,
  animator = true,
  interpolator = true,
  transition = true,
  navigation = true,
  xml = true,
}

-- Detect an `R.<type>.<name>` reference under the cursor. Returns type, name.
local function r_ref_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local init = 1
  while true do
    local s, e, typ, name = line:find("R%.([%w_]+)%.([%w_]+)", init)
    if not s then
      return nil
    end
    if col >= s and col <= e then
      return typ, name
    end
    init = e + 1
  end
end

-- aapt turns '.' and '-' into '_', so match any of them back.
local function fuzzy(name)
  return (name:gsub("_", "[._-]"))
end

local function rg(args)
  local out = vim.fn.systemlist(vim.list_extend({ "rg" }, args))
  return vim.v.shell_error <= 1 and out or {} -- rg exit 1 = no matches
end

local function resolve(typ, name, root)
  local results = {}

  if FILE_TYPES[typ] or typ == "color" then
    for _, f in ipairs(rg({ "--files", "-g", "**/res/" .. typ .. "*/" .. name .. ".*", root })) do
      results[#results + 1] = { filename = f, lnum = 1, col = 1 }
    end
  end

  if #results == 0 or typ == "id" then
    local pat = typ == "id" and ("@\\+?id/" .. fuzzy(name) .. "\\b") or ('name="' .. fuzzy(name) .. '"')
    for _, l in ipairs(rg({ "--vimgrep", "-e", pat, "-g", "**/res/**/*.xml", root })) do
      local file, lnum, coln = l:match("^(.-):(%d+):(%d+):")
      if file then
        results[#results + 1] = { filename = file, lnum = tonumber(lnum), col = tonumber(coln) }
      end
    end
  end

  return results
end

local function jump(item)
  vim.cmd("edit " .. vim.fn.fnameescape(item.filename))
  pcall(vim.api.nvim_win_set_cursor, 0, { item.lnum or 1, (item.col or 1) - 1 })
end

-- When a resource has matches in several locales, prefer the default /values/.
local function prefer_default(results)
  local def = vim.tbl_filter(function(r)
    return r.filename:match("/values/") ~= nil
  end, results)
  return #def > 0 and def or results
end

-- Jump to the Android resource under the cursor. Returns true if handled,
-- false to let the caller fall back to the LSP definition.
function M.goto_definition()
  local typ, name = r_ref_under_cursor()
  if not typ then
    return false
  end

  local root = vim.fs.root(0, { "settings.gradle", "settings.gradle.kts", "gradlew", ".git" })
  if not root then
    return false
  end

  local results = prefer_default(resolve(typ, name, root))
  if #results == 0 then
    return false
  end

  if #results == 1 then
    jump(results[1])
  else
    vim.fn.setqflist({}, " ", {
      title = ("R.%s.%s (%d)"):format(typ, name, #results),
      items = vim.tbl_map(function(r)
        return { filename = r.filename, lnum = r.lnum or 1, col = r.col or 1, text = ("R.%s.%s"):format(typ, name) }
      end, results),
    })
    jump(results[1])
    vim.cmd("copen")
  end
  return true
end

return M
