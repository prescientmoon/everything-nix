local M = {}

-- {{{ General helpers
local function string_chars(str)
  local chars = {}
  for i = 1, #str do
    table.insert(chars, str:sub(i, i))
  end
  return chars
end

local function with_default(default, given)
  if given == nil then
    return default
  else
    return given
  end
end
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

  vim.keymap.set(
    string_chars(with_default("n", opts.mode)),
    opts.mapping,
    opts.action,
    {
      desc = opts.desc,
      buffer = with_default(buffer, opts.buffer),
      expr = opts.expr,
      silent = with_default(true, opts.silent),
    }
  )
end
-- }}}
-- {{{ Autocmds
function M.create_autocmd(opts)
  local callback

  if type(opts.callback) == "function" then
    callback = opts.callback
  end

  if type(opts.callback) == "table" then
    callback = function(event)
      M.configure(opts.callback, event)
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
    and context.opts ~= nil
    and vim.inspect(context.opts) ~= "{}"
    and context.lazy ~= nil
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
-- }}}

return M
