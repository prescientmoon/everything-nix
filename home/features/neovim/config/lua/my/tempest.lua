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
    pattern = H.with_default("*", opts.pattern),
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
  -- {{{ Construct opts & context
  if type(opts) == "function" then
    opts = opts(context)
  end

  if type(opts) ~= "table" then
    -- TODO: throw
    return
  end

  if type(opts.mkContext) == "function" then
    context = opts.mkContext(context)
  end
  -- }}}

  if
    opts.cond == false
    or type(opts.cond) == "function" and opts.cond(context) == false
  then
    return
  end

  if type(opts.vim) == "table" then
    recursive_assign(opts.vim, vim)
  end

  -- {{{ Keybinds
  if type(opts.keys) == "function" then
    opts.keys = opts.keys(context)
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
  -- }}}
  -- {{{ Autocmds
  if type(opts.autocmds) == "function" then
    opts.autocmds = opts.autocmds(context)
  end

  if type(opts.autocmds) == "table" then
    local autocmds = opts.autocmds

    -- Detect single autocmd passed instead of array
    if autocmds.event ~= nil then
      autocmds = { autocmds }
    end

    for _, autocmd in ipairs(autocmds) do
      M.create_autocmd(autocmd)
    end
  end
  -- }}}
  -- {{{ .setup calls
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
  -- }}}
  -- {{{ Callbacks
  if type(opts.callback) == "function" then
    opts.callback(context)
  end

  if type(opts.callback) == "table" then
    M.configure(opts.callback, context)
  end
  -- }}}
end

function M.configureMany(specs, context)
  for _, spec in ipairs(specs) do
    M.configure(spec, context)
  end
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
-- {{{ Fixup lazy spec generated by nix
function M.prepareLazySpec(spec)
  for _, module in ipairs(spec) do
    if module.package ~= nil then
      module[1] = module.package
      module.package = nil
    end

    local configType = type(module.config)
    if configType == "function" or configType == "table" then
      local previousConfig = module.config
      module.config = function(lazy, opts)
        M.configure(previousConfig, { lazy = lazy, opts = opts })
      end
    end

    if module.keys ~= nil then
      if type(module.keys) == "string" or module.keys.mapping ~= nil then
        module.keys = { module.keys }
      end

      for _, key in ipairs(module.keys) do
        if type(key) ~= "string" then
          key[1] = key.mapping
          key.mapping = nil
          if key.mode ~= nil then
            key.mode = H.string_chars(key.mode)
          end
          if key.action ~= nil then
            key[2] = key.action
            key.action = nil
          end
        end
      end
    end

    if type(module.cond) == "table" then
      local final = true
      for _, cond in ipairs(module.cond) do
        final = final and cond
      end
      module.cond = final
    end
  end
end
-- }}}

return M
