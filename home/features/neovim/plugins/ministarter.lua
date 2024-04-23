local M = {}

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

      require("mini.starter").refresh()
    end
  end,
})

function M.lazy_stats_item()
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

return M
