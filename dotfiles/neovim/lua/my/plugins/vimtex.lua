local global = require("my.helpers").global

local M = {}

function M.setup()
    -- Viewer method
    global("vimtex_view_method", "zathura")
    global("Tex_DefaultTargetFormat", "pdf")
    global("vimtex_compiler_latexmk", {options = {"-pdf", "-shell-escape", "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode"}})
end

return M
