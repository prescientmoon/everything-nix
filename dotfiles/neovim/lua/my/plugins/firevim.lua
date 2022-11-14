local M = {}

function M.setup()
  vim.g.firenvim_config = {
    localSettings = {
      ['.*'] = {
        filename = '/tmp/firevim_{hostname}_{pathname%10}_{timestamp%32}.{extension}',
      }
    }
  }
end

return M
