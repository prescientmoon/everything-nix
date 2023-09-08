local M = {
  -- keybinds where you only hit the head once
  "anuvyklack/hydra.nvim",
  dependencies = {
    "mrjones2014/smart-splits.nvim", -- the name says it all
  },
  keys = { "<C-S-w>" },
}

-- {{{ Helpers
local function identity(x)
  return x
end

local function len(x)
  return #x
end

local function box(value, w, h)
  return { value = value, width = w, height = h }
end

local function min(l, r)
  if l < r then
    return l
  else
    return r
  end
end

local function max(l, r)
  return -min(-l, -r)
end

local function zip_with(l, r, f, default)
  local output = {}
  for i = 1, max(#l, #r), 1 do
    output[i] = f(l[i] or default, r[i] or default)
  end

  return output
end

local function flatten_list(list)
  local output = {}

  for i = 1, #list, 1 do
    for j = 1, #list[i], 1 do
      table.insert(output, list[i][j])
    end
  end

  return output
end

local function map_list(list, f)
  local output = {}
  for i = 1, #list, 1 do
    output[i] = f(list[i])
  end
  return output
end

local function l_repeat(v, times)
  if times == 0 then
    return {}
  end

  local o = {}

  for i = 1, times, 1 do
    o[i] = v
  end

  return o
end

local function s_repeat(text, times)
  local o = ""

  for _ = 1, times, 1 do
    o = o .. text
  end

  return o
end
local function string_split(text, sep)
  ---@diagnostic disable-next-line: redefined-local
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  text:gsub(pattern, function(c)
    fields[#fields + 1] = c
  end)
  return fields
end

local function table_max(list, f, default)
  if #list == 0 then
    return default
  end
  ---@diagnostic disable-next-line: redefined-local
  local f = f or identity
  local c_max = list[1]
  for i = 1, #list, 1 do
    if f(list[i]) >= f(c_max) then
      c_max = list[i]
    end
  end

  return c_max
end

local function string_value(t)
  if type(t) == "string" then
    return t
  end

  return t.value
end

local function lines(text)
  return string_split(string_value(text), "\n")
end

local function unlines(text)
  return table.concat(text, "\n")
end

local function map_lines(text, f)
  return unlines(map_list(lines(text), f))
end

local function string_width(t)
  if type(t) == "string" then
    return #table_max(lines(t), len, "")
  end

  return t.width
end

local function string_height(t)
  if type(t) == "string" then
    return #lines(t)
  end

  return t.height
end

local function half_down(num)
  return math.floor(num / 2)
end

local function half_up(num)
  return math.ceil(num / 2)
end
-- }}}
-- {{{ Hint helpers
local H = {}

function H.highlight(t)
  return box("_" .. t .. "_", string_width(t), 1)
end

function H.spacing(amount)
  return s_repeat(" ", amount)
end

function H.spacing_for(text)
  return H.spacing(string_width(text))
end

function H.spacing_largest(values)
  return H.spacing_for(table_max(values))
end

H.nojustify = { justify = "nojustify" }

function H.pad_left(text, length)
  local spaces = length - string_width(text)

  return box(
    map_lines(text, function(line)
      return H.spacing(spaces) .. line
    end),
    length,
    string_height(text)
  )
end

function H.pad_right(text, length)
  local spaces = length - string_width(text)
  return box(
    map_lines(text, function(line)
      return line .. H.spacing(spaces)
    end),
    length,
    string_height(text)
  )
end

function H.pad_around(text, length)
  local spaces = length - string_width(text)
  return box(
    map_lines(text, function(line)
      return H.spacing(half_up(spaces)) .. line .. H.spacing(half_down(spaces))
    end),
    length,
    string_height(text)
  )
end

function H.pad(text, length, justify)
  if justify == "nojustify" then
    return text
  elseif justify == "center" then
    return H.pad_around(text, length)
  elseif justify == "right" then
    return H.pad_left(text, length)
  else
    return H.pad_right(text, length)
  end
end

function H.directional(h, j, k, l, spacing_amount)
  ---@diagnostic disable-next-line: redefined-local
  local spacing_amount = spacing_amount or 1

  return H.concat_many_w({
    H.highlight(k),
    H.concat_many_h({
      H.highlight(h),
      H.spacing(spacing_amount),
      H.highlight(l),
    }),
    H.highlight(j),
  })
end

function H.add_title(title, body)
  local width = max(string_width(title), string_width(body))

  return H.concat_many_w({
    title,
    s_repeat("-", width),
    body,
  })
end

function H.concat_h(left, right, spacing_amount)
  ---@diagnostic disable-next-line: redefined-local
  local spacing_amount = spacing_amount or 0

  return box(
    unlines(zip_with(lines(left), lines(right), function(l, r)
      return l .. H.spacing(spacing_amount) .. r
    end, "")),
    string_width(left) + string_width(right) + spacing_amount,
    max(string_height(left), string_height(right))
  )
end

function H.concat_w(above, below, opts)
  ---@diagnostic disable-next-line: redefined-local
  local opts = opts or {}
  local spacing_amount = opts.spacing_amount or 0
  local justify = opts.justify or "center"
  local width = max(string_width(above), string_width(below))

  return box(
    unlines(flatten_list({
      { H.pad(above, width, justify).value },
      l_repeat(H.spacing(width), spacing_amount),
      { H.pad(below, width, justify).value },
    })),
    width,
    spacing_amount + string_height(above) + string_height(below)
  )
end

function H.concat_many_h(list, spacing_amount)
  local result = list[1]

  for i = 2, #list, 1 do
    result = H.concat_h(result, list[i], spacing_amount)
  end

  return result
end

function H.concat_many_w(list, opts)
  local result = list[1]

  for i = 2, #list, 1 do
    result = H.concat_w(result, list[i], opts)
  end

  return result
end

function H.pad_lengths_right(list)
  local max_length = table_max(list, string_width)
  return map_list(list, function(t)
    return H.concat_h(t, H.spacing(max_length - string_width(t)))
  end)
end

M.hint = H
-- }}}

local window_hint_old = [[
 ^^^^^^     Move    ^^^^^^  ^^    Size   ^^   ^^     Split
 ^^^^^^-------------^^^^^^  ^^-----------^^   ^^---------------
 ^ ^ _k_ ^ ^  ^ ^ _K_ ^ ^   ^   _<C-k>_   ^   _s_: horizontally
 _h_ ^ ^ _l_  _H_ ^ ^ _L_   _<C-h>_ _<C-l>_   _v_: vertically
 ^ ^ _j_ ^ ^  ^ ^ _J_ ^ ^   ^   _<C-j>_   ^   _q_: close
 ^^^focus^^^  ^^^window^^^  ^_=_: equalize^   _o_: close remaining
]]

local window_hint = H.concat_many_h({
  H.add_title(
    "Move",
    H.concat_h(
      H.concat_w(H.directional("h", "j", "k", "l", 3), "focus"),
      H.concat_w(
        H.directional("H", "J", "K", "L", 3),
        "window",
        { justify = "left" }
      ),
      2
    )
  ),
  H.add_title(
    "Size",
    H.concat_w(
      H.directional("<C-h>", "<C-j>", "<C-k>", "<C-l>"),
      H.concat_many_h({
        H.highlight("="),
        ": equalize",
      })
    )
  ),
  H.add_title(
    "Split",
    H.concat_many_w({
      H.concat_h(H.highlight("s"), ": horizontally"),
      H.concat_h(H.highlight("v"), ": vertical"),
      H.concat_h(H.highlight("q"), ": close"),
      H.concat_h(H.highlight("o"), ": close remaining"),
    }, { justify = "left" })
  ),
}, 3).value

print(window_hint)

function M.config()
  local Hydra = require("hydra")
  local pcmd = require("hydra.keymap-util").pcmd
  local splits = require("smart-splits")

  -- {{{ Windows
  local resize = function(direction)
    return function()
      splits["resize_" .. direction](2)
    end
  end

  Hydra({
    name = "Windows",
    hint = window_hint,
    config = {
      invoke_on_body = true,
      hint = {
        border = "rounded",
        offset = -1, -- vertical offset (larger => higher up)
      },
    },
    mode = "n",
    body = "<C-S-w>",
    heads = {
      { "h", "<C-w>h" },
      { "j", "<C-w>j" },
      { "k", "<C-w>k" },
      { "l", "<C-w>l" },

      { "H", "<C-w>H" },
      { "J", "<C-w>J" },
      { "K", "<C-w>K" },
      { "L", "<C-w>L" },

      { "<C-h>", resize("left") },
      { "<C-j>", resize("down") },
      { "<C-k>", resize("up") },
      { "<C-l>", resize("right") },
      { "=", "<C-w>=", { desc = "equalize" } },
      { "s", pcmd("split", "E36") },
      { "v", pcmd("vsplit", "E36") },
      { "o", "<C-w>o", { exit = true, desc = "remain only" } },
      { "q", pcmd("close", "E444"), { desc = "close window" } },
    },
  })
  -- }}}
end

return M
