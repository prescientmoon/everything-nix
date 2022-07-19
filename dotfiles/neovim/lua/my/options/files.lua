local au = require("my.helpers.augroup")
local M = {}

local syntaxFiles = {hkf = "hkf"}

function M.setup()
    au.augroup("myfiledetection", function()
        for extension, syntax in pairs(syntaxFiles) do
            au.autocmd("BufnewFile,BufRead", "*." .. extension,
                       "setf " .. syntax)
        end
    end)
end

return M
