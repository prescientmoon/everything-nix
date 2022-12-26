local M = {}

function M.setup()
  require("moonwalk").add_loader("tl", function(src, path)
    local tl = require("tl")
    local errs = {}
    local _, program = tl.parse_program(tl.lex(src), errs)

    if #errs > 0 then
      error(
        path .. ":" .. errs[1].y .. ":" .. errs[1].x .. ": " .. errs[1].msg,
        0
      )
    end

    return tl.pretty_print_ast(program)
  end)
end

return M
