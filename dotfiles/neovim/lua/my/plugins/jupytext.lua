local env = require("my.helpers.env")

local M = {
  "goerz/jupytext.vim",
  lazy = false, -- Otherwise I can't get this to work with nvim *.ipynb
  cond = env.vscode.not_active(),
}

function M.config()
  -- Use %% as cell delimiter
  vim.g.jupytext_fmt = "py:percent"
end

function M.init()
  vim.cmd([[
        function GetJupytextFold(linenum)
            if getline(a:linenum) =~ "^#\\s%%"
                " start fold
                return ">1"
            elseif getline(a:linenum + 1) =~ "^#\\s%%"
                return "<1"
            else
                return "-1"
            endif
        endfunction
      ]])

  -- Set the correct foldexpr
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.ipynb" },
    group = vim.api.nvim_create_augroup("JupytextFoldExpr", {}),
    callback = function()
      vim.cmd([[
            setlocal foldexpr=GetJupytextFold(v:lnum)
            setlocal foldmethod=expr
            " Deletes and pastes all text. Used to refresh folds.
            :norm ggVGdpggdd
          ]])
    end,
  })
end

return M
