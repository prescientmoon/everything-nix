local K = require("my.keymaps")
local M = {}

function M.setup()
  --{{{ Register keybinds
  K.nmap("<leader>vp", ":VimuxPromptCommand<CR>", "[V]imux: [p]rompt for command")
  K.nmap("<leader>vc", ':VimuxRunCommand "clear"<CR>', "[V]imux: [c]lear pane")
  K.nmap(
    "<leader>vl",
    ":VimuxRunLastCommand<CR>",
    "[V]imux: rerun [l]ast command"
  )
  --}}}
  --{{{ Register which-key docs
  local status, wk = pcall(require, "which-key")

  if status then
    wk.register({
      ["<leader>v"] = {
        name = "vimux",
      },
    })
  end
  --}}}
end

return M
