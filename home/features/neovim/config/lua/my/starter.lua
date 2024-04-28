-- This is a modified version of mini.starter
-- Check https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/starter.lua

local M = {}
local H = {}

-- {{{ Setup
M.setup = function(config)
  if config and config.header then
    M.config.header = config.header
  end

  local augroup = vim.api.nvim_create_augroup("M", {})

  local on_vimenter = function()
    if vim.fn.argc() > 0 then
      return
    end

    H.is_in_vimenter = true
    M.open()
  end

  vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    nested = true,
    once = true,
    callback = on_vimenter,
    desc = "Open on VimEnter",
  })

  local set_default_hl = function(name, data)
    data.default = true
    vim.api.nvim_set_hl(0, name, data)
  end

  set_default_hl("MiniStarterFooter", { link = "Title" })
  set_default_hl("MiniStarterHeader", { link = "Title" })
end
-- }}}
-- {{{ Open
M.open = function(buf_id)
  -- Ensure proper buffer and open it
  if H.is_in_vimenter then
    buf_id = vim.api.nvim_get_current_buf()
  end

  if buf_id == nil or not vim.api.nvim_buf_is_valid(buf_id) then
    buf_id = vim.api.nvim_create_buf(false, true)
  end

  vim.api.nvim_set_current_buf(buf_id)

  -- {{{ Autocmds
  local augroup = vim.api.nvim_create_augroup("MBuffer", {})

  local au = function(event, callback, desc)
    vim.api.nvim_create_autocmd(
      event,
      { group = augroup, buffer = buf_id, callback = callback, desc = desc }
    )
  end

  au("VimResized", function()
    M.refresh(buf_id)
  end, "Refresh")

  local cache_showtabline = vim.o.showtabline
  au("BufLeave", function()
    if vim.o.cmdheight > 0 then
      vim.cmd("echo ''")
    end
    if vim.o.showtabline == 1 then
      vim.o.showtabline = cache_showtabline
    end
  end, "On BufLeave")
  -- }}}
  -- {{{ Buffer options
  -- Force Normal mode. NOTEs:
  -- - Using `vim.cmd('normal! \28\14')` weirdly does not work.
  -- - Using `vim.api.nvim_input([[<C-\><C-n>]])` doesn't play nice if `<C-\>`
  --   mapping is present (maybe due to non-blocking nature of `nvim_input()`).
  vim.api.nvim_feedkeys("\28\14", "nx", false)

  -- Having `noautocmd` is crucial for performance: ~9ms without it, ~1.6ms with it
  vim.cmd("noautocmd silent! set filetype=starter")

  local options = {
    -- Taken from 'vim-startify'
    "bufhidden=wipe",
    "colorcolumn=",
    "foldcolumn=0",
    "matchpairs=",
    "nobuflisted",
    "nocursorcolumn",
    "nocursorline",
    "nolist",
    "nonumber",
    "noreadonly",
    "norelativenumber",
    "nospell",
    "noswapfile",
    "signcolumn=no",
    "synmaxcol&",
    -- Differ from 'vim-startify'
    "buftype=nofile",
    "nomodeline",
    "nomodifiable",
    "foldlevel=999",
    "nowrap",
  }
  -- Vim's `setlocal` is currently more robust compared to `opt_local`
  vim.cmd(("silent! noautocmd setlocal %s"):format(table.concat(options, " ")))

  -- Hide tabline on single tab by setting `showtabline` to default value (but
  -- not statusline as it weirdly feels 'naked' without it).
  vim.o.showtabline = 1
  -- }}}

  M.refresh()

  H.is_in_vimenter = false
end
-- }}}
-- {{{ Refresh
M.refresh = function(buf_id)
  buf_id = buf_id or vim.api.nvim_get_current_buf()

  if vim.api.nvim_buf_get_option(buf_id, "ft") ~= "starter" then
    return
  end

  local config = M.config

  -- Normalize certain config values
  local header = H.normalize_header_footer(config.header)
  local footer = H.normalize_header_footer(config.footer)

  -- {{{ Evaluate content
  local header_units = {}
  for _, l in ipairs(header) do
    table.insert(
      header_units,
      { H.content_unit(l, "header", "MiniStarterHeader") }
    )
  end
  H.content_add_empty_lines(header_units, #header > 0 and 1 or 0)

  local footer_units = {}
  for _, l in ipairs(footer) do
    table.insert(
      footer_units,
      { H.content_unit(l, "footer", "MiniStarterFooter") }
    )
  end

  local content = H.concat_tables(
    H.gen_hook.aligning("center", nil, header_units, buf_id),
    H.gen_hook.aligning("center", nil, footer_units, buf_id)
  )
  content = H.gen_hook.aligning(nil, "center", content, buf_id)
  -- }}}

  -- Add content
  vim.api.nvim_buf_set_option(buf_id, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, H.content_to_lines(content))
  vim.api.nvim_buf_set_option(buf_id, "modifiable", false)

  -- {{{ Add highlighting
  for l_num, content_line in ipairs(content) do
    -- Track 0-based starting column of current unit (using byte length)
    local start_col = 0
    for _, unit in ipairs(content_line) do
      if unit.hl ~= nil then
        -- Use `priority` because of the regression bug (highlights are not stacked
        -- properly): https://github.com/neovim/neovim/issues/17358
        vim.highlight.range(
          buf_id,
          H.ns.general,
          unit.hl,
          { l_num - 1, start_col },
          { l_num - 1, start_col + unit.string:len() },
          { priority = 50 }
        )
      end
      start_col = start_col + unit.string:len()
    end
  end
  -- }}}
end

M.close = function(buf_id)
  buf_id = buf_id or vim.api.nvim_get_current_buf()

  -- Use `pcall` to allow calling for already non-existing buffer
  pcall(vim.api.nvim_buf_delete, buf_id, {})
end
-- }}}
-- {{{ Content helpers
H.gen_hook = {}

H.gen_hook.padding = function(left, top)
  left = math.max(left or 0, 0)
  top = math.max(top or 0, 0)
  return function(content, _)
    -- Add left padding
    local left_pad = string.rep(" ", left)
    for _, line in ipairs(content) do
      local is_empty_line = #line == 0 or (#line == 1 and line[1].string == "")
      if not is_empty_line then
        table.insert(line, 1, H.content_unit(left_pad, "empty", nil))
      end
    end

    -- Add top padding
    local top_lines = {}
    for _ = 1, top do
      table.insert(top_lines, { H.content_unit("", "empty", nil) })
    end
    content = vim.list_extend(top_lines, content)

    return content
  end
end

H.gen_hook.aligning = function(horizontal, vertical, content, buf_id)
  horizontal = horizontal or "left"
  vertical = vertical or "top"
  local horiz_coef = ({ left = 0, center = 0.5, right = 1.0 })[horizontal]
  local vert_coef = ({ top = 0, center = 0.5, bottom = 1.0 })[vertical]

  local win_id = vim.fn.bufwinid(buf_id)

  if win_id < 0 then
    return content
  end

  local line_strings = H.content_to_lines(content)

  -- Align horizontally
  -- Don't use `string.len()` to account for multibyte characters
  local lines_width = vim.tbl_map(function(l)
    return vim.fn.strdisplaywidth(l)
  end, line_strings)
  local min_right_space = vim.api.nvim_win_get_width(win_id)
    - math.max(unpack(lines_width))
  local left_pad = math.max(math.floor(horiz_coef * min_right_space), 0)

  -- Align vertically
  local bottom_space = vim.api.nvim_win_get_height(win_id) - #line_strings
  local top_pad = math.max(math.floor(vert_coef * bottom_space), 0)

  return H.gen_hook.padding(left_pad, top_pad)(content)
end
-- }}}
-- {{{ Helpers
-- Namespaces for highlighting
H.ns = {
  general = vim.api.nvim_create_namespace(""),
}

H.normalize_header_footer = function(x)
  if type(x) == "function" then
    x = x()
  end
  local res = tostring(x)
  if res == "" then
    return {}
  end
  return vim.split(res, "\n")
end

H.content_unit = function(string, type, hl, extra)
  return vim.tbl_extend(
    "force",
    { string = string, type = type, hl = hl },
    extra or {}
  )
end

H.content_add_empty_lines = function(content, n)
  for _ = 1, n do
    table.insert(content, { H.content_unit("", "empty", nil) })
  end
end

--- Convert content to buffer lines
---
--- One buffer line is made by concatenating `string` element of units within
--- same content line.
---
---@param content table Content "2d array"
---
---@return table Array of strings for each buffer line.
H.content_to_lines = function(content)
  return vim.tbl_map(function(content_line)
    return table.concat(
      -- Ensure that each content line is indeed a single buffer line
      vim.tbl_map(function(x)
        return x.string:gsub("\n", " ")
      end, content_line),
      ""
    )
  end, content)
end

function H.concat_tables(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end
-- }}}
-- {{{ Lazy footer
local version = vim.version()
local version_string = "🚀 "
  .. version.major
  .. "."
  .. version.minor
  .. "."
  .. version.patch
local lazy_stats = nil

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    local lazy_ok, lazy = pcall(require, "lazy")
    if lazy_ok then
      lazy_stats = {
        total_plugins = lazy.stats().count .. " Plugins",
        startup_time = math.floor(lazy.stats().startuptime * 100 + 0.5) / 100,
      }

      require("my.starter").refresh()
    end
  end,
})

function H.lazy_stats_item()
  if lazy_stats ~= nil then
    return version_string
      .. " —  🧰 "
      .. lazy_stats.total_plugins
      .. " —  🕐 "
      .. lazy_stats.startup_time
      .. "ms"
  else
    return version_string
  end
end
-- }}}

M.config = {
  header = "Hello world!",
  footer = H.lazy_stats_item,
}

return M
