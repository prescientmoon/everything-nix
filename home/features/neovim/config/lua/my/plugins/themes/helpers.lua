local theme = require("nix.theme").name

local M = {}

function M.theme_contains(name)
  return string.find(theme, name) ~= nil
end

function M.variant(name)
  -- +1 for 1-indexed strings and +1 for the space between name and variant
  return string.lower(string.sub(theme, string.len(name) + 2))
end

return M
