local M = {}

function M.split(text, sep)
  ---@diagnostic disable-next-line: redefined-local
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  text:gsub(pattern, function(c)
    fields[#fields + 1] = c
  end)
  return fields
end

return M
