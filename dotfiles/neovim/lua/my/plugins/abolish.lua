local A = require("my.abbreviations")

local M = {}

-- function M.abolish(from, to)
--   vim.cmd(":Abolish -buffer " .. from .. " " .. to)
-- end
--
-- function M.abolishMany(many)
--   for _, entry in pairs(many) do M.abolish(entry[1], entry[2]) end
-- end

local function concatTables(t1, t2)
  assert(type(t1) == "table")
  assert(type(t2) == "table")

  local t3 = {}
  for i = 1, #t1 do t3[#t3 + 1] = t1[i] end
  for i = 1, #t2 do t3[#t3 + 1] = t2[i] end
  return t3
end

local function betterAbolish(unprocessed, context, out)
  local from = unprocessed[1] or {}
  local to = unprocessed[2] or {}

  assert(type(from) == "table" and type(to) == "table",
         "Both arguments should be tables. Found " .. vim.inspect(from) .. " and " ..
             vim.inspect(to) .. " instead.")

  -- print(vim.inspect({ context = context, unprocessed = unprocessed }))

  if #from == 0 and #to == 0 then
    table.insert(out, context)
    return
  end

  for i = 1, 2, 1 do
    local head = unprocessed[i][1]
    if type(head) == "string" then
      local context_clone = { context[1], context[2] }

      context_clone[i] = context_clone[i] .. head

      local unprocessed_clone = { unprocessed[1], unprocessed[2] }
      unprocessed_clone[i] = { unpack(unprocessed[i], 2) }

      return betterAbolish(unprocessed_clone, context_clone, out)
    end
  end

  -- print(vim.inspect({ from, to, context }))

  assert(type(from[1]) == "table", vim.inspect(from) .. " starts with neither a table nor a string")
  assert(type(to[1]) == "table", vim.inspect(to) .. " does not start with a table")

  for i = 1, #from[1], 1 do
    local when = from[1][i]
    local replacement = when

    if #to[1] > 0 then replacement = to[1][((i - 1) % #to[1]) + 1] end

    assert(type(when) == "table")
    assert(type(replacement) == "table")

    local unprocessed_clone = {
      concatTables(when, { unpack(from, 2) }),
      concatTables(replacement, { unpack(to, 2) })
    }

    -- print(vim.inspect({
    --   unprocessed_clone = unprocessed_clone,
    --   when = when,
    --   replacement = replacement,
    --   from = from,
    --   to = to,
    --   i = i
    -- }))

    betterAbolish(unprocessed_clone, context, out)
  end
end

function M.betterAbolish(from, to)
  local result = {}
  betterAbolish({ from, to }, { "", "" }, result)

  return result
end

local function withCasing(input)
  local out = {}

  for i = 1, #input, 1 do
    local from = input[i][1]
    local to = input[i][2]

    table.insert(out, { from, to })
    table.insert(out, { string.upper(from), string.upper(to) })

    if #from and #to then
      table.insert(out, {
        string.upper(string.sub(from, 1, 1)) .. string.sub(from, 2),
        string.upper(string.sub(to, 1, 1)) .. string.sub(to, 2)
      })
    end
  end

  return out
end

---Parses the input for this plugin
---@param input string
---@param context {delimiters:{left:string,right:string},separator:string}
---@return nil|{positio:number,message:string}
---@return (string|table)[]|nil
local function parse(input, context)
  local position = 1
  ---@type { start:number, contents:(string|table)[] }[]
  local stack = { { start = position, contents = {} } }

  local function error(message, pos)
    return { position = pos or position, message = message }
  end

  local escaped = false
  local escapedChars = {
    ["\\"] = true,
    [context.delimiters.left] = true,
    [context.delimiters.right] = true
  }

  -- When encountering {}, instead of treating it like a single
  -- choice containing an empty string, we must treat it as an empty choice
  --
  -- The specialEmpty arg tells us whether to consider such cases.
  local function saveUp(specialEmpty)
    local prev = stack[#stack - 1].contents
    local current = stack[#stack]

    assert(type(prev[#prev]) == "table")
    ---@cast prev table

    -- If specialEmpty is true (so we are processing a '}'),
    -- we only want to keep empty strings (so those where #current.contents == 0)
    -- if we've had a , before (so #prev[#prev] > 0)
    if not specialEmpty or #current.contents > 0 or #prev[#prev] > 0 then
      table.insert(prev[#prev], current.contents)
    end
  end

  while position <= string.len(input) do
    local first = string.sub(input, position, position)
    local next = string.sub(input, position + 1, position + 1)
    local current = stack[#stack]

    if not escaped and first == "\\" and escapedChars[next] then
      escaped = true

    elseif not escaped and first == context.delimiters.left then
      table.insert(current.contents, {})
      stack[#stack + 1] = { start = position, contents = {} }
    elseif not escaped and first == context.delimiters.right then
      if #stack == 1 then
        return nil, error("Delimiter " .. context.delimiters.right .. " never opened")
      end

      -- we want special treatment for {}
      saveUp(true)

      stack[#stack] = nil
    elseif not escaped and first == context.separator and #stack > 1 then
      -- we want to treat empty strings before , as empty strings
      saveUp(false)

      current.contents = {}
    else
      local last = current.contents[#current.contents]

      if type(last) == "string" then
        current.contents[#current.contents] = last .. first
      else
        table.insert(current.contents, first)
      end

      escaped = false
    end

    position = position + 1
  end

  if #stack > 1 then
    return nil, error("Delimiter " .. context.delimiters.left .. " never closed", stack[2].start)
  end

  return stack[1].contents, nil
end

local context = { delimiters = { left = "{", right = "}" }, separator = "," }

function M.abolishMany(many)
  local total = 0

  for _, entry in pairs(many) do
    local left = parse(entry[1], context)
    local right = parse(entry[2], context)

    local abbreviations = withCasing(M.betterAbolish(left, right))
    total = total + #abbreviations

    A.manyLocalAbbr(abbreviations)
  end

  print("Added " .. total .. " abbreviations")
end

-- function M.setup()
--   local context = { delimiters = { left = "{", right = "}" }, separator = "," }
--   print(vim.inspect({ parse("abc\\d{a, d,e}dsdf\\{sdf\\}", context) }))
--   local parsed, _ = parse("ab{e,{f0,1e,d2},f,{3,4,5},\\{{000,111}\\}}cd", context)
--   -- local parsed, _ = parse("abc", context)
--   print(vim.inspect(parsed))
--   local processed = M.betterAbolish(parsed, parsed)
--   print(vim.inspect(processed))
-- end

return M
