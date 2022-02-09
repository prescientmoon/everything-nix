local global = require("my.helpers").global

local M = {}

function M.setup()
    -- Viewer method
    global("vimtex_view_method", "zathura")
end

return M
