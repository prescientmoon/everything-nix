local M = {}
local H = {}
M.helpers = H

-- {{{ General helpers
function H.with_default(default, given)
  if given == nil then
    return default
  else
    return given
  end
end

-- {{{ Strings
function H.string_chars(str)
  local chars = {}
  for i = 1, #str do
    table.insert(chars, str:sub(i, i))
  end
  return chars
end

function H.split(text, sep)
  ---@diagnostic disable-next-line: redefined-local
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  text:gsub(pattern, function(c)
    fields[#fields + 1] = c
  end)
  return fields
end
-- }}}
-- {{{ Tables
function H.mergeTables(t1, t2)
  local t3 = {}

  if t1 ~= nil then
    for k, v in pairs(t1) do
      t3[k] = v
    end
  end

  if t2 ~= nil then
    for k, v in pairs(t2) do
      t3[k] = v
    end
  end

  return t3
end
-- }}}
-- }}}
-- {{{ API wrappers
-- {{{ Keymaps
function M.set_keymap(opts, context)
  if context == nil then
    context = {}
  end

  local buffer = nil

  if context.bufnr ~= nil then
    buffer = context.bufnr
  end

  local action = opts.action

  if type(opts.action) == "function" then
    action = function()
      opts.action(context)
    end
  end

  vim.keymap.set(
    H.string_chars(H.with_default("n", opts.mode)),
    opts.mapping,
    action,
    {
      desc = opts.desc,
      buffer = H.with_default(buffer, opts.buffer),
      expr = opts.expr,
      silent = H.with_default(true, opts.silent),
    }
  )
end
-- }}}
-- {{{ Autocmds
function M.create_autocmd(opts)
  local callback

  if type(opts.action) == "function" then
    callback = opts.action
  end

  if type(opts.action) == "table" then
    callback = function(event)
      M.configure(opts.action, event)
    end
  end

  vim.api.nvim_create_autocmd(opts.event, {
    group = vim.api.nvim_create_augroup(opts.group, {}),
    pattern = opts.pattern,
    callback = callback,
  })
end
-- }}}
-- }}}
-- {{{ Main config runtime
local function recursive_assign(source, destination)
  for key, value in pairs(source) do
    if type(value) == "table" and type(destination[key]) == "table" then
      recursive_assign(value, destination[key])
    else
      destination[key] = value
    end
  end
end

function M.configure(opts, context)
  if type(opts.mk_context) == "function" then
    context = opts.mk_context(context)
  end

  if type(opts.vim) == "table" then
    recursive_assign(opts.vim, vim)
  end

  if type(opts.keys) == "table" then
    local keys = opts.keys

    -- Detect single key passed instead of array
    if keys.mapping ~= nil then
      keys = { keys }
    end

    for _, keymap in ipairs(keys) do
      M.set_keymap(keymap, context)
    end
  end

  if type(opts.autocmds) == "table" then
    local autocmds = opts.autocmds

    -- Detect single autocmd passed instead of array
    if autocmds.pattern ~= nil then
      autocmds = { autocmds }
    end

    for _, autocmd in ipairs(autocmds) do
      M.create_autocmd(autocmd)
    end
  end

  if type(opts.setup) == "table" then
    for key, arg in pairs(opts.setup) do
      require(key).setup(arg)
    end
  end

  if
    type(context) == "table"
    and context.lazy ~= nil
    and context.opts ~= nil
    and vim.inspect(context.opts) ~= "{}"
  then
    -- This is a terrible way to do it :/
    local status, module = pcall(require, context.lazy.name)
    if status then
      module.setup(context.opts)
    end
  end

  if type(opts.callback) == "function" then
    opts.callback(context)
  end
end

M.lazy = function(lazy, opts, spec)
  return M.configure(spec, { lazy = lazy, opts = opts })
end
-- }}}
-- {{{ Neovim env handling
local envs = {
  vscode = vim.g.vscode ~= nil,
  neovide = vim.g.neovide ~= nil or vim.g.nix_neovim_app == "neovide",
  firenvim = vim.g.started_by_firenvim ~= nil
    or vim.g.nix_neovim_app == "firenvim",
}

M.blacklist = function(list)
  if type(list) == "string" then
    list = { list }
  end

  for _, key in pairs(list) do
    if envs[key] then
      return false
    end
  end

  return true
end

M.whitelist = function(list)
  if type(list) == "string" then
    list = { list }
  end

  for _, key in pairs(list) do
    if not envs[key] then
      return false
    end
  end

  return true
end
-- }}}
-- {{{ Other misc thingies
function M.withSavedCursor(callback)
  local cursor = vim.api.nvim_win_get_cursor(0)
  callback()
  vim.api.nvim_win_set_cursor(0, cursor)
end
-- }}}

return M
